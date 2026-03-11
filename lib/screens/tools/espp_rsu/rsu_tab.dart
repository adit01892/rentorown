import 'package:flutter/material.dart';
import '../../../widgets/tool_intro_banner.dart';
import 'rsu_inputs.dart';
import 'rsu_results.dart';
import 'espp_rsu_methodology.dart';

class RsuTab extends StatelessWidget {
  const RsuTab({super.key});

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
                title: 'What is the RSU Analyzer?',
                description:
                    'Model your RSU vesting schedule to understand the real value of your future stock units.',
                dataNeeded: ['Stock price estimates', 'Vesting schedule'],
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
                            Expanded(flex: 4, child: RsuInputs()),
                            SizedBox(width: 24),
                            Expanded(flex: 7, child: RsuResultsAndChart()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const EsppRsuMethodology(),
                      ],
                    );
                  }
                  return const Column(
                    children: [
                      RsuInputs(),
                      SizedBox(height: 24),
                      RsuResultsAndChart(),
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
