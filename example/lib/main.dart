import 'package:flutter/material.dart';
import 'package:security_toolkit/security_toolkit.dart';
import 'package:security_toolkit_example/widgets/overall.dart';
import 'package:security_toolkit_example/widgets/security_reading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Flutter Security Suite Example'),
            ),
            body: FutureBuilder(
              future: SecurityToolkit.checkSecureEnvironment(),
              builder:
                  (_, state) => switch (state) {
                    AsyncSnapshot(connectionState: ConnectionState.waiting) =>
                      _Loading(),
                    AsyncSnapshot(:final SecurityCheckResult data) => _Data(
                      result: data,
                    ),
                    AsyncSnapshot(:final error) => Column(
                      spacing: 8,
                      children: [Text("An error occurred"), Text(error.toString())],
                    ),
                  },
            ),
          );
        }
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Text("Loading readings..."),
        SizedBox.square(dimension: 16, child: CircularProgressIndicator()),
      ],
    );
  }
}

class _Data extends StatelessWidget {
  final SecurityCheckResult result;

  const _Data({required this.result});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        IndividualSecurityReading(
          name: "Is emulator",
          value: result.violations.contains(SecurityViolation.emulator),
        ),
        IndividualSecurityReading(
          name: "Is debugged",
          value: result.violations.contains(SecurityViolation.debugged),
          isEvenPosition: true,
        ),
        IndividualSecurityReading(
          name: "Is rooted",
          value: result.violations.contains(SecurityViolation.rooted),
        ),
        IndividualSecurityReading(
          name: "Is being reverse engineered",
          value: result.violations.contains(
            SecurityViolation.reverseEngineered,
          ),
          isEvenPosition: true,
        ),
        Divider(height: 1, thickness: 1),
        OverallSecurityReading(result: result),
      ],
    );
  }
}
