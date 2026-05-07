import 'package:drift/drift.dart';

class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get transactionId => integer()();
  IntColumn get productId => integer()();

  TextColumn get productName => text()();

  IntColumn get price => integer()();
  IntColumn get qty => integer()();
  IntColumn get subtotal => integer()();
}