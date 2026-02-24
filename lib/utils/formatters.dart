import 'package:intl/intl.dart';

String formatCurrency(double amount, {String symbol = '£'}) {
  final format = NumberFormat.currency(
    locale: 'en_US',
    symbol: symbol,
    decimalDigits: 0,
  );
  return format.format(amount);
}

String formatNumber(double number) {
  final format = NumberFormat('#,##0');
  return format.format(number);
}
