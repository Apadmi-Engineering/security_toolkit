enum SecurityViolation {
  rooted,
  debugged,
  reverseEngineered,
  emulator;
}

class SecurityCheckResult {
  /// A set of the failed checks.
  final Set<SecurityViolation> violations;

  const SecurityCheckResult(this.violations);

  /// Whether the current app session can be determined as secure. This will
  /// return [true] if there were no violations found.
  bool get isSecureEnvironment => violations.isEmpty;
}