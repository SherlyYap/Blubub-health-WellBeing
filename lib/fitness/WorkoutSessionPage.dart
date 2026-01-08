import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutSessionPage extends StatefulWidget {
  final String workoutName;
  final String workoutImage;
  final String workoutDescription;
  final int duration; // dari slider (menit)

  const WorkoutSessionPage({
    super.key,
    required this.workoutName,
    required this.workoutImage,
    required this.workoutDescription,
    required this.duration,
  });

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  final FlutterBackgroundService _service = FlutterBackgroundService();

  int _remainingSeconds = 0;
  bool _started = false;
  bool _restoredFromBackground = false;

  @override
  void initState() {
    super.initState();
    _restoreTimer();
  }

  // ================= RESTORE TIMER =================
  Future<void> _restoreTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final endTime = prefs.getInt('endTime');

    if (endTime == null) return;

    final remaining =
        DateTime.fromMillisecondsSinceEpoch(endTime)
            .difference(DateTime.now());

    if (remaining.inSeconds <= 0) {
      await prefs.remove('endTime');
      return;
    }

    setState(() {
      _started = true;
      _restoredFromBackground = true;
      _remainingSeconds = remaining.inSeconds;
    });

    _listenService();
  }

  // ================= LISTEN BACKGROUND =================
  void _listenService() {
    _service.on('update').listen((event) {
      if (!mounted || event == null) return;

      final time = event['time'];
      if (time != null) {
        final parts = time.split(':');
        final m = int.parse(parts[0]);
        final s = int.parse(parts[1]);

        setState(() {
          _remainingSeconds = m * 60 + s;
        });
      }
    });
  }

  // ================= START WORKOUT =================
  Future<void> _startWorkout() async {
    if (_started) return;

    final prefs = await SharedPreferences.getInstance();

    // 🔥 pastikan timer lama dihapus
    await prefs.remove('endTime');

    final endTime = DateTime.now()
        .add(Duration(minutes: widget.duration))
        .millisecondsSinceEpoch;

    await prefs.setInt('endTime', endTime);

    await _service.startService();
    _listenService();

    setState(() {
      _started = true;
    });
  }

  // ================= STOP WORKOUT =================
  Future<void> _stopWorkout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('endTime');
    _service.invoke('stopService');

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) Navigator.pop(context);
  }

  // ================= FORMAT =================
  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')} : ${s.toString().padLeft(2, '0')}";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        title: Text("Sesi Latihan", style: GoogleFonts.nunito()),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.workoutImage,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.workoutName,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.workoutDescription,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 16),
            ),

            const SizedBox(height: 30),

            // ===== BUTTON START (ONLY IF NEW) =====
            if (!_started && !_restoredFromBackground)
              ElevatedButton.icon(
                onPressed: _startWorkout,
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  "Mulai Workout",
                  style: GoogleFonts.nunito(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D273D),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),

            // ===== TIMER =====
            if (_started) ...[
              const SizedBox(height: 20),
              Text("Waktu Tersisa",
                  style: GoogleFonts.nunito(fontSize: 20)),
              const SizedBox(height: 10),
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 35, 76, 110),
                ),
                alignment: Alignment.center,
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: GoogleFonts.nunito(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 202, 231, 255),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _stopWorkout,
                icon: const Icon(Icons.stop_circle),
                label: Text(
                  "Akhiri Latihan",
                  style: GoogleFonts.nunito(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
