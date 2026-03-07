import 'package:flutter/material.dart';
import '../../../widgets/tool_scaffold.dart';
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
            constraints: const BoxConstraints(maxWidth: 1000),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Desktop Layout
                if (constraints.maxWidth > 800) {
                  return Column(
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 400, child: WealthFrontierInputs()),
                          SizedBox(width: 24),
                          Expanded(child: WealthFrontierResultsAndChart()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const WealthFrontierMethodology(),
                    ],
                  );
                }
                // Mobile Layout
                return const Column(
                  children: [
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
