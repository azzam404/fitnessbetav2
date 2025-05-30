import 'package:fitnessbetav2/pages/auth_service.dart';
import 'package:fitnessbetav2/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    double progressValue = 0.6; // Example progress (60%)
    String userName = authService.value.currentUser!.displayName ?? 'User'; // Example username

    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      body: CustomScrollView(
        slivers: [
          // SliverAppBar (Shrinks on Scroll)
          SliverAppBar(
            expandedHeight: 120.0, // Height when fully expanded
            backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
            floating: false,
            pinned: true, // Stays at the top when scrolling up
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
              title: const Text(
                "Fitness App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.account_circle,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // Handle notification press
                },
                icon: const Icon(
                  Icons.notifications_active,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Greeting Container
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  "Hello, $userName! 👋\nLet's achieve your fitness goals today!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Fitness Stats (Progress, Calories, Workout, Steps)
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),

              // Caloric Intake Box
              _buildFitnessCard(
                title: "Remaining Calories",
                value: "1200 kcal",
                progressValue: progressValue,
              ),

              const SizedBox(height: 20),

              // Workout Progress Box
              _buildTextCard(
                title: "Workout Progress",
                subtitle: "You've completed 3/5 workouts today!",
              ),

              const SizedBox(height: 20),

              // Step Count Box
              _buildTextCard(
                title: "Step Count",
                subtitle: "You've walked 8,500 steps today!",
              ),

              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  // Card for Circular Progress Indicator
  Widget _buildFitnessCard({
    required String title,
    required String value,
    required double progressValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[800],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circular Progress Indicator
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: progressValue,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey[600],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                        ),
                        Center(
                          child: Text(
                            "${(progressValue * 100).toInt()}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Remaining Calories
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // "TODAY" Label in Top Left
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "TODAY",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card for Workout Progress and Step Count
  Widget _buildTextCard({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[800],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
