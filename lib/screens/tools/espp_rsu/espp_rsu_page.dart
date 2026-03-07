import 'package:flutter/material.dart';
import '../../../widgets/tool_scaffold.dart';
import '../../../widgets/tool_intro_banner.dart';
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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: ToolIntroBanner(
                title: 'What is the ESPP / RSU Analyzer?',
                description:
                    'Analyze the true return on your Employee Stock Purchase Plan or model your RSU vesting schedule to understand the real value of your equity compensation.',
                dataNeeded: [
                  'Annual salary',
                  'Contribution %',
                  'Stock price estimates',
                  'Vesting schedule',
                ],
                icon: Icons.work_history_rounded,
              ),
            ),
            const Expanded(child: TabBarView(children: [EsppTab(), RsuTab()])),
          ],
        ),
      ),
    );
  }
}
