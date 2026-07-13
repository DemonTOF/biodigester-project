import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import '../database/app_database.dart';

class SyncResult {
  final bool ok;
  final int downloaded;
  final int inserted;
  final String? error;

  SyncResult({
    required this.ok,
    this.downloaded = 0,
    this.inserted = 0,
    this.error,
  });
}

class _Page {
  final List<int> entryIds;
  final List<FeedsCompanion> rows;
  final int totalPages;
  final int downloaded;

  _Page(this.entryIds, this.rows, this.totalPages, this.downloaded);
}

class PocketBaseSyncService {
  final AppDatabase db;

  // Hardcoded PocketBase instance (public read on the `feeds` collection).
  static const String _baseUrl =
      'https://pocketbase-production-292f.up.railway.app';
  static const String _collection = 'feeds';
  static const int _perPage = 1000; // PocketBase hard-caps perPage at 1000
  static const int _concurrency = 8;

  PocketBaseSyncService(this.db);

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'nan') return null;
    return double.tryParse(s);
  }

  DateTime? _parseCreatedAt(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim().replaceFirst(' ', 'T');
    return DateTime.tryParse(s);
  }

  Future<_Page> _fetchPageWithRetry(int page, int fromEntryId) async {
    for (var attempt = 0; attempt < 4; attempt++) {
      try {
        final uri = Uri.parse('$_baseUrl/api/collections/$_collection/records')
            .replace(
          queryParameters: {
            'filter': '(entry_id > $fromEntryId)',
            'sort': 'entry_id',
            'perPage': '$_perPage',
            'page': '$page',
            'fields':
                'entry_id,created_at,field1,field2,field3,field4,field5,field6,field7,field8',
          },
        );
        final response =
            await http.get(uri).timeout(const Duration(seconds: 30));
        if (response.statusCode != 200) {
          throw Exception('PocketBase status ${response.statusCode}');
        }

        final data = jsonDecode(response.body);
        final items = (data['items'] as List<dynamic>? ?? []);
        final entryIds = <int>[];
        final rows = items.map((f) {
          final entryId = (f['entry_id'] as num).toInt();
          entryIds.add(entryId);
          final createdAt = _parseCreatedAt(f['created_at']);
          return FeedsCompanion.insert(
            entryId: Value(entryId),
            channelId: 0,
            tsIso: createdAt?.toIso8601String() ?? '',
            tsEpoch: createdAt?.millisecondsSinceEpoch ?? 0,
            field1: Value(_toDouble(f['field1'])),
            field2: Value(_toDouble(f['field2'])),
            field3: Value(_toDouble(f['field3'])),
            field4: Value(_toDouble(f['field4'])),
            field5: Value(_toDouble(f['field5'])),
            field6: Value(_toDouble(f['field6'])),
            field7: Value(_toDouble(f['field7'])),
            field8: Value(_toDouble(f['field8'])),
          );
        }).toList();

        return _Page(entryIds, rows, (data['totalPages'] as int?) ?? 1,
            items.length);
      } catch (e) {
        if (attempt == 3) rethrow;
        await Future.delayed(Duration(milliseconds: 300 * (attempt + 1)));
      }
    }
    throw Exception('failed to fetch page $page');
  }

  Future<SyncResult> syncSince({
    required int fromEntryId,
    void Function(int downloaded, int inserted)? onProgress,
  }) async {
    try {
      // First page also tells us totalPages.
      final first = await _fetchPageWithRetry(1, fromEntryId);
      final totalPages = first.totalPages;

      // Fetch remaining pages with bounded concurrency.
      final pages = <_Page>[first];
      final remaining = [for (var p = 2; p <= totalPages; p++) p];
      for (var i = 0; i < remaining.length; i += _concurrency) {
        final group = remaining.sublist(
          i,
          (i + _concurrency).clamp(0, remaining.length),
        );
        final results = await Future.wait(
          group.map((p) => _fetchPageWithRetry(p, fromEntryId)),
        );
        pages.addAll(results);
      }

      final allRows = <FeedsCompanion>[];
      var maxEntryId = fromEntryId;
      var downloaded = 0;
      for (final pg in pages) {
        downloaded += pg.downloaded;
        for (var j = 0; j < pg.rows.length; j++) {
          if (pg.entryIds[j] > maxEntryId) maxEntryId = pg.entryIds[j];
          allRows.add(pg.rows[j]);
        }
      }

      // Insert in chunks.
      const chunk = 5000;
      var inserted = 0;
      for (var i = 0; i < allRows.length; i += chunk) {
        final end = (i + chunk).clamp(0, allRows.length);
        await db.feedDao.insertFeeds(allRows.sublist(i, end));
        inserted = end;
        onProgress?.call(downloaded, inserted);
      }

      await db.syncMetaDao.setLastEntryId(maxEntryId);
      await db.syncMetaDao.setLastSyncAt(DateTime.now().toIso8601String());

      return SyncResult(ok: true, downloaded: downloaded, inserted: inserted);
    } catch (e) {
      return SyncResult(ok: false, error: e.toString());
    }
  }

  /// Wipes the local store and re-downloads the full history from PocketBase.
  Future<SyncResult> forceSync({
    void Function(int downloaded, int inserted)? onProgress,
  }) async {
    await db.feedDao.deleteAll();
    await db.syncMetaDao.reset();
    return syncSince(fromEntryId: 0, onProgress: onProgress);
  }

  Future<SyncResult> sync({
    void Function(int, int)? onProgress,
  }) async {
    final meta = await db.syncMetaDao.get();
    final lastEntryId = meta?.lastEntryId ?? 0;
    return syncSince(fromEntryId: lastEntryId, onProgress: onProgress);
  }
}
