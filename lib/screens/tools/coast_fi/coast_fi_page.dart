import 'package:flutter/material.dart';
import '../../../widgets/tool_scaffold.dart';
import '../../../widgets/tool_intro_banner.dart';
import 'coast_fi_inputs.dart';
import 'coast_fi_results.dart';
import 'coast_fi_chart.dart';
import 'coast_fi_methodology.dart';

class CoastFiPage extends StatelessWidget {
  const CoastFiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ToolScaffold(
      titleOverride: 'Coast FI',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;
              if (isDesktop) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const ToolIntroBanner(
                        title: 'What is Coast FI?',
                        description:
                            'Coast FI tells you if you\'ve already saved enough that compound growth alone will fund your retirement — so you can stop aggressively saving and "coast" the rest of the way.',
                        dataNeeded: [
                          'Current age',
                          'Retirement age',
                          'Current savings',
                          'Desired retirement spending',
                        ],
                        icon: Icons.sailing_rounded,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: const CoastFiInputs()),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: const [
                                CoastFiResults(),
                                SizedBox(height: 24),
                                CoastFiChart(),
                                SizedBox(height: 24),
                                CoastFiMethodology(),
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
                      title: 'What is Coast FI?',
                      description:
                          'Coast FI tells you if you\'ve already saved enough that compound growth alone will fund your retirement — so you can stop aggressively saving and "coast" the rest of the way.',
                      dataNeeded: [
                        'Current age',
                        'Retirement age',
                        'Current savings',
                        'Desired retirement spending',
                      ],
                      icon: Icons.sailing_rounded,
                    ),
                    CoastFiInputs(),
                    SizedBox(height: 16),
                    CoastFiResults(),
                    SizedBox(height: 16),
                    CoastFiChart(),
                    SizedBox(height: 16),
                    CoastFiMethodology(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
