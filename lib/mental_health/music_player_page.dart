import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerPage extends StatefulWidget {
  final String title;
  final String url;

  const MusicPlayerPage({super.key, required this.title, required this.url});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isSeeking = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _player.setUrl(widget.url);

      _player.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            _duration = duration;
          });
        }
      });

      _player.positionStream.listen((position) {
        if (!_isSeeking) {
          setState(() {
            _position = position;
          });
        }
      });

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _player.seek(Duration.zero);
          _player.pause();
        }
      });

    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDurationKnown = _duration.inMilliseconds > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title, style: GoogleFonts.nunito(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 30),
            Text(
              widget.title,
              style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Slider(
              value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
              max: isDurationKnown ? _duration.inSeconds.toDouble() : 1.0,
              onChangeStart: (_) => _isSeeking = true,
              onChanged: (value) {
                setState(() {
                  _position = Duration(seconds: value.toInt());
                });
              },
              onChangeEnd: (value) {
                _player.seek(Duration(seconds: value.toInt()));
                _isSeeking = false;
              },
            ),
            Text(
              '${_formatDuration(_position)} / ${isDurationKnown ? _formatDuration(_duration) : "--:--"}',
              style: GoogleFonts.nunito(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 30),

            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final playing = state?.playing ?? false;
                return IconButton(
                  iconSize: 70,
                  icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                  onPressed: () async {
                    if (playing) {
                      await _player.pause();
                    } else {
                      await _player.play();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
