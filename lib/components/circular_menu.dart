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
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black54,
        child: Stack(
          children: [
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    children: List.generate(menuItems.length, (index) {
                      final angle = (index * 90 - 45) * 3.14159 / 180;
                      final radius = 110.0;
                      final x = radius * math.cos(angle);
                      final y = radius * math.sin(angle);

                      return Positioned(
                        left: 140 + x - 35,
                        top: 140 + y - 35,
                        child: _CircularMenuItem(
                          icon: menuItems[index]['icon'],
                          label: menuItems[index]['label'],
                          onTap: () => onMenuItemTap(menuItems[index]['url']),
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

  const _CircularMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
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
              size: 35,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}