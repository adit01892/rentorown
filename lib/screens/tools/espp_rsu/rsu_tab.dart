import 'package:flutter/material.dart';
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
          constraints: const BoxConstraints(maxWidth: 1000),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Column(
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 400, child: RsuInputs()),
                        SizedBox(width: 24),
                        Expanded(child: RsuResultsAndChart()),
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
        ),
      ),
    );
  }
}
