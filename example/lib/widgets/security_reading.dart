import 'package:flutter/material.dart';
import 'package:security_toolkit_example/utils/color_ext.dart';

class IndividualSecurityReading extends StatelessWidget {
  final String name;
  final bool value;
  final bool isEvenPosition;

  const IndividualSecurityReading({
    super.key,
    required this.name,
    required this.value,
    this.isEvenPosition = false,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: switch (isEvenPosition) {
        true => Theme.of(context).colorScheme.surface.darken(),
        false => Theme.of(context).colorScheme.surface,
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextTheme.of(context).displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: switch (value) {
              true => Text(
                "True",
                style: TextTheme.of(
                  context,
                ).displaySmall?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              false => Text(
                "False",
                style: TextTheme.of(
                  context,
                ).displaySmall?.copyWith(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            },
          ),
        ],
      ),
    );
  }
}
