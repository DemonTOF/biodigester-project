import 'package:flutter_riverpod/flutter_riverpod.dart';
import './database/app_database.dart';
import './services/pocketbase_sync_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final pocketBaseSyncServiceProvider = Provider<PocketBaseSyncService>((ref) {
  return PocketBaseSyncService(ref.watch(appDatabaseProvider));
});

class SyncState {
  final bool syncing;
  final bool forceSyncing;
  final int downloaded;
  final int inserted;
  final String? lastSyncAt;
  final int feedCount;
  final String? error;

  const SyncState({
    this.syncing = false,
    this.forceSyncing = false,
    this.downloaded = 0,
    this.inserted = 0,
    this.lastSyncAt,
    this.feedCount = 0,
    this.error,
  });

  SyncState copyWith({
    bool? syncing,
    bool? forceSyncing,
    int? downloaded,
    int? inserted,
    String? lastSyncAt,
    int? feedCount,
    String? error,
  }) {
    return SyncState(
      syncing: syncing ?? this.syncing,
      forceSyncing: forceSyncing ?? this.forceSyncing,
      downloaded: downloaded ?? this.downloaded,
      inserted: inserted ?? this.inserted,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      feedCount: feedCount ?? this.feedCount,
      error: error ?? this.error,
    );
  }
}

class SyncController extends Notifier<SyncState> {
  @override
  SyncState build() => const SyncState();

  Future<void> refreshStatus() async {
    final db = ref.read(appDatabaseProvider);
    final meta = await db.syncMetaDao.get();
    final count = await db.feedDao.count();
    state = state.copyWith(
      lastSyncAt: meta?.lastSyncAt,
      feedCount: count,
    );
  }

  Future<void> _run({
    required bool force,
    required bool forceFlag,
  }) async {
    state = state.copyWith(
      syncing: !forceFlag,
      forceSyncing: forceFlag,
      downloaded: 0,
      inserted: 0,
      error: null,
    );

    final service = ref.read(pocketBaseSyncServiceProvider);
    final result = force
        ? await service.forceSync(onProgress: (d, i) {
            state = state.copyWith(downloaded: d, inserted: i);
          })
        : await service.sync(onProgress: (d, i) {
            state = state.copyWith(downloaded: d, inserted: i);
          });

    state = state.copyWith(
      syncing: false,
      forceSyncing: false,
      error: result.ok ? null : result.error,
    );
    await refreshStatus();
  }

  Future<void> sync() => _run(force: false, forceFlag: false);

  Future<void> forceSync() => _run(force: true, forceFlag: true);
}

final syncControllerProvider =
    NotifierProvider<SyncController, SyncState>(SyncController.new);
