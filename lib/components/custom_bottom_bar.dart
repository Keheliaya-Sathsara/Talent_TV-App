import 'package:flutter/material.dart';
import 'dart:ui'; // Required for ImageFilter

class CustomBottomBar extends StatelessWidget {
  final bool canGoBack;
  final VoidCallback onBackPressed;
  final VoidCallback onForwardPressed;
  final VoidCallback onMenuPressed;
  final VoidCallback onReloadPressed;
  final VoidCallback onHomePressed;
  final bool showMenu;

  const CustomBottomBar({
    super.key,
    required this.canGoBack,
    required this.onBackPressed,
    required this.onForwardPressed,
    required this.onMenuPressed,
    required this.onReloadPressed,
    required this.onHomePressed,
    required this.showMenu,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 70.0;
    const double notchSize = 70.0;

    return Material(
      color: Colors.transparent, // Ensure the Material widget itself is transparent
      elevation: 0,
      child: ClipRRect( // ClipRRect is important for the blur effect
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter( // This widget applies the blur effect (Liquid Glass effect)
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust sigma for blur intensity
          child: Container(
            height: barHeight + 30, // Keep total height
            color: Colors.white.withOpacity(0.1), // Base transparent color for the glass effect
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // The custom painted background bar (now draws the glossy effect)
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, barHeight),
                  painter: _NotchPainter(
                    color: Colors.white.withOpacity(0.15), // Slightly more opaque for the inner part
                    borderColor: Colors.white.withOpacity(0.3), // Light border for definition
                    notchSize: notchSize,
                    shadowColor: Colors.black.withOpacity(0.1), // Softer shadow
                  ),
                ),

                // Navigation buttons positioned horizontally
                SizedBox(
                  height: barHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        icon: Icons.arrow_back_ios_new,
                        label: 'Back',
                        onTap: onBackPressed,
                        enabled: canGoBack,
                      ),
                      _buildNavItem(
                        icon: Icons.arrow_forward_ios,
                        label: 'Forward',
                        onTap: onForwardPressed,
                      ),
                      const SizedBox(width: notchSize * 1.2),
                      _buildNavItem(
                        icon: Icons.refresh,
                        label: 'Reload',
                        onTap: onReloadPressed,
                      ),
                      _buildNavItem(
                        icon: Icons.home,
                        label: 'Home',
                        onTap: onHomePressed,
                      ),
                    ],
                  ),
                ),

                // The prominent circular center Menu button
                Positioned(
                  top: 0,
                  child: _buildCenterButton(
                    icon: showMenu ? Icons.close : Icons.menu,
                    onTap: onMenuPressed,
                    size: notchSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for regular navigation items
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final Color itemColor = enabled ? Colors.red : Colors.grey.shade400;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: itemColor, size: 24),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: itemColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for the elevated center Menu button
  Widget _buildCenterButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade700.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: AnimatedRotation(
              turns: showMenu ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// CustomPainter to draw the floating, notched shape with a smooth wave curve
class _NotchPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final Color shadowColor;
  final double notchSize;

  _NotchPainter({
    required this.color,
    required this.borderColor,
    required this.shadowColor,
    required this.notchSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width / 2;
    final double radius = notchSize / 2;
    // Reduced curve depth for a gentler wave effect (Smooth Wave Shape)
    const double curveDepth = 8.0;
    const double borderWidth = 1.0;

    final path = Path();

    // 1. Start at top left
    path.moveTo(0, 0);

    // 2. Line to start of the wave (shorter straight section)
    path.lineTo(center - radius - 15, 0);

    // 3. Gentle curve down (Start of the wave)
    path.quadraticBezierTo(
      center - radius + 5,
      0,
      center - radius + 10,
      curveDepth,
    );

    // 4. Smooth segment across the button's center
    path.lineTo(center + radius - 10, curveDepth);

    // 5. Gentle curve up (End of the wave)
    path.quadraticBezierTo(
      center + radius - 5,
      0,
      center + radius + 15,
      0,
    );

    // 6. Line to top right
    path.lineTo(size.width, 0);

    // 7. Line to bottom right (and close path below the fold)
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw Shadow
    final paintShadow = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawPath(path, paintShadow);

    // Draw the main fill color
    final paintFill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paintFill);

    // Draw the border
    final paintBorder = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawPath(path, paintBorder);
  }

  @override
  bool shouldRepaint(_NotchPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.notchSize != notchSize ||
        oldDelegate.shadowColor != shadowColor;
  }
}