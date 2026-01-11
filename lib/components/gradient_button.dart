import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;

  const GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    // Responsive sizing
    final buttonWidth = isTablet
        ? double.infinity // Full width in tablet grid layout
        : (screenWidth * 0.75)
            .clamp(180.0, 350.0); // 75% width on mobile, clamped

    final fontSize = isTablet ? 18.0 : (screenWidth * 0.04).clamp(14.0, 18.0);

    final iconSize = isTablet ? 24.0 : (screenWidth * 0.05).clamp(20.0, 24.0);

    final horizontalPadding =
        isTablet ? 40.0 : (screenWidth * 0.06).clamp(24.0, 40.0);

    final verticalPadding =
        isTablet ? 14.0 : (screenWidth * 0.03).clamp(10.0, 14.0);

    final borderRadius = isTablet ? 35.0 : 30.0;
    final shadowBlur = isTablet ? 15.0 : 12.0;
    final shadowSpread = isTablet ? 3.0 : 2.0;

    return Container(
      width: buttonWidth,
      constraints: BoxConstraints(
        minHeight: isTablet ? 58 : 48,
        maxWidth: isTablet ? double.infinity : 400,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            spreadRadius: shadowSpread,
            blurRadius: shadowBlur,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          colors: gradientColors ?? [Colors.red.shade700, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
