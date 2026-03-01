import 'package:flutter/material.dart';

class TabbedDateTimePickerDialog extends StatefulWidget {
  final DateTime initialDateTime;

  const TabbedDateTimePickerDialog({super.key, required this.initialDateTime});

  @override
  State<TabbedDateTimePickerDialog> createState() =>
      _TabbedDateTimePickerDialogState();
}

class _TabbedDateTimePickerDialogState
    extends State<TabbedDateTimePickerDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.initialDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.calendar_today, color: Colors.white),
                      text: 'Fecha',
                    ),
                    Tab(
                      icon: Icon(Icons.access_time, color: Colors.white),
                      text: 'Hora',
                    ),
                  ],
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 380,
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CalendarDatePicker(
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                          onDateChanged: (date) {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                        ),
                      ),
                      _TimePickerWidget(
                        initialTime: _selectedTime,
                        onTimeChanged: (time) {
                          setState(() {
                            _selectedTime = time;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final result = DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          _selectedTime.hour,
                          _selectedTime.minute,
                        );
                        Navigator.pop(context, result);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimePickerWidget extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const _TimePickerWidget({
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  State<_TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<_TimePickerWidget> {
  late int _currentHour;
  late int _currentMinute;

  @override
  void initState() {
    super.initState();
    _currentHour = widget.initialTime.hour;
    _currentMinute = widget.initialTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUnitColumn(context, 'Hora', _currentHour, 24, (val) {
                setState(() => _currentHour = val);
                widget.onTimeChanged(
                  TimeOfDay(hour: _currentHour, minute: _currentMinute),
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              _buildUnitColumn(context, 'Minuto', _currentMinute, 60, (val) {
                setState(() => _currentMinute = val);
                widget.onTimeChanged(
                  TimeOfDay(hour: _currentHour, minute: _currentMinute),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitColumn(
    BuildContext context,
    String label,
    int currentValue,
    int itemCount,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(initialItem: currentValue),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final isSelected = index == currentValue;
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
