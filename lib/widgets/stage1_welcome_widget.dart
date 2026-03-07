import 'package:flutter/material.dart';
import 'core_inputs.dart';
import 'app_logo.dart';

class Stage1WelcomeWidget extends StatelessWidget {
  const Stage1WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const ValueKey(1),
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 48.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 3, child: _buildIntroText(context)),
                      const SizedBox(width: 48),
                      const SizedBox(width: 400, child: CoreInputsWidget()),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Mobile fallback
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildIntroText(context),
                const SizedBox(height: 32),
                const CoreInputsWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntroText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(
          children: [
            AppLogo(size: 42),
            SizedBox(width: 12),
            Text(
              'Rent vs. Buy',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Make Your Next\nMove With Confidence',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E1E1E),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Aspire strips away the emotion and lays bare the financial reality of renting versus buying over your specified time horizon.',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF616161),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        _buildFeatureBullet(
          context,
          Icons.insights,
          'Uncover Hidden Costs',
          'Model the drag of service charges, ground rent, and routine maintenance.',
        ),
        const SizedBox(height: 16),
        _buildFeatureBullet(
          context,
          Icons.trending_up,
          'Harness Leverage',
          'See how stock market returns stack up against leveraged property appreciation.',
        ),
        const SizedBox(height: 16),
        _buildFeatureBullet(
          context,
          Icons.account_balance,
          'Detailed Analytics',
          'Break down the exact year your net worth flips between scenarios.',
        ),
      ],
    );
  }

  Widget _buildFeatureBullet(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF757575), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
