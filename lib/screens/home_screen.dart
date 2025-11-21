// home_screen.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../components/gradient_button.dart';
import '../components/network_error_dialog.dart';
import 'webview_screen.dart';
import 'youtube_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleNavigation(BuildContext context, Widget destination) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (context.mounted) {
        NetworkErrorDialog.show(context);
      }
      return;
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- Start: Modified Logo with All-Around Black Fade/Glow ---
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.95), // Black color for the glow
                        blurRadius: 40.0, // High blur for a strong fade
                        spreadRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                // --- End: Modified Logo with All-Around Black Fade/Glow ---
                const SizedBox(height: 15),
                const Text(
                  'Welcome to',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const Text(
                  'Talent TV',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 50),
                GradientButton(
                  label: 'Talent TV',
                  icon: Icons.public,
                  onPressed: () => _handleNavigation(context, const WebViewScreen()),
                ),
                const SizedBox(height: 20),
                // --- Start: Added Talent Life Button ---
                GradientButton(
                  label: 'Talent Life',
                  icon: Icons.people_alt,
                  onPressed: () => _handleNavigation(
                    context,
                    const WebViewScreen(url: 'https://talenttv.lk/#/multi-player'),
                  ),
                  // Using different colors for differentiation
                  // gradientColors: [Colors.blue.shade700, Colors.cyan.shade600],
                ),
                const SizedBox(height: 20),
                // --- End: Added Talent Life Button ---
                GradientButton(
                  label: 'Talent Radio',
                  icon: Icons.radio,
                  onPressed: () async {
                    var connectivityResult = await Connectivity().checkConnectivity();
                    if (connectivityResult == ConnectivityResult.none) {
                      if (context.mounted) {
                        NetworkErrorDialog.show(context);
                      }
                      return;
                    }
                    // TODO: Navigate to Talent Radio screen
                  },
                ),
                const SizedBox(height: 20),
                // --- End: Added Talent Life Button ---
                GradientButton(
                  label: 'Youtube',
                  icon: Icons.play_arrow_sharp,
                  // Use the new YoutubeScreen here
                  onPressed: () => _handleNavigation(context, const YoutubeScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}