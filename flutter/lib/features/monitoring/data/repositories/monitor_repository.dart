import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers.dart';

class MonitorRepository {
  final AppDatabase db;

  MonitorRepository(this.db);

  Future<List<Map<String, dynamic>>> fetchData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final rows = await db.feedDao.queryRange(
      startDate.millisecondsSinceEpoch,
      endDate.millisecondsSinceEpoch,
    );

    return rows
        .map((r) => {
              'ts_iso': r.tsIso,
              'field1': r.field1,
              'field2': r.field2,
              'field3': r.field3,
              'field4': r.field4,
              'field5': r.field5,
              'field6': r.field6,
              'field7': r.field7,
              'field8': r.field8,
            })
        .toList();
  }
}

final monitorRepositoryProvider = Provider<MonitorRepository>((ref) {
  return MonitorRepository(ref.watch(appDatabaseProvider));
});
