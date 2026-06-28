/// Base type for all domain failures surfaced through use cases.
abstract class Failure {
  final String message;

  const Failure(this.message);
}
