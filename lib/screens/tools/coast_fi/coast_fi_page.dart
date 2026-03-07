import 'package:flutter/material.dart';
import '../../../widgets/tool_scaffold.dart';
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          if (isDesktop) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 400, child: CoastFiInputs()),
                  const SizedBox(width: 24),
                  Expanded(
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
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                CoastFiResults(),
                SizedBox(height: 16),
                CoastFiChart(),
                SizedBox(height: 16),
                CoastFiInputs(),
                SizedBox(height: 16),
                CoastFiMethodology(),
              ],
            ),
          );
        },
      ),
    );
  }
}
