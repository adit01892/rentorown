import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/stage_provider.dart';
import 'widgets/core_inputs.dart';
import 'widgets/advanced_panel.dart';
import 'widgets/headline_result.dart';
import 'widgets/chart_widget.dart';

import 'widgets/disclaimer.dart';
import 'widgets/methodology_widget.dart';
import 'widgets/stage1_welcome_widget.dart';
import 'widgets/cashflow_chart_widget.dart';
import 'package:go_router/go_router.dart';
import 'screens/home/home_page.dart';
import 'screens/tools/wealth_frontier/wealth_frontier_page.dart';
import 'screens/tools/coast_fi/coast_fi_page.dart';
import 'screens/tools/espp_rsu/espp_rsu_page.dart';
import 'screens/tools/rent_affordability/rent_affordability_page.dart';
import 'widgets/tool_scaffold.dart';

void main() {
  runApp(const ProviderScope(child: HomeDecisionApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/rent-vs-buy',
      builder: (context, state) => const SimulatorPage(),
    ),
    GoRoute(
      path: '/wealth-frontier',
      builder: (context, state) => const WealthFrontierPage(),
    ),
    GoRoute(
      path: '/coast-fi',
      builder: (context, state) => const CoastFiPage(),
    ),
    GoRoute(
      path: '/espp-rsu',
      builder: (context, state) => const EsppRsuPage(),
    ),
    GoRoute(
      path: '/rent-affordability',
      builder: (context, state) => const RentAffordabilityPage(),
    ),
  ],
);

class HomeDecisionApp extends StatelessWidget {
  const HomeDecisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Aspire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052FF),
          primary: const Color(0xFF0052FF),
          secondary: const Color(0xFFFF4D4D),
          surface: const Color(0xFFF4F4F4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F4F4),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0052FF), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF0052FF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        useMaterial3: true,
      ),
    );
  }
}

class SimulatorPage extends ConsumerWidget {
  const SimulatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStage = ref.watch(stageProvider);

    return ToolScaffold(
      titleOverride: 'Rent vs Buy',
      showCountrySelector: true,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: currentStage == 1
            ? _buildStage1(context)
            : _buildStage2(context),
      ),
    );
  }

  Widget _buildStage1(BuildContext context) {
    return const Stage1WelcomeWidget();
  }

  Widget _buildStage2(BuildContext context) {
    return LayoutBuilder(
      key: const ValueKey(2),
      builder: (context, constraints) {
        // Responsive layout: Desktop vs Mobile
        if (constraints.maxWidth > 800) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 400,
                      child: Column(
                        children: [CoreInputsWidget(), AdvancedPanelWidget()],
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Expanded(
                      child: Column(
                        children: [
                          HeadlineResultWidget(),
                          ChartWidget(),
                          CashflowChartWidget(),
                          MethodologyWidget(),
                          DisclaimerWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // Mobile layout
        return const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeadlineResultWidget(),
              SizedBox(height: 16),
              ChartWidget(),
              SizedBox(height: 16),
              CashflowChartWidget(),
              SizedBox(height: 16),
              MethodologyWidget(),
              SizedBox(height: 16),
              CoreInputsWidget(),
              SizedBox(height: 16),
              AdvancedPanelWidget(),
              SizedBox(height: 16),
              DisclaimerWidget(),
            ],
          ),
        );
      },
    );
  }
}
