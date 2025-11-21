import 'package:flutter/material.dart';

class AnimatedNotchBottomBar extends StatefulWidget {
  final bool canGoBack;
  final VoidCallback onBackPressed;
  final VoidCallback onForwardPressed;
  final VoidCallback onMenuPressed;
  final VoidCallback onReloadPressed;
  final VoidCallback onHomePressed;
  final bool showMenu;

  const AnimatedNotchBottomBar({
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
  State<AnimatedNotchBottomBar> createState() => _AnimatedNotchBottomBarState();
}

class _AnimatedNotchBottomBarState extends State<AnimatedNotchBottomBar> {
  int _selectedIndex = 2; // Menu is center/default

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        widget.onBackPressed();
        break;
      case 1:
        widget.onForwardPressed();
        break;
      case 2:
        widget.onMenuPressed();
        break;
      case 3:
        widget.onReloadPressed();
        break;
      case 4:
        widget.onHomePressed();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Notch background
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: NotchPainter(
              notchPosition: _getNotchPosition(),
              color: Colors.red.shade700,
            ),
          ),
          // Navigation items
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    icon: Icons.arrow_back_ios_new,
                    index: 0,
                    enabled: widget.canGoBack,
                  ),
                  _buildNavItem(
                    icon: Icons.arrow_forward_ios,
                    index: 1,
                    enabled: true,
                  ),
                  _buildCenterNavItem(
                    icon: widget.showMenu ? Icons.close : Icons.menu,
                    index: 2,
                  ),
                  _buildNavItem(
                    icon: Icons.refresh,
                    index: 3,
                    enabled: true,
                  ),
                  _buildNavItem(
                    icon: Icons.home,
                    index: 4,
                    enabled: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool enabled,
  }) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? () => _onItemTapped(index) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  icon,
                  color: enabled
                      ? (isSelected ? Colors.red.shade700 : Colors.grey.shade600)
                      : Colors.grey.shade300,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 6 : 0,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavItem({
    required IconData icon,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Transform.translate(
          offset: const Offset(0, -20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.red.shade700, Colors.red.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade700.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedRotation(
              turns: widget.showMenu ? 0.125 : 0,
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

  double _getNotchPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth / 2;
  }
}

class NotchPainter extends CustomPainter {
  final double notchPosition;
  final Color color;

  NotchPainter({
    required this.notchPosition,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from left
    path.lineTo(0, 0);

    // Left side of notch
    final notchStart = notchPosition - 50;
    path.lineTo(notchStart, 0);

    // Create the notch curve
    path.quadraticBezierTo(
      notchStart + 10,
      0,
      notchStart + 15,
      10,
    );

    path.quadraticBezierTo(
      notchStart + 20,
      20,
      notchStart + 25,
      25,
    );

    // Top of notch
    path.lineTo(notchStart + 75, 25);

    // Right side of notch curve
    path.quadraticBezierTo(
      notchStart + 80,
      20,
      notchStart + 85,
      10,
    );

    path.quadraticBezierTo(
      notchStart + 90,
      0,
      notchStart + 100,
      0,
    );

    // Right side
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NotchPainter oldDelegate) {
    return oldDelegate.notchPosition != notchPosition ||
        oldDelegate.color != color;
  }
}