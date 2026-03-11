import 'package:flutter/material.dart';
import '../../../widgets/tool_intro_banner.dart';
import 'espp_inputs.dart';
import 'espp_results.dart';
import 'espp_rsu_methodology.dart';

class EsppTab extends StatelessWidget {
  const EsppTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const ToolIntroBanner(
                title: 'What is the ESPP Analyzer?',
                description:
                    'Analyze the true return on your Employee Stock Purchase Plan to understand the real value of your equity compensation.',
                dataNeeded: [
                  'Annual salary',
                  'Contribution %',
                  'Stock price estimates',
                ],
                icon: Icons.work_history_rounded,
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Column(
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 4, child: EsppInputs()),
                            SizedBox(width: 24),
                            Expanded(flex: 7, child: EsppResults()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const EsppRsuMethodology(),
                      ],
                    );
                  }
                  return const Column(
                    children: [
                      EsppInputs(),
                      SizedBox(height: 24),
                      EsppResults(),
                      SizedBox(height: 24),
                      EsppRsuMethodology(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
