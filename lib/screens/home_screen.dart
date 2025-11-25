// home_screen.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../components/gradient_button.dart';
import '../components/network_error_dialog.dart';
import 'webview_screen.dart';
import 'youtube_screen.dart';
import 'life_screen.dart';
import 'talent_radio_screen.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    // Responsive sizing
    final logoSize = isTablet ? 280.0 : (screenWidth * 0.45).clamp(150.0, 250.0);
    final titleFontSize = isTablet ? 50.0 : (screenWidth * 0.1).clamp(32.0, 45.0);
    final subtitleFontSize = isTablet ? 22.0 : (screenWidth * 0.045).clamp(16.0, 20.0);
    final welcomeFontSize = isTablet ? 22.0 : (screenWidth * 0.045).clamp(16.0, 20.0);
    final horizontalPadding = isTablet ? 80.0 : 32.0;
    final verticalSpacing = isTablet ? 30.0 : 20.0;
    final logoSpacing = isTablet ? 25.0 : 15.0;
    final topSpacing = isTablet ? 50.0 : 40.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 600 : double.infinity,
                  minHeight: screenHeight - 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Responsive Logo with Glow
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.95),
                            blurRadius: isTablet ? 50.0 : 40.0,
                            spreadRadius: isTablet ? 15.0 : 10.0,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: logoSize,
                        height: logoSize,
                      ),
                    ),
                    SizedBox(height: logoSpacing),

                    // Welcome Text
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: welcomeFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Title
                    Text(
                      'Talent TV',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40.0 : 0.0,
                      ),
                      child: Text(
                        'Sri Lanka First Hybrid Media Broadcaster',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: const [
                            Shadow(
                              color: Colors.red,
                              offset: Offset(0.5, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: topSpacing),

                    // Buttons with responsive layout
                    if (isTablet)
                    // Tablet: Two columns
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GradientButton(
                                  label: 'Talent TV',
                                  icon: Icons.public,
                                  onPressed: () => _handleNavigation(
                                    context,
                                    const WebViewScreen(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: GradientButton(
                                  label: 'Talent Life',
                                  icon: Icons.people_alt,
                                  onPressed: () => _handleNavigation(
                                    context,
                                    const WebViewScreen(
                                      url: 'https://talenttv.lk/#/life',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: verticalSpacing),
                          Row(
                            children: [
                              Expanded(
                                child: GradientButton(
                                  label: 'Talent Radio',
                                  icon: Icons.radio,
                                  onPressed: () => _handleNavigation(
                                    context,
                                    const TalentRadioScreen(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: GradientButton(
                                  label: 'Youtube',
                                  icon: Icons.play_arrow_sharp,
                                  onPressed: () => _handleNavigation(
                                    context,
                                    const YoutubeScreen(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                    // Mobile: Single column
                      Column(
                        children: [
                          GradientButton(
                            label: 'Talent TV',
                            icon: Icons.public,
                            onPressed: () => _handleNavigation(
                              context,
                              const WebViewScreen(),
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          GradientButton(
                            label: 'Talent Life',
                            icon: Icons.people_alt,
                            onPressed: () => _handleNavigation(
                              context,
                              const WebViewScreen(
                                url: 'https://talenttv.lk/#/life',
                              ),
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          GradientButton(
                            label: 'Talent Radio',
                            icon: Icons.radio,
                            onPressed: () => _handleNavigation(
                              context,
                              const TalentRadioScreen(),
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          GradientButton(
                            label: 'Youtube',
                            icon: Icons.play_arrow_sharp,
                            onPressed: () => _handleNavigation(
                              context,
                              const YoutubeScreen(),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}