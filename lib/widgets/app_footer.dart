import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooterWidget extends StatelessWidget {
  const AppFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2C2C2C),
      elevation: 1,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Open source web app under the MIT License. ',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(
                        'https://github.com/adit01892/rentorown',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: Text(
                      'View Source',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
