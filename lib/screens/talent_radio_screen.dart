// talent_radio_screen.dart (Final Fix for RenderFlex Overflow)
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:ui' as ui;

class TalentRadioScreen extends StatefulWidget {
  const TalentRadioScreen({super.key});

  @override
  State<TalentRadioScreen> createState() => _TalentRadioScreenState();
}

class _TalentRadioScreenState extends State<TalentRadioScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  double _volume = 1.0;
  bool _isMuted = false;
  double _savedVolume = 1.0;
  Future<void>? _playbackFuture;
  bool _isLoadingTimedOut = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() {
          _isPlaying = playerState.playing;
          _isLoading = playerState.processingState == ProcessingState.loading;
        });
      }
    });
  }

  Future<void> _play() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _isLoadingTimedOut = false;
        });
      }

      // Create a timeout that triggers after 15 seconds
      _playbackFuture = Future.wait([
        _audioPlayer
            .setUrl('https://radio.talenttv.lk/listen/talent_radio/radio.mp3'),
        Future.delayed(const Duration(seconds: 15)).then((_) {
          if (_isLoading && mounted) {
            setState(() {
              _isLoadingTimedOut = true;
            });
          }
        }),
      ]);

      await _audioPlayer
          .setUrl('https://radio.talenttv.lk/listen/talent_radio/radio.mp3');
      await _audioPlayer.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing radio: $e')),
        );
      }
    }
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isLoadingTimedOut = false;
      });
    }
    await _audioPlayer.stop();
  }

  void _volumeUp() {
    if (!_isMuted) {
      setState(() {
        _volume = (_volume + 0.1).clamp(0.0, 1.0);
        _audioPlayer.setVolume(_volume);
      });
    }
  }

  void _volumeDown() {
    if (!_isMuted) {
      setState(() {
        _volume = (_volume - 0.1).clamp(0.0, 1.0);
        _audioPlayer.setVolume(_volume);
      });
    }
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        _isMuted = false;
        _volume = _savedVolume == 0.0 ? 1.0 : _savedVolume;
        _audioPlayer.setVolume(_volume);
      } else {
        _isMuted = true;
        _savedVolume = _volume;
        _audioPlayer.setVolume(0.0);
      }
    });
  }

  void _forward() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Live Stream: Forward Unavailable')),
    );
  }

  void _backward() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Live Stream: Backward Unavailable')),
    );
  }

  @override
  void dispose() {
    _playbackFuture = null;
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    // --- Responsive Sizing Variables ---
    final double iconContainerSize = isTablet ? 200.0 : 140.0;
    final double radioIconSize = isTablet ? 110.0 : 75.0;
    final double titleFontSize = isTablet ? 36.0 : 28.0;
    final double subtitleFontSize = isTablet ? 14.0 : 11.0;
    final double mainButtonSize = isTablet ? 90.0 : 70.0;
    final double mainIconSize = isTablet ? 48.0 : 38.0;
    // Adjusted control button size slightly lower for better fit on small phones
    final double controlButtonSize = isTablet ? 65.0 : 50.0;
    final double controlIconSize = isTablet ? 26.0 : 22.0;
    final double volumeButtonSize = isTablet ? 50.0 : 44.0;
    final double volumeIconSize = isTablet ? 20.0 : 18.0;
    final double sectionPadding = isTablet ? 60.0 : 40.0;
    // ---

    return Scaffold(
      appBar: AppBar(
        title: const Text('Talent Radio'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF5F5F5),
              const Color(0xFFE8E8E8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    (kToolbarHeight + MediaQuery.of(context).padding.top + 24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Section - Logo and Title
                Column(
                  children: [
                    // Animated Radio Icon Container (Responsive Size)
                    Container(
                      width: iconContainerSize,
                      height: iconContainerSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFF4757),
                            const Color(0xFFFF6348),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF4757).withOpacity(0.5),
                            blurRadius: isTablet ? 40 : 30,
                            spreadRadius: isTablet ? 10 : 8,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Radio Icon (Responsive Size)
                          Icon(
                            Icons.radio,
                            size: radioIconSize,
                            color: Colors.white,
                          ),
                          if (_isLoading)
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.7)),
                              strokeWidth: isTablet ? 7 : 5,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title Text (Responsive Font Size)
                    Text(
                      'Talent Radio',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Subtitle Text (Responsive Font Size)
                    Text(
                      'Sri Lanka First Hybrid Media',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Live Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isPlaying
                              ? [
                                  const Color(0xFF00D084),
                                  const Color(0xFF00B870)
                                ]
                              : [Colors.grey.shade400, Colors.grey.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: (_isPlaying
                                    ? const Color(0xFF00D084)
                                    : Colors.grey)
                                .withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isPlaying)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          Text(
                            _isLoading
                                ? 'Loading...'
                                : _isPlaying
                                    ? '● LIVE ON AIR'
                                    : '○ OFFLINE',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Padding between sections (Responsive)
                SizedBox(height: sectionPadding),

                // Middle Section - Main Controls
                Column(
                  children: [
                    // Primary Control Row (Overflow fixed here)
                    // Removed extra Padding, letting the Row use the full horizontal space minus 16px padding from SingleChildScrollView
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildModernControlButton(
                            Icons.fast_rewind,
                            const Color(0xFF5B9FFF),
                            _backward,
                            controlButtonSize,
                            controlIconSize),

                        const Spacer(flex: 2), // Flexible spacing

                        _buildModernControlButton(
                            Icons.stop_circle,
                            const Color(0xFFFF4757),
                            _stop,
                            controlButtonSize,
                            controlIconSize),

                        const Spacer(), // Smaller spacing around play button

                        // Main Play Button
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _isPlaying
                                  ? [
                                      const Color(0xFFFFB13D),
                                      const Color(0xFFFFA502)
                                    ]
                                  : [
                                      const Color(0xFF00D084),
                                      const Color(0xFF00B870)
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_isPlaying
                                        ? const Color(0xFFFFB13D)
                                        : const Color(0xFF00D084))
                                    .withOpacity(0.5),
                                blurRadius: 25,
                                spreadRadius: isTablet ? 8 : 6,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: mainButtonSize,
                            height: mainButtonSize,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _isPlaying ? _pause : _play,
                                borderRadius:
                                    BorderRadius.circular(mainButtonSize / 2),
                                child: Center(
                                  child: _isLoading
                                      ? SizedBox(
                                          width: mainIconSize,
                                          height: mainIconSize,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                Colors.white.withOpacity(0.9)),
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Icon(
                                          _isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: mainIconSize,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(), // Smaller spacing around play button

                        _buildModernControlButton(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          _isMuted
                              ? Colors.grey.shade600
                              : const Color(0xFF5B9FFF),
                          _toggleMute,
                          controlButtonSize,
                          controlIconSize,
                        ),

                        const Spacer(flex: 2), // Flexible spacing

                        _buildModernControlButton(
                            Icons.fast_forward,
                            const Color(0xFF5B9FFF),
                            _forward,
                            controlButtonSize,
                            controlIconSize),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Modern Volume Control (Responsive Margin for Tablets)
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: isTablet ? 40.0 : 0.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Volume Slider (Responsive Icons and Track)
                          Row(
                            children: [
                              Icon(Icons.volume_down,
                                  color: const Color(0xFFFF4757),
                                  size: isTablet ? 22 : 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: isTablet ? 8.0 : 6.0,
                                    activeTrackColor: const Color(0xFFFF4757),
                                    inactiveTrackColor: Colors.grey.shade300,
                                    thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius:
                                          isTablet ? 12.0 : 10.0,
                                      elevation: 4.0,
                                    ),
                                    thumbColor: const Color(0xFFFF4757),
                                    overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: isTablet ? 18.0 : 16.0,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _isMuted ? 0 : _volume,
                                    min: 0.0,
                                    max: 1.0,
                                    divisions: 20,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_isMuted) _isMuted = false;
                                        _volume = value;
                                        _audioPlayer.setVolume(_volume);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.volume_up,
                                  color: const Color(0xFFFF4757),
                                  size: isTablet ? 22 : 18),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: isTablet ? 50 : 38,
                                child: Text(
                                  '${(_isMuted ? 0 : _volume * 100).toStringAsFixed(0)}%',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isTablet ? 13 : 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Volume +/- Buttons (Uses responsive button sizes)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMinimalButton(
                                  Icons.remove,
                                  'VOL−',
                                  _volumeDown,
                                  volumeButtonSize,
                                  volumeIconSize),
                              SizedBox(width: isTablet ? 16 : 12),
                              _buildMinimalButton(Icons.add, 'VOL+', _volumeUp,
                                  volumeButtonSize, volumeIconSize),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sectionPadding),
                // Bottom Info (Responsive Padding and Font Size)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '🔴 Live Stream Active',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 11 : 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Methods Updated to Accept Dynamic Size ---

  Widget _buildModernControlButton(IconData icon, Color color,
      VoidCallback onPressed, double size, double iconSize) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(size / 2),
            child: Center(
              child: Icon(icon, size: iconSize, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalButton(IconData icon, String label,
      VoidCallback onPressed, double size, double iconSize) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [const Color(0xFFFF4757), const Color(0xFFFF6348)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4757).withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(size / 2),
                child: Center(
                  child: Icon(icon, size: iconSize, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10, // Consistent small font for label
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
