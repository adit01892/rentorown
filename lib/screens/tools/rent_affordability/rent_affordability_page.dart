import 'package:flutter/material.dart';
import '../../../widgets/tool_scaffold.dart';
import '../../../widgets/tool_intro_banner.dart';
import 'rent_affordability_inputs.dart';
import 'rent_affordability_results.dart';
import 'rent_affordability_chart.dart';
import 'rent_affordability_methodology.dart';

class RentAffordabilityPage extends StatelessWidget {
  const RentAffordabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ToolScaffold(
      titleOverride: 'Rent Affordability',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          if (isDesktop) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const ToolIntroBanner(
                    title: 'What is the Rent Affordability Calculator?',
                    description:
                        'Go beyond the "30% rule". This calculator builds your rent budget from your actual income, expenses, and savings goals — not arbitrary percentages.',
                    dataNeeded: [
                      'Gross & net income',
                      'Fixed expenses',
                      'Savings goals',
                      'Discretionary budget',
                    ],
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 400,
                        child: RentAffordabilityInputs(),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            RentAffordabilityResults(),
                            SizedBox(height: 24),
                            RentAffordabilityChart(),
                            SizedBox(height: 24),
                            RentAffordabilityMethodology(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                ToolIntroBanner(
                  title: 'What is the Rent Affordability Calculator?',
                  description:
                      'Go beyond the "30% rule". This calculator builds your rent budget from your actual income, expenses, and savings goals — not arbitrary percentages.',
                  dataNeeded: [
                    'Gross & net income',
                    'Fixed expenses',
                    'Savings goals',
                    'Discretionary budget',
                  ],
                  icon: Icons.account_balance_wallet_rounded,
                ),
                RentAffordabilityResults(),
                SizedBox(height: 16),
                RentAffordabilityChart(),
                SizedBox(height: 16),
                RentAffordabilityInputs(),
                SizedBox(height: 16),
                RentAffordabilityMethodology(),
              ],
            ),
          );
        },
      ),
    );
  }
}
