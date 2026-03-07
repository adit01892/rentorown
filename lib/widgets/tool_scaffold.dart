import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_footer.dart';
import '../widgets/country_selector.dart';
import '../models/tool_metadata.dart';

class ToolScaffold extends StatelessWidget {
  final Widget child;
  final String? titleOverride;
  final bool showCountrySelector;
  final bool showBackButton;
  final PreferredSizeWidget? appBarBottom;

  const ToolScaffold({
    super.key,
    required this.child,
    this.titleOverride,
    this.showCountrySelector = true,
    this.showBackButton = true,
    this.appBarBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom:
            appBarBottom ??
            PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(color: const Color(0xFFE0E0E0), height: 1.0),
            ),
        title: InkWell(
          onTap: () {
            if (GoRouterState.of(context).uri.toString() != '/') {
              context.go('/');
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: 30),
              const SizedBox(width: 10),
              Text(
                titleOverride ?? 'Aspire',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black87),
            onPressed: () {
              if (GoRouterState.of(context).uri.toString() != '/') {
                context.go('/');
              }
            },
          ),
          if (showCountrySelector) const CountrySelectorWidget(),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(child: child),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const AppLogo(size: 40),
                  const SizedBox(height: 12),
                  Text(
                    'Aspire',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(Icons.home_rounded),
                title: const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                selected: GoRouterState.of(context).uri.toString() == '/',
                selectedTileColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                selectedColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.pop(context);
                  if (GoRouterState.of(context).uri.toString() != '/') {
                    context.go('/');
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),
            ...availableTools.map((tool) {
              final isSelected =
                  GoRouterState.of(context).uri.toString() == tool.routePath;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Icon(tool.icon),
                  title: Text(
                    tool.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    tool.tagline,
                    style: const TextStyle(fontSize: 12),
                  ),
                  selected: isSelected,
                  selectedTileColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    Navigator.pop(context);
                    if (!isSelected) {
                      context.go(tool.routePath);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: const AppFooterWidget(),
    );
  }
}
