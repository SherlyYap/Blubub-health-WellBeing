import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String selectedGender = 'Female';
  String selectedBloodType = 'O';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('name') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      weightController.text = prefs.getString('weight') ?? '';
      heightController.text = prefs.getString('height') ?? '';
      selectedGender = prefs.getString('gender') ?? 'Female';
      selectedBloodType = prefs.getString('bloodType') ?? 'O';

      String? dobString = prefs.getString('dob');
      if (dobString != null) {
        selectedDate = DateTime.tryParse(dobString);
      }
    });
  }

  Future<void> saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('weight', weightController.text);
    await prefs.setString('height', heightController.text);
    await prefs.setString('gender', selectedGender);
    await prefs.setString('bloodType', selectedBloodType);
    if (selectedDate != null) {
      await prefs.setString('dob', selectedDate!.toIso8601String());
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  String getFormattedDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal lahir';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color.fromARGB(255, 202, 231, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0D273D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xff0D273D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildTextField(
                controller: usernameController,
                icon: Icons.person_outline,
                label: 'Username',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username wajib diisi';
                  }
                  return null;
                },
              ),

              _buildTextField(
                controller: emailController,
                icon: Icons.email_outlined,
                label: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),

              _buildTextField(
                controller: passwordController,
                icon: Icons.lock_outline,
                label: 'Password',
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password wajib diisi';
                  }
                  if (value.length < 8) return 'Password minimal 8 karakter';
                  return null;
                },
              ),

              _buildTextField(
                controller: phoneController,
                icon: Icons.phone_outlined,
                label: 'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Nomor telepon hanya boleh angka';
                  }
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.cake_outlined),
                    title: Text(getFormattedDate(selectedDate)),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime(2000, 1, 1),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ),

              _buildDropdown(
                icon: Icons.female,
                label: 'Gender',
                value: selectedGender,
                items: ['Male', 'Female', 'Other'],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),

              _buildTextField(
                controller: weightController,
                icon: Icons.monitor_weight_outlined,
                label: 'Weight (kg)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Berat badan wajib diisi';
                  }
                  return null;
                },
              ),

              _buildTextField(
                controller: heightController,
                icon: Icons.height_outlined,
                label: 'Height (cm)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tinggi badan wajib diisi';
                  }
                  return null;
                },
              ),

              _buildDropdown(
                icon: Icons.bloodtype_outlined,
                label: 'Blood Type',
                value: selectedBloodType,
                items: ['A', 'B', 'AB', 'O'],
                onChanged: (value) {
                  setState(() {
                    selectedBloodType = value!;
                  });
                },
              ),

              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await saveProfileData();

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile berhasil disimpan!'),
                        backgroundColor: Color(0xff0D273D),
                      ),
                    );
                    Navigator.pop(context, usernameController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D273D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            icon: Icon(icon),
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            icon: Icon(icon),
            labelText: label,
            border: InputBorder.none,
          ),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }
}
