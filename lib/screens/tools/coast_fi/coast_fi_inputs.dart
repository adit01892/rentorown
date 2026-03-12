import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import '../../../utils/tooltip_helper.dart';
import 'coast_fi_provider.dart';

class CoastFiInputs extends ConsumerWidget {
  const CoastFiInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coastFiProvider);
    final notifier = ref.read(coastFiProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coast FI Parameters',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Advanced Mode'),
              subtitle: const Text(
                'Split assets into Pension/ISA/GIA with optional allocation detail.',
              ),
              value: state.advancedMode,
              onChanged: notifier.updateAdvancedMode,
            ),
            const SizedBox(height: 8),
            _buildInputField(
              context,
              label: 'Current Age',
              tooltip: 'Your current age in years.',
              initialValue: state.currentAge.toDouble(),
              isCurrency: false,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateCurrentAge(val.toInt()),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Target Retirement Age',
              tooltip:
                  'The age at which you plan to fully retire and start drawing down your portfolio.',
              initialValue: state.retirementAge.toDouble(),
              isCurrency: false,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateRetirementAge(val.toInt()),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'End Age',
              tooltip:
                  'The age your retirement plan needs to last until.',
              initialValue: state.endAge.toDouble(),
              isCurrency: false,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateEndAge(val.toInt()),
            ),
            const SizedBox(height: 16),
            if (!state.advancedMode)
              _buildInputField(
                context,
                label: 'Current Retirement Savings',
                tooltip: 'Total amount already invested for your retirement.',
                initialValue: state.currentSavings,
                currencySymbol: currencySymbol,
                onChanged: notifier.updateCurrentSavings,
              ),
            if (!state.advancedMode) const SizedBox(height: 16),
            if (!state.advancedMode)
              _buildInputField(
                context,
                label: 'Monthly Savings',
                tooltip: 'How much you are adding each month before retirement.',
                initialValue: state.monthlySavings,
                currencySymbol: currencySymbol,
                onChanged: notifier.updateMonthlySavings,
              ),
            if (!state.advancedMode) const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Desired Annual Spending in Retirement',
              tooltip:
                  'How much you expect to spend per year in retirement (in today\'s value).',
              initialValue: state.annualSpendingRetirement,
              currencySymbol: currencySymbol,
              onChanged: notifier.updateAnnualSpendingRetirement,
            ),
            const Divider(height: 32),
            Text(
              'Assumptions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Safe Withdrawal Rate (%)',
              tooltip:
                  'The percentage of your portfolio you can safely withdraw each year in retirement (e.g. 4% rule).',
              initialValue: state.safeWithdrawalRate,
              isCurrency: false,
              currencySymbol: currencySymbol,
              suffixText: '%',
              onChanged: notifier.updateSafeWithdrawalRate,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: state.advancedMode
                  ? 'Expected Return (Simple Mode) (%)'
                  : 'Expected Real Annual Return (%)',
              tooltip:
                  'Your expected average annual return. In simple mode this should be real (inflation-adjusted).',
              initialValue: state.expectedAnnualReturn,
              isCurrency: false,
              currencySymbol: currencySymbol,
              suffixText: '%',
              onChanged: notifier.updateExpectedReturn,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Inflation Rate (%)',
              tooltip: 'Expected long-term inflation rate.',
              initialValue: state.inflationRate,
              isCurrency: false,
              currencySymbol: currencySymbol,
              suffixText: '%',
              onChanged: notifier.updateInflationRate,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Income Growth Rate (%)',
              tooltip: 'Expected annual growth of your contributions.',
              initialValue: state.incomeGrowthRate,
              isCurrency: false,
              currencySymbol: currencySymbol,
              suffixText: '%',
              onChanged: notifier.updateIncomeGrowthRate,
            ),
            if (state.advancedMode) ...[
              const Divider(height: 32),
              Text(
                'Advanced: Accounts',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildInputField(
                context,
                label: 'Pension Access Age',
                tooltip: 'Minimum age you can start drawing from your pension.',
                initialValue: state.pensionAccessAge.toDouble(),
                isCurrency: false,
                currencySymbol: currencySymbol,
                onChanged: (val) => notifier.updatePensionAccessAge(val.toInt()),
              ),
              const SizedBox(height: 16),
              _buildAccountSection(
                context,
                ref,
                title: 'Pension',
                accountKey: 'pension',
              ),
              const SizedBox(height: 16),
              _buildAccountSection(
                context,
                ref,
                title: 'ISA',
                accountKey: 'isa',
              ),
              const SizedBox(height: 16),
              _buildAccountSection(
                context,
                ref,
                title: 'GIA',
                accountKey: 'gia',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String accountKey,
  }) {
    final state = ref.watch(coastFiProvider);
    final notifier = ref.read(coastFiProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;
    final account = accountKey == 'pension'
        ? state.pension
        : accountKey == 'isa'
            ? state.isa
            : state.gia;

    final allocationTotal = account.allocationTotal();
    final allocationWarning = account.useCustomAllocation &&
        allocationTotal > 0 &&
        (allocationTotal - 100).abs() > 0.5;

    return Card(
      color: const Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInputField(
              context,
              label: 'Total',
              tooltip: 'Current balance for this account.',
              initialValue: account.startingBalance,
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateAccountBalance(accountKey, val),
            ),
            const SizedBox(height: 12),
            _buildInputField(
              context,
              label: 'Monthly Saving',
              tooltip: 'Monthly contribution to this account.',
              initialValue: account.monthlySaving,
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateAccountMonthlySaving(accountKey, val),
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Custom Allocation'),
              subtitle: const Text('Toggle to specify asset mix and returns.'),
              value: account.useCustomAllocation,
              onChanged: (value) =>
                  notifier.updateAccountUseCustom(accountKey, value),
            ),
            if (!account.useCustomAllocation)
              _buildInputField(
                context,
                label: 'Expected Return (%)',
                tooltip: 'Single return assumption for this account.',
                initialValue: account.simpleReturn,
                isCurrency: false,
                currencySymbol: currencySymbol,
                suffixText: '%',
                onChanged: (val) =>
                    notifier.updateAccountSimpleReturn(accountKey, val),
              ),
            if (account.useCustomAllocation) ...[
              const SizedBox(height: 8),
              _buildAssetRow(
                context,
                ref,
                accountKey: accountKey,
                assetKey: AssetKey.stocks,
                label: 'Stocks',
              ),
              _buildAssetRow(
                context,
                ref,
                accountKey: accountKey,
                assetKey: AssetKey.bonds,
                label: 'Bonds',
              ),
              _buildAssetRow(
                context,
                ref,
                accountKey: accountKey,
                assetKey: AssetKey.cash,
                label: 'Cash',
              ),
              _buildAssetRow(
                context,
                ref,
                accountKey: accountKey,
                assetKey: AssetKey.crypto,
                label: 'Crypto',
              ),
              _buildAssetRow(
                context,
                ref,
                accountKey: accountKey,
                assetKey: AssetKey.other,
                label: 'Other',
              ),
              if (allocationWarning)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Allocations total ${allocationTotal.toStringAsFixed(0)}%. Aim for 100%.',
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAssetRow(
    BuildContext context,
    WidgetRef ref, {
    required String accountKey,
    required AssetKey assetKey,
    required String label,
  }) {
    final state = ref.watch(coastFiProvider);
    final notifier = ref.read(coastFiProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;
    final account = accountKey == 'pension'
        ? state.pension
        : accountKey == 'isa'
            ? state.isa
            : state.gia;
    final asset = account.allocations[assetKey]!;

    return Column(
      children: [
        CheckboxListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          value: asset.enabled,
          onChanged: (value) => notifier.updateAccountAsset(
            accountKey,
            assetKey,
            enabled: value ?? false,
          ),
        ),
        if (asset.enabled)
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  context,
                  label: 'Allocation %',
                  tooltip: 'Percentage of this account in $label.',
                  initialValue: asset.allocationPercent,
                  isCurrency: false,
                  currencySymbol: currencySymbol,
                  suffixText: '%',
                  onChanged: (val) => notifier.updateAccountAsset(
                    accountKey,
                    assetKey,
                    allocationPercent: val,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  context,
                  label: 'Return %',
                  tooltip: 'Expected annual return for $label.',
                  initialValue: asset.expectedReturn,
                  isCurrency: false,
                  currencySymbol: currencySymbol,
                  suffixText: '%',
                  onChanged: (val) => notifier.updateAccountAsset(
                    accountKey,
                    assetKey,
                    expectedReturn: val,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required String tooltip,
    required double initialValue,
    required ValueChanged<double> onChanged,
    required String currencySymbol,
    bool isCurrency = true,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF616161),
                ),
              ),
            ),
            buildInfoTooltip(tooltip),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue
              .toStringAsFixed(isCurrency ? 0 : 2)
              .replaceAll('.00', ''),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          decoration: InputDecoration(
            prefixText: isCurrency ? '$currencySymbol ' : null,
            suffixText: suffixText,
          ),
          onChanged: (value) {
            final parsed = double.tryParse(value);
            if (parsed != null) {
              onChanged(parsed);
            }
          },
        ),
      ],
    );
  }
}
