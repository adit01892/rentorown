import 'package:flutter/material.dart';
import '../../../widgets/tool_scaffold.dart';
import 'espp_tab.dart';
import 'rsu_tab.dart';

class EsppRsuPage extends StatelessWidget {
  const EsppRsuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ToolScaffold(
        titleOverride: 'ESPP / RSU',
        appBarBottom: TabBar(
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: [
            Tab(text: 'ESPP Analyzer'),
            Tab(text: 'RSU Vesting'),
          ],
        ),
        child: const TabBarView(children: [EsppTab(), RsuTab()]),
      ),
    );
  }
}
