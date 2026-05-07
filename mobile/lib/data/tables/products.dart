import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  IntColumn get categoryId => integer().nullable()();

  IntColumn get priceBuy => integer()();
  IntColumn get priceSell => integer()();

  IntColumn get stock => integer().withDefault(const Constant(0))();

  BoolColumn get isUnlimited =>
      boolean().withDefault(const Constant(false))();
}