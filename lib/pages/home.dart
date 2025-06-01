import 'package:fitnessbetav2/pages/auth_service.dart';
import 'package:fitnessbetav2/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  final List<Map<String, dynamic>> fitnessTips = const [
    {"text": "Stay hydrated! 💧", "color": Colors.teal},
    {"text": "Warm up before workouts. 🔥", "color": Colors.deepOrange},
    {"text": "Get 7-8 hours of sleep. 💤", "color": Colors.purple},
    {"text": "Focus on proper form, not just weight. 🏋️", "color": Colors.indigo},
    {"text": "Consistency is key! 💪", "color": Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    double progressValue = 0.6; // Example progress (60%)
    String userName = authService.value.currentUser!.displayName ?? 'User'; // Example username

    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      body: CustomScrollView(
        slivers: [
          // SliverAppBar
          SliverAppBar(
            expandedHeight: 120.0,
            backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
            floating: false,
            pinned: true,
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

          // Main content
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),

              // Fitness Tips Carousel
              _buildTipsCarousel(context),

              const SizedBox(height: 20),

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

  // Widget for Fitness Tips Carousel
  Widget _buildTipsCarousel(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.95, // wider: closer to screen edges
      ),
      items: fitnessTips.map((tip) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: screenWidth * 0.95,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                color: tip["color"],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    tip["text"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
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
