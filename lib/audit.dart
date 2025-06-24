class Audit {
  final DateTime createdAt = DateTime.timestamp();
  DateTime updatedAt = DateTime.timestamp();

  @override
  String toString() {
    final props = <String>['createdAt: $createdAt', 'updatedAt: $updatedAt'];
    return 'BookJournal(${props.join(', ')})';
  }
}
