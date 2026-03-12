import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/country_provider.dart';
import 'coast_fi_provider.dart';

class CoastFiTable extends ConsumerWidget {
  const CoastFiTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coastFiProvider);
    if (!state.advancedMode) {
      return const SizedBox.shrink();
    }

    final projection =
        ref.read(coastFiProvider.notifier).computeProjection(advanced: true);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;
    final formatter = NumberFormat.currency(symbol: currencySymbol, decimalDigits: 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projection Table',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Pension')),
                  DataColumn(label: Text('ISA')),
                  DataColumn(label: Text('GIA')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Savings')),
                  DataColumn(label: Text('Spendings')),
                ],
                rows: projection.map((row) {
                  return DataRow(
                    cells: [
                      DataCell(Text(row.age.toString())),
                      DataCell(Text(formatter.format(row.pension))),
                      DataCell(Text(formatter.format(row.isa))),
                      DataCell(Text(formatter.format(row.gia))),
                      DataCell(Text(formatter.format(row.total))),
                      DataCell(Text(formatter.format(row.savings))),
                      DataCell(Text(formatter.format(row.spending))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
