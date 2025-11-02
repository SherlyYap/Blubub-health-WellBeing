import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutSessionPage extends StatefulWidget {
  final String workoutName;
  final String workoutImage; // Sekarang bisa dari URL (gifUrl)
  final String workoutDescription;
  final int duration;

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
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingSeconds = widget.duration * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        _showFinishDialog();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Selesai!", style: GoogleFonts.nunito()),
        content: Text(
          "Latihan telah selesai. Bagus banget! 💪",
          style: GoogleFonts.nunito(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("Kembali", style: GoogleFonts.nunito()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        title: Text("Sesi Latihan", style: GoogleFonts.nunito()),
        backgroundColor: const Color.fromARGB(255, 202, 231, 255),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Ganti dari Image.asset() jadi Image.network()
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.workoutImage,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                // Jika gagal load gambar, tampilkan ikon pengganti
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                ),
                // Bisa juga ditambah loading spinner
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(color: Color(0xff0D273D)),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.workoutName,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.workoutDescription,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 30),

            Text(
              "Waktu Tersisa:",
              style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // ✅ Countdown Timer
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 35, 76, 110),
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
              onPressed: () {
                _timer?.cancel();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.stop_circle, size: 28),
              label: Text("Akhiri Latihan", style: GoogleFonts.nunito(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0D273D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}