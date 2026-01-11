import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingButton extends StatefulWidget {
  final String url;

  const FloatingButton({
    super.key,
    this.url = 'https://www.winway.lk/',
  });

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton>
    with TickerProviderStateMixin {
  late AnimationController _typewriterController;
  late AnimationController _positionController;
  late Animation<int> _charCount;
  final String _fullText = 'Visit WinWay';

  @override
  void initState() {
    super.initState();

    // Typewriter animation
    _typewriterController = AnimationController(
      duration: Duration(milliseconds: _fullText.length * 80),
      vsync: this,
    );

    _charCount = StepTween(begin: 0, end: _fullText.length).animate(
      CurvedAnimation(parent: _typewriterController, curve: Curves.linear),
    );

    // Position animation
    _positionController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _startTypewriterLoop();
    _startPositionLoop();
  }

  void _startTypewriterLoop() async {
    await _typewriterController.forward();
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        await _typewriterController.reverse();
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            _startTypewriterLoop();
          }
        }
      }
    }
  }

  void _startPositionLoop() async {
    await _positionController.forward();
    if (mounted) {
      await _positionController.reverse();
      if (mounted) {
        _startPositionLoop();
      }
    }
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(widget.url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch URL')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_charCount, _positionController]),
      builder: (context, child) {
        final xOffset = (_positionController.value - 0.5) * 60;

        return Positioned(
          bottom: 30 + (_positionController.value * 20),
          right: 20 + xOffset,
          child: GestureDetector(
            onTap: _launchURL,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade700, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.red.shade400,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.open_in_new,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _fullText.substring(0, _charCount.value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
