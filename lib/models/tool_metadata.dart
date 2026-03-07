import 'package:flutter/material.dart';

class ToolMetadata {
  final String id;
  final String title;
  final String tagline;
  final String description;
  final IconData icon;
  final String routePath;

  const ToolMetadata({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.routePath,
  });
}

// Data list for Home Page
final List<ToolMetadata> availableTools = [
  const ToolMetadata(
    id: 'rent_vs_buy',
    title: 'Rent vs. Buy',
    tagline: 'Is it better to rent or own?',
    description:
        'Find out if buying beats renting in your area with adjustable rates, inflation, and market assumptions.',
    icon: Icons.house_rounded,
    routePath: '/rent-vs-buy',
  ),
  const ToolMetadata(
    id: 'wealth_frontier',
    title: 'Wealth Frontier',
    tagline: 'Invest or pay debt?',
    description:
        'Probabilistic Monte Carlo simulation to decide whether your extra cash should go to the market or your loans.',
    icon: Icons.trending_up_rounded,
    routePath: '/wealth-frontier',
  ),
  const ToolMetadata(
    id: 'coast_fi',
    title: 'Coast FI',
    tagline: 'When can you stop saving?',
    description:
        'Calculate your "Coast Number" to see if your current nest egg will grow large enough to fund your retirement.',
    icon: Icons.sailing_rounded,
    routePath: '/coast-fi',
  ),
  const ToolMetadata(
    id: 'espp_rsu',
    title: 'ESPP/RSU Analyzer',
    tagline: 'Optimize your equity compensation.',
    description:
        'Decide the mathematically optimal time to sell your Employee Stock Purchase Plan or Restricted Stock Units.',
    icon: Icons.work_history_rounded,
    routePath: '/espp-rsu',
  ),
  const ToolMetadata(
    id: 'rent_affordability',
    title: 'Rent Affordability',
    tagline: 'What rent fits your budget?',
    description:
        'Determine a sensible rent budget built around your actual spending and savings goals, not just arbitrary rules.',
    icon: Icons.account_balance_wallet_rounded,
    routePath: '/rent-affordability',
  ),
];
