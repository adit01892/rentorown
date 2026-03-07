# Contributing to RentOrOwn Multi-Tool

Welcome! We are excited you are interested in contributing to the RentOrOwn multi-tool suite. Our goal is to create a comprehensive, open-source set of personal finance tools built entirely in Flutter Web, targeting data-driven professionals.

## Architecture Overview

The app is built using **Flutter (Dart) for Web**. It leverages a few core architectural patterns:
1.  **Routing**: `go_router` handles navigation between the `HomePage` and individual tool pages.
2.  **State Management**: `flutter_riverpod` handles reactive state. Each tool has its own localized `NotifierProvider`.
3.  **UI & Consistency**: A shared `ToolScaffold` widget ensures a consistent top app bar (with Country Selector) and footer across all tools.
4.  **Country Configurations**: We store country-specific constants and defaults in `lib/models/country_config.dart` and tool-specific default files (e.g. `rent_vs_buy_defaults.dart`). Currency symbols and assumptions adapt dynamically.

## How to Add a New Tool

1.  **Define the Metadata**: Open `lib/screens/home/home_page.dart` (or your equivalent `ToolMetadata` list) and add a new entry to the tools list. You will need a `title`, `description`, `icon`, and a unique `routePath` (e.g. `/my-new-tool`).
2.  **Add the Route**: Open `lib/main.dart` and add a `GoRoute` for your new `routePath` mapping to your new tool's top-level page widget.
3.  **Create the Directory**: Create a folder for your tool under `lib/screens/tools/my_new_tool/`.
4.  **Implement State & Defaults**:
    *   Create a data model class to hold your inputs/assumptions.
    *   Create `my_new_tool_defaults.dart` with defaults for `'us'`, `'uk'`, and `'eu'`.
    *   Create `my_new_tool_provider.dart` using `flutter_riverpod` `Notifier` that listens to `countryProvider` and resets defaults on country change.
5.  **Build the UI**:
    *   Create the inputs widget (using `TextFormField` and `Riverpod` watchers). Remember to plumb the dynamic `currencySymbol` into your inputs.
    *   Create the results/chart widget (using `fl_chart` if visualization is applicable).
    *   Combine inputs and results in `my_new_tool_page.dart`, wrapped inside a `ToolScaffold`. Use a `LayoutBuilder` to ensure a responsive side-by-side layout on desktop and stacked layout on mobile.

## Design Guidelines

*   **Colors & Themes**: Stick to the primary colour scheme defined in `main.dart`. Use `Theme.of(context).colorScheme.primary` for highlighted UI elements.
*   **Typography**: We universally use `GoogleFonts.inter`. Use semantic text styles like `Theme.of(context).textTheme.titleMedium` rather than hardcoding.
*   **Responsiveness**: Wrap major container views in a `ConstrainedBox(constraints: BoxConstraints(maxWidth: 1000))` so the UI doesn't stretch infinitely on ultrawide monitors.
*   **Heavy Mathematics**: For computationally expensive tasks (like Monte Carlo simulations), offload the calculations to background isolates using `Isolate.run(...)` combined with a `FutureBuilder` to keep the UI at 60fps.

## Running Locally

1. Ensure you have Flutter installed and configured for web development.
2. Clone the repository.
3. Run `flutter pub get` to download dependencies.
4. Run `flutter run -d chrome` to launch a local development server.

Happy Coding!
