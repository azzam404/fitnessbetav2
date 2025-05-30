import 'package:flutter/material.dart';
import 'camerapage.dart';
import 'home.dart';

class BottomnavState extends StatefulWidget {
  const BottomnavState({super.key});

  @override
  State<BottomnavState> createState() => _BottomnavStateState();
}

class _BottomnavStateState extends State<BottomnavState> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const Homepage(), // Ensure this widget is defined in home.dart
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
          ),
          Container(
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
                const SizedBox(height: 2), // Space for SOS button
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space items evenly in each section
                        children: [
                          // Left-side navigation items
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildNavItem(Icons.home, 'Home', 0),
                                _buildNavItem(Icons.list, 'Log', 1),
                              ],
                            ),
                          ),

                          // Floating Action Button (FAB) in center
                          const SizedBox(width: 70), // Space for FAB

                          // Right-side navigation items
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildNavItem(Icons.stacked_line_chart_sharp, 'Analytics', 2),
                                _buildNavItem(Icons.calendar_month, 'Calendar', 3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10,
                      child: FloatingActionButton(
                        onPressed: ()  async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CameraPage()),
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
