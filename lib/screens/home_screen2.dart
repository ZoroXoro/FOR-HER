import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int cycleDay = 1;
  int ovulationDayLeft = 11;
  int nextPeriodInDays = 28;
  int periodLength = 5;
  int cycleLength = 28;
  bool isPeriodActive = true;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCycleDay();
  }

  Future<void> _fetchCycleDay() async {
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('dates')
        .where('email', isEqualTo: user!.email)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      DateTime startDate = DateTime.parse(data['selected_days'][0]);
      int daysPassed = DateTime.now().difference(startDate).inDays + 1;
      DateTime nextPeriodDate = startDate.add(Duration(days: cycleLength));
      DateTime ovulationDate =
          nextPeriodDate.subtract(const Duration(days: 14));
      int ovulationDaysLeft = ovulationDate.difference(DateTime.now()).inDays;
      int daysUntilNextPeriod =
          nextPeriodDate.difference(DateTime.now()).inDays;

      setState(() {
        cycleDay = daysPassed;
        ovulationDayLeft = ovulationDaysLeft;
        nextPeriodInDays = daysUntilNextPeriod;
        isPeriodActive = cycleDay <= periodLength;
      });
    }
  }

  Future<void> _updateFirebaseData() async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user!.email).set({
      'periodLength': periodLength,
      'cycleLength': cycleLength,
    }, SetOptions(merge: true));
  }

  void _editPeriodLength() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Period Length"),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: 26,
              itemBuilder: (context, index) {
                int newPeriodLength = index + 1;
                return ListTile(
                  title: Text('$newPeriodLength Day'),
                  onTap: () {
                    setState(() {
                      periodLength = newPeriodLength;
                      isPeriodActive = cycleDay <= periodLength;
                    });
                    _updateFirebaseData();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _editCycleLength() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Cycle Length"),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: 90,
              itemBuilder: (context, index) {
                int newCycleLength = index + 1;
                return ListTile(
                  title: Text('$newCycleLength Days'),
                  onTap: () {
                    setState(() {
                      cycleLength = newCycleLength;
                    });
                    _updateFirebaseData();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backgrounds/theme2.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Home Screen'),
          backgroundColor: Colors.pinkAccent,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editPeriodLength,
              tooltip: "Edit Period Length",
            ),
            IconButton(
              icon: const Icon(Icons.edit_calendar),
              onPressed: _editCycleLength,
              tooltip: "Edit Cycle Length",
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 270,
                height: 270,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.pinkAccent, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isPeriodActive
                          ? 'Periods'
                          : (ovulationDayLeft > 0
                              ? 'Ovulation:'
                              : 'Next Period'),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isPeriodActive
                          ? '$cycleDay Days'
                          : (ovulationDayLeft > 0
                              ? '$ovulationDayLeft Days Left'
                              : '$nextPeriodInDays Days Left'),
                      style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isPeriodActive
                          ? 'Ovulation: $ovulationDayLeft Days Left'
                          : (ovulationDayLeft > 0
                              ? 'Next Period: $nextPeriodInDays Days Left'
                              : 'Next Period in: $nextPeriodInDays Days'),
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70),
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
