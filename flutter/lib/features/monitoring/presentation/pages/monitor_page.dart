import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/shad_card.dart';
import '../controllers/monitor_controller.dart';
import 'widgets/tabbed_date_time_picker.dart';

class MonitorPage extends ConsumerWidget {
  const MonitorPage({super.key});

  Future<void> _selectDateTime(
    BuildContext context,
    WidgetRef ref,
    bool isStart,
    DateTime initialDate,
  ) async {
    final DateTime? pickedDateTime = await showDialog<DateTime>(
      context: context,
      builder: (context) =>
          TabbedDateTimePickerDialog(initialDateTime: initialDate),
    );

    if (pickedDateTime != null && context.mounted) {
      if (isStart) {
        ref
            .read(monitorControllerProvider.notifier)
            .updateDateRange(start: pickedDateTime);
      } else {
        ref
            .read(monitorControllerProvider.notifier)
            .updateDateRange(end: pickedDateTime);
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text(
                                'Desde',
                                style: TextStyle(fontSize: 12),
                              ),
                              subtitle: Text(
                                '${filter.startDate.day}/${filter.startDate.month}/${filter.startDate.year} ${filter.startDate.hour}:${filter.startDate.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () => _selectDateTime(
                                context,
                                ref,
                                false,
                                filter.endDate,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                ref
                                    .read(monitorControllerProvider.notifier)
                                    .reset();
                              },
                              icon: const Icon(Icons.history),
                              label: const Text('Restablecer'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(monitorControllerProvider.notifier)
                                    .refresh();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refrescar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                ref
                                    .read(monitorControllerProvider.notifier)
                                    .exportToCsv();
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('CSV'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
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
            activationMode: ActivationMode.singleTap,
          ),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enableDoubleTapZooming: true,
            enablePanning: true,
            enableSelectionZooming: true,
            zoomMode: ZoomMode.x,
          ),
          primaryXAxis: DateTimeAxis(
            minimum: startDate,
            maximum: endDate,
            dateFormat: dateFormat,
            enableAutoIntervalOnZooming: true,
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
              enableTooltip: true,
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
