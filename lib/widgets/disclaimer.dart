import 'package:flutter/material.dart';

class DisclaimerWidget extends StatelessWidget {
  const DisclaimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Disclaimer: These figures are for illustrative purposes only and do not constitute financial advice. '
        'Actual returns, interest rates, and fees will vary. The simulation relies on many assumptions including '
        'fixed linear growth, constant inflation, and identical investment performance, which rarely hold true in reality.',
        style: TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
