import 'package:flutter/material.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      home: FitnessHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FitnessHomePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  FitnessHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🏋️‍♀️ Fitness Tracker'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TEXT
              Text(
                'Selamat datang di Fitness App!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16),

              // IMAGE
              Image.network(
                'https://img.freepik.com/free-photo/athletic-man-training-gym_23-2149215976.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 16),

              // TEXTFIELD
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Masukkan nama kamu',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              // BUTTON
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Halo $name, siap latihan hari ini? 💪')),
                  );
                },
                child: Text('Mulai Latihan'),
              ),

              SizedBox(height: 24),

              // ROW & COLUMN (daftar menu latihan)
              Text(
                'Jenis Latihan Hari Ini',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: NeverScrollableScrollPhysics(), // biar scroll-nya ga dobel
                children: [
                  latihanCard('Push Up', Icons.fitness_center),
                  latihanCard('Sit Up', Icons.self_improvement),
                  latihanCard('Running', Icons.directions_run),
                  latihanCard('Yoga', Icons.accessibility_new),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card latihan (biar ga nulis ulang)
  Widget latihanCard(String nama, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.green[800]),
          SizedBox(height: 10),
          Text(
            nama,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
