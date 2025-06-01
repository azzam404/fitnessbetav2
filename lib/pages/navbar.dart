import 'package:flutter/material.dart';
import 'analytics.dart';
import 'camerapage.dart';
import 'home.dart';
import 'logs.dart';

class BottomnavState extends StatefulWidget {
  const BottomnavState({super.key});

  @override
  State<BottomnavState> createState() => _BottomnavStateState();
}

class _BottomnavStateState extends State<BottomnavState> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const Homepage(),
    LogsPage(),
    const AnalyticsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(32, 42, 68, 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 2),
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.home, 'Home', 0),
                    _buildNavItem(Icons.list, 'Log', 1),
                    const SizedBox(width: 70), // space for FAB
                    _buildNavItem(Icons.stacked_line_chart_sharp, 'Analytics', 2),
                  ],
                ),
              ),
              Positioned(
                top: -10,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CameraPage()),
                    );
                  },
                  backgroundColor: const Color.fromRGBO(43, 39, 176, 1),
                  shape: const CircleBorder(),
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = index == _selectedIndex;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : const Color.fromRGBO(96, 94, 94, 1.0),
          ),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : const Color.fromRGBO(96, 94, 94, 1.0),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
