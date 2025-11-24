// live_button.dart
import 'package:flutter/material.dart';

class LiveButton extends StatefulWidget {
  final VoidCallback onTap;

  const LiveButton({
    super.key,
    required this.onTap,
  });

  @override
  State<LiveButton> createState() => _LiveButtonState();
}

class _LiveButtonState extends State<LiveButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    // Responsive sizing
    final buttonSize = isTablet ? 85.0 : 70.0;
    final iconSize = isTablet ? 30.0 : 24.0;
    final fontSize = isTablet ? 14.0 : 12.0;
    final letterSpacing = isTablet ? 2.0 : 1.5;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ripple layer 1
            Container(
              width: buttonSize * _pulseAnimation.value,
              height: buttonSize * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(
                  (1 - _pulseAnimation.value + 1) * 0.3,
                ),
              ),
            ),
            // Outer ripple layer 2
            Container(
              width: buttonSize * ((_pulseAnimation.value - 0.3).clamp(1.0, 1.8)),
              height: buttonSize * ((_pulseAnimation.value - 0.3).clamp(1.0, 1.8)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(
                  ((1 - _pulseAnimation.value + 1) * 0.2).clamp(0.0, 0.2),
                ),
              ),
            ),
            // Main button
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.red.shade700,
                    Colors.red.shade900,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    spreadRadius: isTablet ? 6 : 5,
                    blurRadius: isTablet ? 18 : 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  customBorder: const CircleBorder(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: iconSize,
                        ),
                        SizedBox(height: isTablet ? 3 : 2),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: letterSpacing,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}