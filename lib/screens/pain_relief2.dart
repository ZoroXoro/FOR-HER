import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/leg_massages.dart';

class PeriodPainRelief2Screen extends StatelessWidget {
  static const routeName = '/poses2';
  const PeriodPainRelief2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Section
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://flo.health/uploads/media/sulu-1200x630/05/895-Exercise%20during%20period.jpg?v=1-0&inline=1',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title and Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Period pain relief',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Here are some easy poses to help you calm down and relieve the pain.\n\n* A pillow can be used for support',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),

            const SizedBox(height: 20),

            // Poses Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '3 Minutes, 4 Asanas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                _poseItem(
                  'https://pocketyoga.com/assets/images/full/CobraFull.png',
                  'Cobra Pose',
                ),
                _poseItem(
                  'https://pocketyoga.com/assets/images/full/Bridge.png',
                  'Bridge Pose',
                ),
                _poseItem(
                  'https://pocketyoga.com/assets/images/full/BlissfulBaby.png',
                  'Happy Baby Pose',
                ),
                _poseItem('https://pocketyoga.com/assets/images/full/Cat.png',
                    'Cat Pose'),
              ],
            ),

            // Start Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 60),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, LegMassageScreen.routeName);
                },
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text(
                  'Start',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create pose item
  Widget _poseItem(String imageUrl, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl,
                width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 20),
          Text(title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
