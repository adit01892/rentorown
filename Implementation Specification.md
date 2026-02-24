# Implementation Specification: Rent vs. Buy Simulator (Flutter Web)

## 1. Overview
This document provides technical guidance for implementing the **Home Decision Simulator** – a Flutter web application that simulates renting versus buying a property. It covers architecture, state management, calculation logic, UI components, and deployment.

## 2. Technology Stack
- **Framework:** Flutter (stable channel, latest version)
- **Target Platform:** Web (responsive design)
- **State Management:** Riverpod (or Provider) for reactive updates
- **Charting:** `fl_chart` (lightweight, customisable) or `syncfusion_flutter_charts` (if budget allows)
- **Currency/Number Formatting:** `intl` package
- **Local Storage (optional):** `shared_preferences` (web compatible via `shared_preferences_web`)
- **Analytics (future):** `firebase_analytics` or a privacy-friendly alternative
- **Testing:** `flutter_test` for unit/widget tests; integration tests for critical paths

## 3. Project Structure
```
lib/
├── main.dart                 # App entry point, MultiProvider setup
├── models/
│   ├── simulation_config.dart     # Holds all user inputs (core + advanced)
│   ├── simulation_result.dart      # Result of calculation (net worth series)
│   └── country_config.dart         # Country-specific defaults and rules
├── providers/
│   ├── simulation_provider.dart    # StateNotifier for inputs and results
│   └── country_provider.dart       # Selected country and config
├── services/
│   ├── calculator.dart             # Core calculation engine
│   └── stamp_duty_calculator.dart  # UK-specific (or extendable per country)
├── widgets/
│   ├── core_inputs.dart            # The five simplified input fields
│   ├── advanced_panel.dart         # Expandable advanced settings
│   ├── comparison_panel.dart       # Side-by-side property inputs (if toggled)
│   ├── headline_result.dart        # Large net-worth difference display
│   ├── chart_widget.dart           # Line chart (rent vs buy)
│   ├── country_selector.dart       # Dropdown/flag selector
│   └── disclaimer.dart             # Legal disclaimer widget
├── utils/
│   ├── formatters.dart              # Currency formatting with intl
│   └── constants.dart               # Default values, config keys
└── ads/                             # (Future) Ad container widgets
    ├── ad_slot_sidebar.dart
    └── ad_slot_footer.dart
```

## 4. Data Models

### 4.1. `SimulationConfig` (Immutable)
Holds all input parameters. Use `freezed` or a plain class with `copyWith`.
```dart
@immutable
class SimulationConfig {
  final double propertyPrice;
  final double serviceChargeGroundRent; // annual
  final double monthlyRent;
  final double depositAmount;
  final int durationYears;

  // Advanced fields
  final double interestRate;           // mortgage %
  final int mortgageTermYears;
  final double repairsPercentage;       // % of property price annually
  final double annualRentInflation;     // %
  final double investmentReturn;        // %
  final double propertyGrowthRate;      // %
  final double oneTimeFees;             // solicitor, survey, etc.
  final bool compareMode;               // true if showing second property
  final SimulationConfig? propertyB;     // second property config (if compareMode)

  // Constructor with defaults
  SimulationConfig({
    this.propertyPrice = 300000,
    this.serviceChargeGroundRent = 1500,
    this.monthlyRent = 1200,
    this.depositAmount = 30000,
    this.durationYears = 10,
    this.interestRate = 4.5,
    this.mortgageTermYears = 25,
    this.repairsPercentage = 1.0,
    this.annualRentInflation = 2.0,
    this.investmentReturn = 6.0,
    this.propertyGrowthRate = 3.0,
    this.oneTimeFees = 2000,
    this.compareMode = false,
    this.propertyB,
  });
}
```

### 4.2. `SimulationResult`
```dart
class SimulationResult {
  final List<NetWorthPoint> buyNetWorth;     // yearly
  final List<NetWorthPoint> rentNetWorth;
  final double finalDifference;               // buy - rent at end
  final int? breakevenYear;                   // first year buy > rent
}

class NetWorthPoint {
  final int year;
  final double amount;
}
```

### 4.3. `CountryConfig`
```dart
class CountryConfig {
  final String code;               // 'uk', 'us', 'eu'
  final String currencySymbol;
  final String currencyCode;        // 'GBP', 'USD', 'EUR'
  final double defaultInterestRate;
  final int defaultMortgageTerm;
  final double defaultRentInflation;
  final double defaultInvestmentReturn;
  final double defaultPropertyGrowth;
  final bool hasStampDuty;          // UK specific
  final bool hasPropertyTax;        // US specific
  final Map<double, double> stampDutyBands; // e.g., {0: 0, 250000: 0.05, ...}
}
```

## 5. State Management with Riverpod

### 5.1. Providers
- `countryProvider` – holds current `CountryConfig`.
- `simulationConfigProvider` (StateNotifier) – holds the current `SimulationConfig` (including propertyB if in compare mode).
- `simulationResultProvider` (Provider) – derived from config, uses `calculator` to return `SimulationResult`.
- `compareModeProvider` – simple boolean to toggle second property UI.

### 5.2. Recalculation
All inputs are bound to the notifier. When any field changes, the notifier updates the config and the result provider automatically recomputes (using `ref.watch`).

## 6. Calculation Engine (`services/calculator.dart`)

### 6.1. Core Algorithm
For a given `SimulationConfig` (single property), compute two net worth series.

**Assumptions:**
- Mortgage is repayment (capital + interest) with fixed rate.
- Deposit is paid upfront; remaining is mortgaged.
- Monthly mortgage payment calculated via standard amortisation formula.
- Rent starts at `monthlyRent` and increases annually by `annualRentInflation`.
- Service charge + ground rent are annual expenses that increase with inflation? (Default: fixed, but could optionally inflate – configurable later).
- Repairs cost is a percentage of property price, paid annually (or as a sinking fund).
- Investment return is compounded monthly on the deposit and on any monthly savings (difference between rent and mortgage+outgoings).

### 6.2. Steps
1. **Calculate monthly mortgage payment** using formula:  
   `M = P * r * (1+r)^n / ((1+r)^n - 1)`  
   where P = loan amount, r = monthly interest rate, n = total months.

2. **For each year up to `durationYears`**:
   - Compute remaining mortgage balance (using amortisation schedule).
   - Compute property value = initial price * (1 + propertyGrowthRate)^year.
   - Compute total outgoings so far (service charge, ground rent, repairs, one‑time fees).
   - Buy net worth = property value - remaining mortgage - total outgoings.
   - Rent net worth: start with deposit. Each month add savings (rent - (mortgage payment + (service charge+ground rent+repairs)/12)) if positive, subtract if negative. Compound the accumulated amount monthly at `investmentReturn/12`.

3. **Handle negative cash flow**: if mortgage+outgoings exceed rent, the renter needs to top up from savings; we model that as a reduction in invested capital.

4. **Comparison mode**: Run the same algorithm for both configs and combine results.

### 6.3. Stamp Duty (UK)
If country = UK and `hasStampDuty` true, calculate Stamp Duty as a one‑time cost added to `oneTimeFees`. Use bands (e.g., 0% up to £250k, 5% on next £675k, etc.). This should be part of the calculator, possibly delegated to a separate function.

### 6.4. Output
Return a `SimulationResult` containing the yearly net worth lists and final difference.

## 7. UI Implementation Details

### 7.1. Core Inputs Widget
- Use `Slider` and `TextField` with `NumberFormat` for currency.
- On change, call `ref.read(simulationConfigProvider.notifier).update(...)`.
- Deposit field can toggle between percentage and absolute value; show % of property price.

### 7.2. Advanced Panel
- Initially collapsed. Use `ExpansionPanelList` or custom expandable.
- Contains mortgage details, rent inflation, investment return, property growth, and a toggle for “Compare a second property”.

### 7.3. Comparison Panel
- When compare mode is true, render two columns using `Row` or `Flex`.
- Each column has its own set of inputs (core + advanced), but the region and global settings (inflation, investment return) are shared? According to product spec, the advanced settings are per property, so they must be independent. However, some fields (like investment return) might be global. Clarify: investment return applies to the renter’s portfolio, so it should be the same for both. The spec says advanced mode includes these fields, but in comparison they appear in each column – we must decide. Simpler: make investment return, rent inflation, property growth **global** (set once). Then each property has its own price, deposit, mortgage rate, service charge, etc. This is more realistic (the market conditions are the same). We'll adopt that: global parameters (investment return, rent inflation, property growth) are set outside the property columns. The mortgage interest rate could be per property (different products) – we'll include it in property-specific advanced fields.

Thus:
- Global advanced: investment return, rent inflation, property growth.
- Per property advanced: interest rate, mortgage term, repairs %, one-time fees.

### 7.4. Headline Result
- Use `AnimatedSwitcher` to update number smoothly.
- Colour code green if buying better, red if renting better.

### 7.5. Chart
- Use `LineChart` from `fl_chart`.
- Show two lines (rent, buy) in single mode, four lines in compare mode.
- Tooltips on hover.

### 7.6. Disclaimer
- A `Text` widget with grey italic style, placed directly under headline.

### 7.7. Country Selector
- Dropdown button with flag icons (using `flutter_floating` or emoji flags).
- On change, update `countryProvider` and reset defaults for inputs (keeping user modifications? Spec says “adjusts defaults” – we can either reset all inputs to new country defaults, or only update those not yet touched. Simpler: reset to defaults when country changes, with a confirmation dialog if user has made changes.)

## 8. Region Handling
- Maintain a map of `CountryConfig` in `constants.dart`.
- The `countryProvider` exposes the current config.
- Stamp duty calculation: only active for UK. For US, maybe property tax as annual cost – can be added later.

## 9. Advertising Integration (Future)
- Create placeholder widgets `AdSlotSidebar` and `AdSlotFooter` that are initially `SizedBox.shrink()`.
- When ready, replace with actual ad code. For web, this likely involves embedding JavaScript via `HtmlElementView`. Create a widget that loads an external script and displays a container.

## 10. Testing Strategy

### 10.1. Unit Tests
- Test calculation engine against known scenarios (spreadsheet verified).
- Test stamp duty bands.

### 10.2. Widget Tests
- Test that inputs update the notifier.
- Test that chart appears with data.

### 10.3. Integration Tests
- End-to-end: user enters values, sees headline change.
- Compare mode toggling.

## 11. Build & Deployment

### 11.1. Build Command
```bash
flutter build web --web-renderer canvaskit --release
```
(Canvaskit ensures consistent rendering across browsers, but slightly larger bundle. Alternative: `html` renderer for smaller size, test compatibility.)

### 11.2. Output
The `build/web` directory contains static files. Deploy to any static host.

### 11.3. SEO Considerations
- Flutter web apps are client‑rendered; for better SEO, consider using `flutter_modular` or prerendering, but for a tool this is acceptable.

## 12. Performance Optimisation
- Use `const` constructors where possible.
- Avoid unnecessary rebuilds by scoping providers (e.g., only rebuild chart when result changes).
- Use `fl_chart` with `LineChart` and set `minX`, `maxX` to avoid recalculations.
- Debounce input handling (e.g., 300ms) to prevent excessive recomputation while sliding.

## 13. Error Handling & Edge Cases
- Deposit cannot exceed property price – clamp.
- Mortgage term must be >= duration? Not necessary, but if duration > term, assume mortgage paid off and no further payments? We'll cap duration to term for simplicity? Actually, we should handle: after mortgage term, the buyer owns outright, so monthly costs drop to only outgoings. Implement logic in calculator: after mortgage paid off, set monthly mortgage payment to 0.
- Rent inflation can make rent exceed affordable – still valid.

## 14. Localisation (Future)
- Prepare for translations using `flutter_localizations` and ARB files.

## 15. Maintenance & Extensibility
- The calculator is pure Dart, easy to modify for new tax rules.
- New countries can be added by extending `CountryConfig` map.

---

This implementation spec provides a solid foundation for a development team to build the Rent vs. Buy Simulator in Flutter, ensuring it meets the product goals while remaining lightweight, extensible, and ready for future monetisation.