// talent_radio_screen.dart
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
      await _audioPlayer.setUrl('https://radio.talenttv.lk/listen/talent_radio/radio.mp3');
      await _audioPlayer.play();
    } catch (e) {
      if (mounted) {
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
        _audioPlayer.setVolume(_savedVolume);
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
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Section - Logo and Title
              Column(
                children: [
                  // Animated Radio Icon
                  Container(
                    width: 140,
                    height: 140,
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
                          blurRadius: 30,
                          spreadRadius: 8,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.radio,
                          size: 75,
                          color: Colors.white,
                        ),
                        if (_isLoading)
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
                            strokeWidth: 5,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Talent Radio',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sri Lanka First Hybrid Media',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Live Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isPlaying
                            ? [const Color(0xFF00D084), const Color(0xFF00B870)]
                            : [Colors.grey.shade400, Colors.grey.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: (_isPlaying ? const Color(0xFF00D084) : Colors.grey).withOpacity(0.3),
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
                          style: const TextStyle(
                            fontSize: 12,
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
              // Middle Section - Main Controls
              Column(
                children: [
                  // Primary Control Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildModernControlButton(Icons.fast_rewind, const Color(0xFF5B9FFF), _backward),
                      const SizedBox(width: 8),
                      _buildModernControlButton(Icons.stop_circle, const Color(0xFFFF4757), _stop),
                      const SizedBox(width: 8),
                      // Main Play Button
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: _isPlaying
                                ? [const Color(0xFFFFB13D), const Color(0xFFFFA502)]
                                : [const Color(0xFF00D084), const Color(0xFF00B870)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isPlaying ? const Color(0xFFFFB13D) : const Color(0xFF00D084)).withOpacity(0.5),
                              blurRadius: 25,
                              spreadRadius: 6,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isPlaying ? _pause : _play,
                              borderRadius: BorderRadius.circular(35),
                              child: Center(
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildModernControlButton(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        _isMuted ? Colors.grey.shade600 : const Color(0xFF5B9FFF),
                        _toggleMute,
                      ),
                      const SizedBox(width: 8),
                      _buildModernControlButton(Icons.fast_forward, const Color(0xFF5B9FFF), _forward),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Modern Volume Control
                  Container(
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
                        // Volume Slider
                        Row(
                          children: [
                            Icon(Icons.volume_down, color: const Color(0xFFFF4757), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 6.0,
                                  activeTrackColor: const Color(0xFFFF4757),
                                  inactiveTrackColor: Colors.grey.shade300,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 10.0,
                                    elevation: 4.0,
                                  ),
                                  thumbColor: const Color(0xFFFF4757),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16.0,
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
                            Icon(Icons.volume_up, color: const Color(0xFFFF4757), size: 18),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 38,
                              child: Text(
                                '${(_isMuted ? 0 : _volume * 100).toStringAsFixed(0)}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Volume +/- Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildMinimalButton(Icons.remove, 'VOL−', _volumeDown),
                            const SizedBox(width: 12),
                            _buildMinimalButton(Icons.add, 'VOL+', _volumeUp),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Bottom Info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: const Text(
                  '🔴 Live Stream Active',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
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
    );
  }

  Widget _buildModernControlButton(IconData icon, Color color, VoidCallback onPressed) {
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
        width: 54,
        height: 54,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(27),
            child: Center(
              child: Icon(icon, size: 22, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalButton(IconData icon, String label, VoidCallback onPressed) {
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
            width: 44,
            height: 44,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(22),
                child: Center(
                  child: Icon(icon, size: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}