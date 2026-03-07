import 'package:flutter/material.dart';

class EsppRsuMethodology extends StatelessWidget {
  const EsppRsuMethodology({super.key});

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
                  title: 'Employee Stock Purchase Plan (ESPP)',
                  color: Theme.of(context).colorScheme.primary,
                  content: [
                    'An ESPP allows you to buy company stock at a discount using payroll deductions.',
                    '• **Capital Invested**: `(Gross Salary * Contribution %) / (12 / Offering Period Months)`',
                    '• **Purchase Price**: Usually calculated as the End Price discounted by the Discount Rate. If the plan has a **Lookback Provision**, the discount is applied to the *lower* of the Start Price or End Price.',
                    '• **Gain**: The immediate profit you realize if you sell the shares exactly on the purchase date at the current End Price.',
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Restricted Stock Units (RSUs)',
                  color: Colors.green.shade600,
                  content: [
                    'RSUs are grants of company stock that vest over time. They are taxed as ordinary income based on their value on the vesting date.',
                    '• **Vesting Schedule**: The cliff represents the first major drop of shares. Afterwards, shares drop in smaller increments according to the frequency (e.g. quarterly).',
                    '• **Stock Appreciation**: The model compounds the stock\'s value leading up to each vesting date based on your Expected Annual Growth.',
                    '• **Pre vs Post-Tax**: You receive "Pre-Tax" shares. The company instantly sells a portion of them to cover the "Estimated Tax Rate", leaving you with the "Post-Tax" remainder.',
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
                          'Reality Check: While ESPPs with a lookback offer a nearly risk-free return if sold immediately, holding onto unvested RSUs creates concentration risk. If your company stock crashes, you risk losing both your job and a substantial portion of your net worth all at once.',
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
