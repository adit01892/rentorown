import 'package:flutter/material.dart';

class CoastFiMethodology extends StatelessWidget {
  const CoastFiMethodology({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              Icons.calculate_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              'Calculation Methodology',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: const Text('Understand how the numbers are generated'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  context,
                  title: 'Coast FI Formula (Simple Mode)',
                  color: Theme.of(context).colorScheme.primary,
                  content: [
                    'This tool models whether your current retirement savings will grow enough to fund your retirement without any additional contributions.',
                    '• **Target Portfolio**: `Desired Annual Spending / Safe Withdrawal Rate`',
                    '• **Coast FI Number**: `Target Portfolio / ((1 + Expected Return) ^ Years to Retirement)`',
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Projection Engine (Advanced Mode)',
                  color: Colors.blueGrey,
                  content: [
                    '• Simulates year-by-year portfolio growth across Pension, ISA, and GIA accounts.',
                    '• Contributions grow by your Income Growth Rate until retirement age.',
                    '• Retirement spending inflates each year after retirement using the Inflation Rate.',
                    '• Withdrawals happen in order: GIA → ISA → Pension (after pension access age).',
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Charts and FIRE Line',
                  color: Colors.orange,
                  content: [
                    '• **FIRE Number** is calculated each year as `Inflation-adjusted spending / Safe Withdrawal Rate`.',
                    '• Advanced mode charts show account balances over time plus the FIRE line.',
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Reality Check: This model assumes stable long-term returns and inflation. Real markets are volatile. Use conservative assumptions and leave a buffer. Tax implications of savings are not considered.',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Color color,
    required List<String> content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        border: Border(left: BorderSide(color: color, width: 4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          for (var text in content)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                text,
                style: const TextStyle(height: 1.4, fontSize: 13.5),
              ),
            ),
        ],
      ),
    );
  }
}
