import 'package:flutter/material.dart';
import 'package:security_toolkit/security_toolkit.dart';

class OverallSecurityReading extends StatelessWidget {
  final SecurityCheckResult result;

  const OverallSecurityReading({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceDim,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Is secure",
              style: TextTheme.of(context).displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: switch (result) {
              SecurityCheckResult(isSecureEnvironment: true) => Text(
                "True",
                style: TextTheme.of(
                  context,
                ).displaySmall?.copyWith(color: Colors.green),
                textAlign: TextAlign.center,
              ),
              SecurityCheckResult(isSecureEnvironment: false) => Text(
                "False",
                style: TextTheme.of(
                  context,
                ).displaySmall?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            },
          ),
        ],
      ),
    );
  }
}
