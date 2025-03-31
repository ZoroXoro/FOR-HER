import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  static const routeName = '/timer';
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 180;
  final int _initialTime = 180;
  Timer? _timer;
  bool _isRunning = false;
  int _currentPoseIndex = 0;

  final List<Map<String, String>> _poses = [
    {
      'image': 'https://pocketyoga.com/assets/images/full/Child.png',
      'title': "Child's pose",
      'description': 'For support use a pillow under ur belly'
    },
    {
      'image': 'https://pocketyoga.com/assets/images/full/ForwardBend.png',
      'title': 'Forward bend',
    },
    {
      'image':
          'https://cdn.shopify.com/s/files/1/1564/7803/files/Yoga-LegsUpTheWall_480x480.png?v=1697015380',
      'title': 'Leg raises',
    },
    {
      'image': 'https://pocketyoga.com/assets/images/full/Butterfly.png',
      'title': 'Butterfly',
    }
  ];

  void _startPauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            timer.cancel();
          }
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _nextPose() {
    if (!_isRunning) {
      setState(() {
        if (_currentPoseIndex < _poses.length - 1) {
          _currentPoseIndex++;
          _seconds = _initialTime;
        }
      });
    }
  }

  void _previousPose() {
    if (!_isRunning) {
      setState(() {
        if (_currentPoseIndex > 0) {
          _currentPoseIndex--;
          _seconds = _initialTime;
        }
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 241, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Text(
            '${_currentPoseIndex + 1}/${_poses.length}',
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.music_off, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _poses[_currentPoseIndex]['image']!,
                    width: 250,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _poses[_currentPoseIndex]['title']!,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _formatTime(_seconds),
            style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent),
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: Icon(
              _isRunning ? Icons.pause_circle_filled : Icons.play_circle_fill,
              size: 80,
              color: Colors.pinkAccent,
            ),
            onPressed: _startPauseTimer,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 40),
                onPressed: _previousPose,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 40),
                onPressed: _nextPose,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
