import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/shad_card.dart';
import '../controllers/monitor_controller.dart';

class MonitorPage extends ConsumerWidget {
  const MonitorPage({super.key});

  Future<void> _selectDateTime(
    BuildContext context,
    WidgetRef ref,
    bool isStart,
    DateTime initialDate,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null && context.mounted) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (isStart) {
          ref
              .read(monitorControllerProvider.notifier)
              .updateDateRange(start: newDateTime);
        } else {
          ref
              .read(monitorControllerProvider.notifier)
              .updateDateRange(end: newDateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monitorState = ref.watch(monitorControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoreo'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: monitorState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (dataState) {
          final filter = dataState.filter;
          final data = dataState.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ShadCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text(
                            'Desde',
                            style: TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(
                            '${filter.startDate.day}/${filter.startDate.month}/${filter.startDate.year} ${filter.startDate.hour}:${filter.startDate.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () => _selectDateTime(
                            context,
                            ref,
                            true,
                            filter.startDate,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text(
                            'Hasta',
                            style: TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(
                            '${filter.endDate.day}/${filter.endDate.month}/${filter.endDate.year} ${filter.endDate.hour}:${filter.endDate.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () => _selectDateTime(
                            context,
                            ref,
                            false,
                            filter.endDate,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(monitorControllerProvider.notifier)
                              .refresh();
                        },
                        icon: const Icon(Icons.refresh),
                        color: Theme.of(context).primaryColor,
                        tooltip: 'Actualizar datos',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSensorCard(
                  title: 'Metano (ppm)',
                  color: const Color(0xFFEF4444),
                  fieldName: 'field1',
                  data: data,
                  startDate: filter.startDate,
                  endDate: filter.endDate,
                ),
                const SizedBox(height: 16),
                _buildSensorCard(
                  title: 'pH',
                  color: const Color(0xFF3B82F6),
                  fieldName: 'field2',
                  data: data,
                  startDate: filter.startDate,
                  endDate: filter.endDate,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSensorCard({
    required String title,
    required Color color,
    required String fieldName,
    required List<Map<String, dynamic>> data,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final chartData = data
        .where((d) => d[fieldName] != null)
        .map(
          (d) => _ChartData(
            DateTime.parse(d['ts_iso']),
            (d[fieldName] as num).toDouble(),
          ),
        )
        .toList();

    final duration = endDate.difference(startDate);
    DateFormat dateFormat;
    if (duration.inDays >= 365) {
      dateFormat = DateFormat('MM/yyyy');
    } else if (duration.inDays >= 1) {
      dateFormat = DateFormat('dd/MM');
    } else {
      dateFormat = DateFormat.Hm();
    }

    return ShadCard(
      title: title,
      child: SizedBox(
        height: 250,
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(
            enable: true,
            header: '',
            canShowMarker: false,
          ),
          primaryXAxis: DateTimeAxis(
            minimum: startDate,
            maximum: endDate,
            dateFormat: dateFormat,
            majorGridLines: MajorGridLines(
              width: 1,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
          primaryYAxis: NumericAxis(
            labelFormat: '{value}',
            majorGridLines: MajorGridLines(
              width: 1,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
          series: <CartesianSeries<_ChartData, DateTime>>[
            AreaSeries<_ChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              color: color.withOpacity(0.1),
              borderColor: color,
              borderWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
