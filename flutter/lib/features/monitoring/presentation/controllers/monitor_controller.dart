import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repositories/monitor_repository.dart';
import '../../../../core/providers.dart';

part 'monitor_controller.g.dart';

class MonitorState {
  final DateTime startDate;
  final DateTime endDate;

  MonitorState({required this.startDate, required this.endDate});

  MonitorState copyWith({DateTime? startDate, DateTime? endDate}) {
    return MonitorState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class MonitorDataState {
  final MonitorState filter;
  final List<Map<String, dynamic>> data;

  MonitorDataState({required this.filter, required this.data});
}

@riverpod
class MonitorController extends _$MonitorController {
  Future<MonitorState> _defaultRange() async {
    final db = ref.read(appDatabaseProvider);
    final range = await db.feedDao.getMinMaxEpoch();
    if (range.startEpoch == 0 || range.endEpoch == 0) {
      final now = DateTime.now();
      return MonitorState(startDate: now, endDate: now);
    }
    return MonitorState(
      startDate: DateTime.fromMillisecondsSinceEpoch(range.startEpoch),
      endDate: DateTime.fromMillisecondsSinceEpoch(range.endEpoch),
    );
  }

  @override
  FutureOr<MonitorDataState> build() async {
    final filter = await _defaultRange();
    final data = await _fetchData(filter.startDate, filter.endDate);

    return MonitorDataState(filter: filter, data: data);
  }

  Future<List<Map<String, dynamic>>> _fetchData(
    DateTime start,
    DateTime end,
  ) async {
    final repo = ref.read(monitorRepositoryProvider);
    return await repo.fetchData(start, end);
  }

  Future<void> updateDateRange({DateTime? start, DateTime? end}) async {
    state = const AsyncValue.loading();

    try {
      final currentFilter = state.value?.filter ?? await _defaultRange();

      final newFilter = currentFilter.copyWith(startDate: start, endDate: end);
      final newData = await _fetchData(newFilter.startDate, newFilter.endDate);

      state = AsyncValue.data(
        MonitorDataState(filter: newFilter, data: newData),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    final currentFilter = state.value?.filter;
    if (currentFilter != null) {
      await updateDateRange(
        start: currentFilter.startDate,
        end: currentFilter.endDate,
      );
    }
  }

  Future<void> reset() async {
    final range = await _defaultRange();
    await updateDateRange(start: range.startDate, end: range.endDate);
  }

  Future<void> exportToCsv() async {
    final currentState = state.value;
    if (currentState == null || currentState.data.isEmpty) return;

    final data = currentState.data;
    final List<List<dynamic>> rows = [];

    // Header
    rows.add(['Timestamp (ISO)', 'Metano (ppm)', 'pH']);

    // Data rows
    for (var row in data) {
      rows.add([row['ts_iso'], row['field1'], row['field2']]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final path =
        "${directory.path}/monitoreo_${DateTime.now().millisecondsSinceEpoch}.csv";
    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles([
      XFile(path),
    ], text: 'Exportación de datos de monitoreo');
  }
}
