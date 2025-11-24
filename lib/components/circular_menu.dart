// circular_menu.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularMenu extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;
  final Function(String url) onMenuItemTap;
  final VoidCallback onDismiss;

  const CircularMenu({
    super.key,
    required this.menuItems,
    required this.onMenuItemTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    // Responsive sizing
    final menuSize = isTablet
        ? 360.0
        : (screenWidth * 0.75).clamp(280.0, 320.0);
    final radius = isTablet ? 140.0 : 110.0;
    final bottomPosition = isTablet ? 180.0 : 150.0;

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black54,
        child: Stack(
          children: [
            Positioned(
              bottom: bottomPosition,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: menuSize,
                  height: menuSize,
                  child: Stack(
                    children: List.generate(menuItems.length, (index) {
                      final angle = (index * 90 - 45) * 3.14159 / 180;
                      final x = radius * math.cos(angle);
                      final y = radius * math.sin(angle);

                      final itemSize = isTablet ? 80.0 : 70.0;
                      final centerOffset = menuSize / 2;

                      return Positioned(
                        left: centerOffset + x - (itemSize / 2),
                        top: centerOffset + y - (itemSize / 2),
                        child: _CircularMenuItem(
                          icon: menuItems[index]['icon'],
                          label: menuItems[index]['label'],
                          onTap: () => onMenuItemTap(menuItems[index]['url']),
                          size: itemSize,
                          isTablet: isTablet,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;
  final bool isTablet;

  const _CircularMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.size,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isTablet ? 40.0 : 35.0;
    final fontSize = isTablet ? 13.0 : 12.0;
    final labelPadding = isTablet ? 10.0 : 8.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.red.shade700,
            ),
          ),
          SizedBox(height: labelPadding),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: labelPadding,
              vertical: isTablet ? 5 : 4,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}