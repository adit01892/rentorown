import 'package:flutter/material.dart';
import '../../../widgets/tool_scaffold.dart';
import '../../../widgets/tool_intro_banner.dart';
import 'wealth_frontier_inputs.dart';
import 'wealth_frontier_results.dart';
import 'wealth_frontier_methodology.dart';

class WealthFrontierPage extends StatelessWidget {
  const WealthFrontierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ToolScaffold(
      titleOverride: 'Wealth Frontier',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Desktop Layout
                if (constraints.maxWidth > 800) {
                  return Column(
                    children: [
                      const ToolIntroBanner(
                        title: 'What is Wealth Frontier?',
                        description:
                            'Wondering whether to pay off debt or invest? Enter your balances and this tool runs 2,000 simulated futures to show you the probabilistic outcome of each strategy.',
                        dataNeeded: [
                          'Current savings',
                          'Debt balance',
                          'Monthly free cash',
                          'Interest rate',
                        ],
                        icon: Icons.trending_up_rounded,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: WealthFrontierInputs()),
                          SizedBox(width: 24),
                          Expanded(
                            flex: 7,
                            child: WealthFrontierResultsAndChart(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const WealthFrontierMethodology(),
                    ],
                  );
                }
                // Mobile Layout
                return Column(
                  children: const [
                    ToolIntroBanner(
                      title: 'What is Wealth Frontier?',
                      description:
                          'Wondering whether to pay off debt or invest? Enter your balances and this tool runs 2,000 simulated futures to show you the probabilistic outcome of each strategy.',
                      dataNeeded: [
                        'Current savings',
                        'Debt balance',
                        'Monthly free cash',
                        'Interest rate',
                      ],
                      icon: Icons.trending_up_rounded,
                    ),
                    WealthFrontierInputs(),
                    SizedBox(height: 24),
                    WealthFrontierResultsAndChart(),
                    SizedBox(height: 24),
                    WealthFrontierMethodology(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
