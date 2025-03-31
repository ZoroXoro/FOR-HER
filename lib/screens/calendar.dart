import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _selectedDays = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final User? user = FirebaseAuth.instance.currentUser;
  int periodLength = 5;
  int cycleLength = 28;
  String _selectedFlow = ''; // Flow state
  List<String> _selectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    _loadSavedDates();
  }

  Future<void> _loadUserPreferences() async {
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      setState(() {
        periodLength = data?['periodLength'] ?? 5;
        cycleLength = data?['cycleLength'] ?? 28;
      });
    }
  }

  Future<void> _loadSavedDates() async {
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('dates')
        .where('email', isEqualTo: user!.email)
        .orderBy('timestamp', descending: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _selectedDays.clear();
        for (var doc in snapshot.docs) {
          List<DateTime> cycleDates = (doc.data()['selected_days'] as List)
              .map((date) => DateTime.parse(date))
              .toList();
          _selectedDays.addAll(cycleDates);
          _selectedFlow = doc.data()['flow'] ?? ''; // Load saved flow
          _selectedSymptoms = List<String>.from(doc.data()['symptoms'] ?? []);
        }
      });
    }
  }

  void _selectPeriod(DateTime selectedDay) {
    if (selectedDay.isAfter(DateTime.now())) return;

    setState(() {
      _selectedDays.addAll(List.generate(
          periodLength, (index) => selectedDay.add(Duration(days: index))));
    });
  }

  Future<void> _savePeriodDates() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to save period dates')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('dates').add({
      'email': user!.email,
      'selected_days':
          _selectedDays.map((date) => date.toIso8601String()).toList(),
      'flow': _selectedFlow, // Save flow selection
      'symptoms': _selectedSymptoms,
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Period cycle saved successfully')),
    );

    _loadSavedDates();
  }

  void _openDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _selectPeriod(pickedDate);
    }
  }

  void _selectFlow(String flow) {
    setState(() {
      _selectedFlow = flow;
    });
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay:
                    DateTime.utc(DateTime.now().year, DateTime.now().month, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) =>
                    _selectedDays.any((selected) => isSameDay(selected, day)),
                onDaySelected: (selectedDay, focusedDay) {
                  if (selectedDay.isAfter(DateTime.now())) return;
                  _selectPeriod(selectedDay);
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 148, 60),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _savePeriodDates,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Save Dates',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _openDatePicker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Edit Period',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Flow Intensity:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _flowButton('Light', Icons.water_drop_outlined, Colors.blue),
                  const SizedBox(width: 15),
                  _flowButton('Medium', Icons.water_drop, Colors.orange),
                  const SizedBox(width: 15),
                  _flowButton('Heavy', Icons.water_drop, Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Symptoms:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _symptomButton('Nausea', Icons.sick, Colors.purple),
                  const SizedBox(width: 15),
                  _symptomButton('Back Pain', Icons.airline_seat_recline_extra,
                      Colors.brown),
                  const SizedBox(width: 15),
                  _symptomButton(
                      'Cramps', Icons.sentiment_dissatisfied, Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flowButton(String label, IconData icon, Color color) {
    bool isSelected = _selectedFlow == label;
    return GestureDetector(
      onTap: () => _selectFlow(label),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
                isSelected ? color.withOpacity(0.7) : Colors.grey[300],
            radius: 30,
            child:
                Icon(icon, color: isSelected ? Colors.white : color, size: 30),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  // Function to build symptom buttons
  Widget _symptomButton(String label, IconData icon, Color color) {
    bool isSelected = _selectedSymptoms.contains(label);
    return GestureDetector(
        onTap: () => _toggleSymptom(label),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor:
                  isSelected ? color.withOpacity(0.7) : Colors.grey[300],
              radius: 30,
              child: Icon(icon,
                  color: isSelected ? Colors.white : color, size: 30),
            ),
            const SizedBox(height: 5),
            Text(label),
          ],
        ));
  }
}
