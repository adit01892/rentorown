import 'package:flutter/material.dart';

class MethodologyWidget extends StatelessWidget {
  const MethodologyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                  title: 'Buy Scenario Formula',
                  color: Theme.of(context).colorScheme.primary,
                  content: [
                    'The model projects building wealth through **leveraged property appreciation** and **mortgage amortization**.',
                    '• Property Value appreciates annually compounding at the defined Growth Rate.',
                    '• Each monthly mortgage payment pays down compounding Interest, while the rest builds Equity.',
                    '• **Costs**: We subtract ongoing unrecoverable expenses (Service Charges, Ground Rent, Maintenance) from the accumulated net worth.',
                    '• Result = (Final Property Value - Remaining Loan Balance) - Cumulative Sunk Costs.',
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Rent Scenario Formula',
                  color: Theme.of(context).colorScheme.secondary,
                  content: [
                    'The model projects building wealth through **stock market investments**.',
                    '• Initial Capital: Your starting wealth is equal to the house Deposit you didn\'t spend.',
                    '• Monthly Contributions: Standardized to be the difference between the Mortgage/House Costs and your Rent. If renting is cheaper, the surplus is invested.',
                    '• Investment Growth: The total portfolio compounds annually at the specified Investment Return rate.',
                    '• Rent increases yearly by the Annual Rent Inflation rate, which reduces your investment surplus over time.',
                    '• Result = Initial Capital + (Compounded Monthly Surplus) - Sunk Monthly Rent.',
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                _buildKeyFactors(context),
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
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          for (var text in content)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(text, style: const TextStyle(height: 1.4)),
            ),
        ],
      ),
    );
  }

  Widget _buildKeyFactors(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Factors That Influence Results',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        const Text(
          '• Time Horizon: Buying involves high friction costs (stamp duty, legal fees, massive initial deposits). Renting usually wins short-term, but Buying wins long-term as inflation destroys debt.',
        ),
        const SizedBox(height: 6),
        const Text(
          '• Leverage: An investor buying stocks uses 1x leverage. A homebuyer putting 10% down uses 10x leverage. Small property appreciation creates massive ROI on the initial cash.',
        ),
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
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Reality Check: This simulator is a mathematical model. It does not account for the emotional security of owning a home, the stress of dealing with landlords, tax brackets, or the difficulty of securing a mortgage. Financial outcomes aren\'t everything.',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
