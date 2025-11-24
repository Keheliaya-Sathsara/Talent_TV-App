// custom_bottom_bar.dart
import 'package:flutter/material.dart';
import 'dart:ui';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final viewPadding = MediaQuery.of(context).viewPadding;
    final isTablet = screenWidth >= 600;

    // Responsive sizing
    final barHeight = isTablet ? 80.0 : 70.0;
    final notchSize = isTablet ? 80.0 : 70.0;
    final iconSize = isTablet ? 28.0 : 24.0;
    final fontSize = isTablet ? 11.0 : 10.0;
    final centerIconSize = isTablet ? 36.0 : 30.0;

    // Account for device navigation bar
    final bottomPadding = viewPadding.bottom > 0
        ? viewPadding.bottom.clamp(0, 20).toDouble() // FIXED: Added .toDouble()
        : 0.0;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isTablet ? 35 : 30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: barHeight + 30 + bottomPadding,
            padding: EdgeInsets.only(bottom: bottomPadding),
            color: Colors.white.withOpacity(0.1),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // Custom painted background
                CustomPaint(
                  size: Size(screenWidth, barHeight),
                  painter: _NotchPainter(
                    color: Colors.white.withOpacity(0.15),
                    borderColor: Colors.white.withOpacity(0.3),
                    notchSize: notchSize,
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                ),

                // Navigation buttons
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
                        iconSize: iconSize,
                        fontSize: fontSize,
                      ),
                      _buildNavItem(
                        icon: Icons.arrow_forward_ios,
                        label: 'Forward',
                        onTap: onForwardPressed,
                        iconSize: iconSize,
                        fontSize: fontSize,
                      ),
                      SizedBox(width: notchSize * 1.2),
                      _buildNavItem(
                        icon: Icons.refresh,
                        label: 'Reload',
                        onTap: onReloadPressed,
                        iconSize: iconSize,
                        fontSize: fontSize,
                      ),
                      _buildNavItem(
                        icon: Icons.home,
                        label: 'Home',
                        onTap: onHomePressed,
                        iconSize: iconSize,
                        fontSize: fontSize,
                      ),
                    ],
                  ),
                ),

                // Center Menu button
                Positioned(
                  top: 0,
                  child: _buildCenterButton(
                    icon: showMenu ? Icons.close : Icons.menu,
                    onTap: onMenuPressed,
                    size: notchSize,
                    iconSize: centerIconSize,
                    showMenu: showMenu,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double iconSize,
    required double fontSize,
    bool enabled = true,
  }) {
    final Color itemColor = enabled ? Colors.red : Colors.grey.shade400;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: itemColor, size: iconSize),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: itemColor,
                    fontSize: fontSize,
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

  Widget _buildCenterButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
    required double iconSize,
    required bool showMenu,
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
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
    const double curveDepth = 8.0;
    const double borderWidth = 1.0;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(center - radius - 15, 0);
    path.quadraticBezierTo(
      center - radius + 5,
      0,
      center - radius + 10,
      curveDepth,
    );
    path.lineTo(center + radius - 10, curveDepth);
    path.quadraticBezierTo(
      center + radius - 5,
      0,
      center + radius + 15,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paintShadow = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawPath(path, paintShadow);

    final paintFill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paintFill);

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