import 'package:flutter_security_suite/flutter_security_suite.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Security suite models unit tests", () {
    test("isSecureEnvironment - when no violations - returns true", () {
      // Setup
      final receiver = SecurityCheckResult({});

      // Run test & verify
      expect(receiver.isSecureEnvironment, true);
    });

    test("isSecureEnvironment - when violations - returns false", () {
      // Setup
      final receivers = {
        SecurityCheckResult({SecurityViolation.reverseEngineered}),
        SecurityCheckResult({SecurityViolation.rooted}),
        SecurityCheckResult({SecurityViolation.debugged}),
        SecurityCheckResult({SecurityViolation.emulator}),
        SecurityCheckResult({
          SecurityViolation.emulator,
          SecurityViolation.debugged,
          SecurityViolation.rooted,
          SecurityViolation.reverseEngineered,
        }),
      };

      // Run test & verify
      for (final receiver in receivers) {
        expect(receiver.isSecureEnvironment, false);
      }
    });
  });
}
