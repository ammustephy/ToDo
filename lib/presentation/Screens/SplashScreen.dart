import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import '../../presentation/Screens/UserScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isPortrait ? 24 : 64,
            vertical: isPortrait ? 20 : 32,
          ),
          child: Column(
            children: [
              Container(
                width: isPortrait ? size.width * 0.85 : size.width * 0.35,
                height: isPortrait ? size.height * 0.5 : size.height * 0.5,
                child: Image.asset(
                  'Assets/Images/splashpics.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.task_alt,
                          size: isPortrait ? 120 : 80,
                          color: const Color(0xFF7C6CF5),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),
              Text(
                'Task Management &\nTo-Do List',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isPortrait ? 26 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3142),
                  height: 1.3,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: isPortrait ? 16 : 12),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isPortrait ? 20 : size.width * 0.1,
                ),
                child: Text(
                  'This productive tool is designed to help\nyou better manage your task\nproject-wise conveniently!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isPortrait ? 14 : 12,
                    color: Colors.grey[600],
                    height: 1.6,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              SizedBox(height: isPortrait ? 30 : 30),

              SizedBox(
                width: double.infinity,
                height: isPortrait ? 56 : 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getString('user_id');

                    if (userId != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(userId: userId),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserSetupScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C6CF5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    shadowColor: const Color(0xFF7C6CF5).withOpacity(0.3),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Let's Start",
                            style: TextStyle(
                              fontSize: isPortrait ? 18 : 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Image.asset(
                        "Assets/Images/rightArrow.png",
                        color: Colors.white,
                        height: 18,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: isPortrait ? 20 : 16),
            ],
          ),
        ),
      ),
    );
  }
}