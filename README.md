# Rent or Own

A Flutter app to compare long-term net worth and annual cashflow outcomes for:
- Buying a home
- Renting and investing the difference

The simulator includes country-specific defaults, stamp duty support, and side-by-side charts for net worth and cashflow.

## Requirements

- Flutter SDK `3.9.x` or newer
- Dart SDK `3.9.x` or newer

## Run Locally

```bash
flutter pub get
flutter run
```

## Quality Checks

```bash
flutter analyze
flutter test
```

## Core Assumptions

- Property growth, investment returns, and rent inflation are modeled as constant rates.
- Mortgage payments are amortized monthly at a fixed interest rate.
- Buying includes one-time fees, buying costs, and final-year selling costs.
- Renting invests starting capital and monthly savings versus buying.
- Results are deterministic and illustrative, not financial advice.

## Project Structure

- `lib/services/`: financial calculation logic
- `lib/providers/`: Riverpod state and derived simulation output
- `lib/widgets/`: UI components and charts
- `lib/models/`: immutable config/result models (Freezed)

## Regenerate Freezed Files

Run this after editing model fields in `lib/models/*.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```
