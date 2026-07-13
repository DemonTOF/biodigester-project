import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart' show driftDatabase;

part 'app_database.g.dart';

class Feeds extends Table {
  IntColumn get entryId => integer()();
  IntColumn get channelId => integer()();
  TextColumn get tsIso => text()();
  IntColumn get tsEpoch => integer()();
  RealColumn get field1 => real().nullable()();
  RealColumn get field2 => real().nullable()();
  RealColumn get field3 => real().nullable()();
  RealColumn get field4 => real().nullable()();
  RealColumn get field5 => real().nullable()();
  RealColumn get field6 => real().nullable()();
  RealColumn get field7 => real().nullable()();
  RealColumn get field8 => real().nullable()();

  @override
  Set<Column> get primaryKey => {entryId};
}

class SyncMetas extends Table {
  IntColumn get id => integer()();
  IntColumn get lastEntryId => integer().withDefault(const Constant(0))();
  TextColumn get lastSyncAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Feeds, SyncMetas], daos: [FeedDao, SyncMetaDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'biodigester'));

  @override
  int get schemaVersion => 1;
}

@DriftAccessor(tables: [Feeds])
class FeedDao extends DatabaseAccessor<AppDatabase> with _$FeedDaoMixin {
  FeedDao(super.db);

  Future<int> getMaxEntryId() async {
    final row = await (select(feeds)
          ..orderBy([(t) => OrderingTerm.desc(t.entryId)])
          ..limit(1))
        .getSingleOrNull();
    return row?.entryId ?? 0;
  }

  Future<void> insertFeeds(List<FeedsCompanion> rows) {
    return batch((b) => b.insertAllOnConflictUpdate(feeds, rows));
  }

  Future<List<Feed>> queryRange(int startEpoch, int endEpoch) {
    return (select(feeds)
          ..where((t) => t.tsEpoch.isBiggerOrEqualValue(startEpoch) &
              t.tsEpoch.isSmallerOrEqualValue(endEpoch))
          ..orderBy([(t) => OrderingTerm.asc(t.tsEpoch)]))
        .get();
  }

  Future<int> deleteAll() => delete(feeds).go();

  Future<int> count() => (selectOnly(feeds)
        ..addColumns([feeds.entryId.count()]))
      .map((row) => row.read(feeds.entryId.count()) ?? 0)
      .getSingle();

  Future<({int startEpoch, int endEpoch})> getMinMaxEpoch() async {
    final first = await (select(feeds)
          ..orderBy([(t) => OrderingTerm.asc(t.tsEpoch)])
          ..limit(1))
        .getSingleOrNull();
    final last = await (select(feeds)
          ..orderBy([(t) => OrderingTerm.desc(t.tsEpoch)])
          ..limit(1))
        .getSingleOrNull();
    return (
      startEpoch: first?.tsEpoch ?? 0,
      endEpoch: last?.tsEpoch ?? 0,
    );
  }
}

@DriftAccessor(tables: [SyncMetas])
class SyncMetaDao extends DatabaseAccessor<AppDatabase> with _$SyncMetaDaoMixin {
  SyncMetaDao(super.db);

  Future<SyncMeta?> get() async {
    return (select(syncMetas)..where((t) => t.id.equals(0))).getSingleOrNull();
  }

  Future<void> setLastEntryId(int value) {
    return into(syncMetas).insertOnConflictUpdate(
      SyncMetasCompanion.insert(
        id: const Value(0),
        lastEntryId: Value(value),
      ),
    );
  }

  Future<void> setLastSyncAt(String value) {
    return into(syncMetas).insertOnConflictUpdate(
      SyncMetasCompanion.insert(
        id: const Value(0),
        lastSyncAt: Value(value),
      ),
    );
  }

  Future<void> reset() {
    return into(syncMetas).insertOnConflictUpdate(
      SyncMetasCompanion.insert(
        id: const Value(0),
        lastEntryId: const Value(0),
        lastSyncAt: const Value.absent(),
      ),
    );
  }
}
