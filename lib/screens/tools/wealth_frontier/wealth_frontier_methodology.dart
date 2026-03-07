import 'package:flutter/material.dart';

class WealthFrontierMethodology extends StatelessWidget {
  const WealthFrontierMethodology({super.key});

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
                  title: 'Monte Carlo Simulation',
                  color: Theme.of(context).colorScheme.primary,
                  content: [
                    'This tool uses a Monte Carlo simulation (running 2,000 independent future scenarios) to project probabilistic outcomes for your wealth.',
                    '• **Expected Return**: The average annual growth of your investments.',
                    '• **Return Volatility**: The randomness injected into the market simulation each month. Higher volatility widens the gap between the 10th and 90th percentile trajectories.',
                    '• **Trajectory Range**: The chart displays the Median (50th percentile) expected outcome, surrounded by the top 10% optimistic and bottom 10% pessimistic boundaries.',
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Debt & Interest Dynamics',
                  color: Colors.red.shade400,
                  content: [
                    'Your outstanding debt compounds monthly at the assigned **Debt Interest Rate**.',
                    'Your **Allocation Strategy** determines how your Extra Monthly Cash is deployed:',
                    '• **Pay Debt First**: All extra cash aggressively eliminates debt until it reaches 0. Afterwards, cash is funneled into investments.',
                    '• **Invest First**: Minimum debt payments are assumed, and all extra cash is thrown into the volatile investment account.',
                    '• **Split 50/50**: Cash flow is split evenly between guaranteed debt reduction and market investments.',
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
                          'Reality Check: Mathematical models favor investing when expected returns (e.g. 8%) outpace debt interest (e.g. 4%). However, paying down debt offers a guaranteed, risk-free return and peace of mind that a volatile stock market cannot provide.',
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
