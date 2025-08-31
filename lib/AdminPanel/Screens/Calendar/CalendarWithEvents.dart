import 'package:digivity_admin_app/AdminPanel/Models/EventCalender/EventCalenderModel.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/CommunicationManagement/EventCalenderHelper.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../MobileThemsColors/hex_color.dart';

class CalendarWithEvents extends StatefulWidget {
  @override
  _CalendarWithEventsState createState() => _CalendarWithEventsState();
}

class _CalendarWithEventsState extends State<CalendarWithEvents> {
  late final ValueNotifier<List<EventCalenderModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Map of events for TableCalendar
  final Map<DateTime, List<EventCalenderModel>> _eventsMap = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    loadEvents();
  }

  Future<void> loadEvents([String? month]) async {
    showLoaderDialog(context);
    final String currentMonth =
        month ??
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}";

    try {
      final response = await EventCalenderHelper().getThisMonthEvents(
        currentMonth,
      );
      setState(() {
        _eventsMap.clear();
        for (var event in response) {
          final date = DateTime.utc(
            event.startDate.year,
            event.startDate.month,
            event.startDate.day,
          );
          if (_eventsMap[date] == null) _eventsMap[date] = [];
          _eventsMap[date]!.add(event);
        }
        // Set events for today
        _selectedEvents.value = _eventsMap[_selectedDay!] ?? [];
      });
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      hideLoaderDialog(context);
    }
  }

  List<EventCalenderModel> _getEventsForDay(DateTime day) {
    return _eventsMap[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "School Calendar", routeName: "back"),
      ),
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Calendar card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TableCalendar<EventCalenderModel>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _selectedEvents.value = _getEventsForDay(selectedDay);
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) async {
                      _focusedDay = focusedDay;
                      loadEvents(_focusedDay.toString());
                    },

                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.purpleAccent],
                        ),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      weekendTextStyle: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),

                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: true,
                      formatButtonShowsNext: false,
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.deepPurple,
                        size: 28,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.deepPurple,
                        size: 28,
                      ),
                      headerPadding: EdgeInsets.symmetric(vertical: 12),
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 1.2,
                        ),
                      ),
                      formatButtonTextStyle: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Events list
              Expanded(
                child: ValueListenableBuilder<List<EventCalenderModel>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    if (value.isEmpty) {
                      return Center(
                        child: Text(
                          "✨ No events for this day",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final event = value[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: event.isHoliday == 'yes'
                                  ? Colors.red
                                  : HexColor.fromHex(event.backgroundColor),
                              child: Icon(
                                Icons.event,
                                color: event.isHoliday == 'yes'
                                    ? Colors.white
                                    : HexColor.fromHex(event.textColor),
                              ),
                            ),
                            title: Text(
                              event.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(event.description),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
