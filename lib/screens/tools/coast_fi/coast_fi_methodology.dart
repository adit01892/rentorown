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
                  title: 'Coast FI Formula',
                  color: Theme.of(context).colorScheme.primary,
                  content: [
                    'This tool models whether your current retirement savings will grow enough to fund your retirement *without* any additional contributions.',
                    '• **Target Portfolio**: Calculated algebraically as `Desired Annual Spending / Safe Withdrawal Rate`. For a \$40k spending and 4% rule, your target is \$1,000,000.',
                    '• **Coast FI Number**: Calculated by discounting your Target Portfolio backwards in time from Retirement Age to Current Age using your Expected Real Annual Return.',
                    '• **Formula**: `Target Portfolio / ((1 + Expected Return) ^ Years to Retirement)`',
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Line Chart Trajectories',
                  color: Colors.orange,
                  content: [
                    '• **Required (Orange Curve)**: The mathematical minimum you needed saved at any given age to perfectly hit your Target Portfolio at retirement WITHOUT adding further money.',
                    '• **Projected (Primary Color)**: The compounding growth of your *actual* current savings if you leave it alone until retirement.',
                    '• **Intersection**: The point where these two lines cross is technically your exact Coast FI age. If your projected line is *above* the required line today, you are already Coast FI.',
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
                          'Reality Check: This model assumes you can reliably achieve your expected "Real" (inflation-adjusted) return every single year until retirement. Real stock markets are volatile and experience prolonged bear markets. Always leave a buffer rather than coasting on the exact perfect mathematical margin.',
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
