import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simulation_provider.dart';
import '../providers/country_provider.dart';
import '../providers/stage_provider.dart';
import '../utils/tooltip_helper.dart';

class CoreInputsWidget extends ConsumerStatefulWidget {
  const CoreInputsWidget({super.key});

  @override
  ConsumerState<CoreInputsWidget> createState() => _CoreInputsWidgetState();
}

class _CoreInputsWidgetState extends ConsumerState<CoreInputsWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  late TextEditingController _depositController;
  late TextEditingController _rentController;
  late TextEditingController _serviceChargeController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    final config = ref.read(simulationConfigProvider);
    _priceController = TextEditingController(
      text: config.propertyPrice.toInt().toString(),
    );
    _depositController = TextEditingController(
      text: config.depositAmount.toInt().toString(),
    );
    _rentController = TextEditingController(
      text: config.monthlyRent.toInt().toString(),
    );
    _serviceChargeController = TextEditingController(
      text: config.serviceChargeGroundRent.toInt().toString(),
    );
    _durationController = TextEditingController(
      text: config.durationYears.toString(),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _depositController.dispose();
    _rentController.dispose();
    _serviceChargeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    double price = double.tryParse(_priceController.text) ?? 0.0;
    double deposit = double.tryParse(_depositController.text) ?? 0.0;
    double rent = double.tryParse(_rentController.text) ?? 0.0;
    double charge = double.tryParse(_serviceChargeController.text) ?? 0.0;
    int duration = int.tryParse(_durationController.text) ?? 10;

    final notifier = ref.read(simulationConfigProvider.notifier);
    final currentConfig = ref.read(simulationConfigProvider);

    // Clamp deposit ensuring it's not greater than property price
    if (deposit > price) {
      deposit = price;
      _depositController.text = deposit.toInt().toString();
    }

    notifier.updateConfig(
      currentConfig.copyWith(
        propertyPrice: price,
        depositAmount: deposit,
        monthlyRent: rent,
        serviceChargeGroundRent: charge,
        durationYears: duration,
      ),
    );

    ref.read(stageProvider.notifier).setStage(2);
  }

  @override
  Widget build(BuildContext context) {
    final country = ref.watch(countryProvider);
    final currentStage = ref.watch(stageProvider);
    final config = ref.watch(simulationConfigProvider);
    final notifier = ref.read(simulationConfigProvider.notifier);

    // If stage 2, maybe show sliders instead of textfields, or keep text fields but remove submit button
    // According to specs, we just switch to a display and let them edit. Let's keep TextFields for consistency, but remove the large "Calculate" button.

    return Card(
      elevation: currentStage == 1 ? 4 : 2,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(currentStage == 1 ? 24.0 : 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                currentStage == 1
                    ? 'Enter Property Details'
                    : 'Property Highlights',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: currentStage == 1
                    ? TextAlign.center
                    : TextAlign.left,
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _priceController,
                label: 'Property Price',
                tooltip:
                    'The total asking price of the property you want to buy.\n\nImpact: Drives the total size of your mortgage and determines the baseline for property value appreciation.',
                prefix: country.currencySymbol,
                inputFormatters: [_decimalNumberFormatter],
                onChanged: currentStage == 2
                    ? (val) {
                        final price = _tryParsePositiveDouble(val);
                        if (price == null) return;
                        notifier.updateConfig(
                          config.copyWith(propertyPrice: price),
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _depositController,
                label: 'Deposit Amount',
                tooltip:
                    'Your upfront cash contribution towards the property.\n\nTypical: 5% - 20% of the property price.\nImpact: Reduces your mortgage size, which lowers monthly interest costs. The remainder becomes your starting net worth.',
                prefix: country.currencySymbol,
                inputFormatters: [_decimalNumberFormatter],
                onChanged: currentStage == 2
                    ? (val) {
                        final parsedDeposit = _tryParsePositiveDouble(val);
                        if (parsedDeposit == null) return;
                        double deposit = parsedDeposit;
                        if (deposit > config.propertyPrice) {
                          deposit = config.propertyPrice;
                        }
                        notifier.updateConfig(
                          config.copyWith(depositAmount: deposit),
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _rentController,
                label: 'Monthly Rent',
                tooltip:
                    'The alternative monthly cost if you choose to rent instead of buying.\n\nImpact: This is a 100% sunk cost in the Rent Scenario. Lower rent leaves more surplus cash to invest in the stock market.',
                prefix: country.currencySymbol,
                suffix: '/ mo',
                inputFormatters: [_decimalNumberFormatter],
                onChanged: currentStage == 2
                    ? (val) {
                        final rent = _tryParsePositiveDouble(val);
                        if (rent == null) return;
                        notifier.updateConfig(
                          config.copyWith(monthlyRent: rent),
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _serviceChargeController,
                label: 'Annual Service Charge / Ground Rent',
                tooltip:
                    'Mandatory yearly fees paid to a freeholder or management company (common for apartments/leaseholds).\n\nTypical: 0.5% - 2% of property value.\nImpact: Acts as a sunk cost for buyers, reducing the efficiency of building equity.',
                prefix: country.currencySymbol,
                suffix: '/ yr',
                inputFormatters: [_decimalNumberFormatter],
                onChanged: currentStage == 2
                    ? (val) {
                        final charge = _tryParsePositiveDouble(val);
                        if (charge == null) return;
                        notifier.updateConfig(
                          config.copyWith(serviceChargeGroundRent: charge),
                        );
                      }
                    : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _durationController,
                label: 'Time Horizon',
                tooltip:
                    'How many years into the future you want to project this decision.\n\nImpact: Determines how long compound interest works in your favor (for both investments and property appreciation).',
                suffix: ' Years',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  final years = int.tryParse(value ?? '');
                  if (years == null || years <= 0) {
                    return 'Enter a valid positive whole number';
                  }
                  return null;
                },
                onChanged: currentStage == 2
                    ? (val) {
                        final dur = int.tryParse(val);
                        if (dur == null || dur <= 0) return;
                        notifier.updateConfig(
                          config.copyWith(durationYears: dur),
                        );
                      }
                    : null,
              ),

              if (currentStage == 1) ...[
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text(
                    'Calculate Simulation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This simulation uses assumptions (rates, costs, inflation) you can tweak later in Advanced Settings.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF757575),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String tooltip,
    String? prefix,
    String? suffix,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(width: 4),
            buildInfoTooltip(tooltip),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType:
              keyboardType ??
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: inputFormatters ?? [_decimalNumberFormatter],
          style: const TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixText: prefix != null ? '$prefix ' : null,
            suffixText: suffix != null ? ' $suffix' : null,
          ),
          validator: validator ?? _positiveNumberValidator,
          onChanged: onChanged,
        ),
      ],
    );
  }

  static final FilteringTextInputFormatter _decimalNumberFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'));

  static String? _positiveNumberValidator(String? value) {
    final n = double.tryParse(value ?? '');
    if (n == null || n <= 0) {
      return 'Enter a valid positive number';
    }
    return null;
  }

  static double? _tryParsePositiveDouble(String value) {
    final n = double.tryParse(value);
    if (n == null || n <= 0) {
      return null;
    }
    return n;
  }
}
