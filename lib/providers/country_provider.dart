import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/country_config.dart';
import '../utils/constants.dart';

class CountryNotifier extends Notifier<CountryConfig> {
  @override
  CountryConfig build() {
    final countryCode = ui.PlatformDispatcher.instance.locale.countryCode
        ?.toUpperCase();

    if (countryCode == 'GB' || countryCode == 'UK') {
      return ukConfig;
    } else if ([
      'AT',
      'BE',
      'CY',
      'EE',
      'FI',
      'FR',
      'DE',
      'GR',
      'IE',
      'IT',
      'LV',
      'LT',
      'LU',
      'MT',
      'NL',
      'PT',
      'SK',
      'SI',
      'ES',
    ].contains(countryCode)) {
      return euConfig;
    } else if (countryCode == 'US') {
      return usConfig;
    }

    // Fallback if not specifically EU or UK
    return usConfig;
  }

  void setCountry(String code) {
    if (availableCountries.containsKey(code)) {
      state = availableCountries[code]!;
    }
  }
}

final countryProvider = NotifierProvider<CountryNotifier, CountryConfig>(() {
  return CountryNotifier();
});
