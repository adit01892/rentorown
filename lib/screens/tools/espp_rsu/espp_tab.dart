import 'package:flutter/material.dart';
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
          child: LayoutBuilder(
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
        ),
      ),
    );
  }
}
