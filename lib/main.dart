import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/stage_provider.dart';
import 'widgets/core_inputs.dart';
import 'widgets/advanced_panel.dart';
import 'widgets/headline_result.dart';
import 'widgets/chart_widget.dart';
import 'widgets/country_selector.dart';
import 'widgets/disclaimer.dart';
import 'widgets/methodology_widget.dart';
import 'widgets/stage1_welcome_widget.dart';
import 'widgets/cashflow_chart_widget.dart';
import 'widgets/app_logo.dart';
import 'widgets/app_footer.dart';

void main() {
  runApp(const ProviderScope(child: HomeDecisionApp()));
}

class HomeDecisionApp extends StatelessWidget {
  const HomeDecisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent or Own',
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
      home: const SimulatorPage(),
    );
  }
}

class SimulatorPage extends ConsumerWidget {
  const SimulatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStage = ref.watch(stageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(size: 30),
            SizedBox(width: 10),
            Text('Rent or Own', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE0E0E0), height: 1.0),
        ),
        actions: const [CountrySelectorWidget(), SizedBox(width: 16)],
        leading: currentStage == 2
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref.read(stageProvider.notifier).setStage(1);
                },
              )
            : null,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: currentStage == 1
              ? _buildStage1(context)
              : _buildStage2(context),
        ),
      ),
      bottomNavigationBar: const AppFooterWidget(),
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
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 360,
                child: SingleChildScrollView(
                  child: Column(
                    children: const [CoreInputsWidget(), AdvancedPanelWidget()],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      HeadlineResultWidget(),
                      ChartWidget(),
                      CashflowChartWidget(),
                      MethodologyWidget(),
                      DisclaimerWidget(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        // Mobile layout
        return const SingleChildScrollView(
          child: Column(
            children: [
              HeadlineResultWidget(),
              ChartWidget(),
              CashflowChartWidget(),
              MethodologyWidget(),
              CoreInputsWidget(),
              AdvancedPanelWidget(),
              DisclaimerWidget(),
            ],
          ),
        );
      },
    );
  }
}
