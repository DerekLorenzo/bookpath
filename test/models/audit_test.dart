import 'package:flutter_test/flutter_test.dart';
import 'package:book_path/models/audit.dart';

void main() {
  group('Audit', () {
    test('default constructor sets createdAt and updatedAt', () {
      final audit = Audit();
      expect(audit.createdAt, isA<DateTime>());
      expect(audit.updatedAt, isA<DateTime>());
    });

    test('constructor uses provided values', () {
      final now = DateTime(2020, 1, 1);
      final audit = Audit(createdAt: now, updatedAt: now);
      expect(audit.createdAt, now);
      expect(audit.updatedAt, now);
    });

    test('toJson and fromJson roundtrip', () {
      final now = DateTime(2022, 2, 2, 12, 30, 45);
      final audit = Audit(createdAt: now, updatedAt: now);
      final json = audit.toJson();
      final fromJson = Audit.fromJson(json);
      expect(fromJson.createdAt, now);
      expect(fromJson.updatedAt, now);
    });

    test('toString contains createdAt and updatedAt', () {
      final now = DateTime(2023, 3, 3, 10, 20, 30);
      final audit = Audit(createdAt: now, updatedAt: now);
      final str = audit.toString();
      expect(str, contains('createdAt: $now'));
      expect(str, contains('updatedAt: $now'));
    });
  });
}
