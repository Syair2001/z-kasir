import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text()(); // TRX-xxx

  IntColumn get total => integer()();
  IntColumn get paid => integer()();
  IntColumn get change => integer()();

  TextColumn get customerName => text().nullable()();
  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}