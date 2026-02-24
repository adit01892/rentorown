import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/country_config.dart';
import '../utils/constants.dart';

class CountryNotifier extends Notifier<CountryConfig> {
  @override
  CountryConfig build() => ukConfig;

  void setCountry(String code) {
    if (availableCountries.containsKey(code)) {
      state = availableCountries[code]!;
    }
  }
}

final countryProvider = NotifierProvider<CountryNotifier, CountryConfig>(() {
  return CountryNotifier();
});
