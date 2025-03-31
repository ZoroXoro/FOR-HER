import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/pain_relief.dart';
import 'package:flutter_application_3/screens/pain_relief2.dart';

class Selfcare extends StatelessWidget {
  const Selfcare({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Care'),
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Menstrual Cramp Relief',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PeriodPainReliefScreen()),
                      );
                    },
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://blog.muscleblaze.com/wp-content/uploads/2024/08/Blog-image-2-1.jpg',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PeriodPainRelief2Screen()),
                      );
                    },
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://flo.health/uploads/media/sulu-1200x630/05/895-Exercise%20during%20period.jpg?v=1-0&inline=1',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'More about Selfcare',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Self-care includes all the things you do to take care of your mental, emotional, and physical health.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Natural Remedies',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const ListTile(
                      leading:
                          Icon(Icons.local_drink, color: Colors.pinkAccent),
                      title: Text('Herbal Teas'),
                      subtitle: Text(
                          'Chamomile, ginger, and peppermint teas help relax muscles and reduce cramps.'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.spa, color: Colors.pinkAccent),
                      title: Text('Essential Oils'),
                      subtitle: Text(
                          'Lavender and clary sage oils help relieve stress and soothe cramps when massaged onto the abdomen.'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.wb_sunny, color: Colors.pinkAccent),
                      title: Text('Heat Therapy'),
                      subtitle: Text(
                          'Using a heating pad or warm compress on the lower abdomen can help ease cramps and discomfort.'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
