class Audit {
  final DateTime createdAt;
  DateTime updatedAt;

  Audit({DateTime? createdAt, DateTime? updatedAt})
    : createdAt = createdAt ?? DateTime.timestamp(),
      updatedAt = updatedAt ?? DateTime.timestamp();

  @override
  String toString() {
    final props = <String>['createdAt: $createdAt', 'updatedAt: $updatedAt'];
    return 'BookJournal(${props.join(', ')})';
  }

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Audit.fromJson(Map<String, dynamic> json) => Audit(
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}
