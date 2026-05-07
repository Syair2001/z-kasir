import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/products.dart';
import 'tables/categories.dart';
import 'tables/transactions.dart';
import 'tables/transaction_items.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Products, Categories, Transactions, TransactionItems],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'kasir.db'));
    return NativeDatabase(file);
  });
}