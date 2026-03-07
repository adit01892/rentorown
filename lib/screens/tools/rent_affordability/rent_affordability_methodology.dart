import 'package:flutter/material.dart';

class RentAffordabilityMethodology extends StatelessWidget {
  const RentAffordabilityMethodology({super.key});

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
                  title: 'The 30% Gross Income Rule',
                  color: Theme.of(context).colorScheme.primary,
                  content: [
                    'This is the traditional rule of thumb used by most landlords and property managers.',
                    '• **Formula**: `Gross Monthly Income * 0.30`',
                    '• **Pros**: Very easy to calculate, widely accepted standard for lease approval.',
                    '• **Cons**: It ignores your actual post-tax take-home pay, local tax rates, and any debt obligations you might have.',
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'The 50/30/20 Rule',
                  color: Colors.purple.shade400,
                  content: [
                    'A popular budgeting framework that splits your *Net Take-Home Pay* into needs, wants, and savings.',
                    '• **Needs (50%)**: Covers rent, utilities, groceries, and debt minimums.',
                    '• **Wants (30%)**: Dinner, travel, fun.',
                    '• **Savings (20%)**: Investments and emergency fund.',
                    '• **Rent Target**: We calculate this by taking 50% of your Net Income, and subtracting your other Fixed Expenses.',
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Custom Budget Reality',
                  color: Colors.teal.shade500,
                  content: [
                    'This is the mathematically correct number based on your exact individual circumstances.',
                    '• **Formula**: `Net Monthly Income - Fixed Expenses - Savings Goals - Discretionary Spending`',
                    '• Whatever dollars remain are what you can purely afford to spend on rent without sacrificing your savings goals or lifestyle choices.',
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
                          'Reality Check: While a landlord might approve you for the "30% Gross" number, you should NEVER sign a lease based on that alone. Always look at the Custom Budget number—if it is far below the landlord\'s approval threshold, you will feel "house poor" and struggle to save.',
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
