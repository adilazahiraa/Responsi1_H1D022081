import 'package:flutter/material.dart';
import '../bloc/registrasi_bloc.dart';
import '../widget/success_dialog.dart';
import '../widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.redAccent,
              Colors.pinkAccent,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _logo(),
                  const SizedBox(height: 40),
                  _namaTextField(),
                  const SizedBox(height: 16),
                  _emailTextField(),
                  const SizedBox(height: 16),
                  _passwordTextField(),
                  const SizedBox(height: 16),
                  _passwordKonfirmasiTextField(),
                  const SizedBox(height: 32),
                  _buttonRegistrasi(), // Tombol diperpanjang di sini
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Column(
      children: const [
        Icon(Icons.app_registration, size: 80, color: Colors.red),
        SizedBox(height: 8),
        Text(
          "Registrasi Akun",
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _namaTextField() {
    return _buildTextField(
      label: "Nama",
      controller: _namaTextboxController,
      icon: Icons.person,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  Widget _emailTextField() {
    return _buildTextField(
      label: "Email",
      controller: _emailTextboxController,
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        final pattern = r'^[^@]+@[^@]+\.[^@]+$';
        if (!RegExp(pattern).hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return _buildTextField(
      label: "Password",
      controller: _passwordTextboxController,
      icon: Icons.lock,
      obscureText: true,
      validator: (value) {
        if (value!.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return _buildTextField(
      label: "Konfirmasi Password",
      icon: Icons.lock_outline,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required FormFieldValidator<String>? validator,
    TextEditingController? controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.red),
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Arial', color: Colors.red),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontFamily: 'Arial'),
    );
  }

  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity, // Tombol sepanjang layar
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(fontFamily: 'Arial', fontSize: 18),
        ),
        onPressed: _isLoading ? null : _submit,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
            : const Text(
                "Registrasi",
                style: TextStyle(
                  color: Colors.white, // Ubah warna teks menjadi putih
                  fontFamily: 'Arial',
                  fontSize: 18,
                ),
              ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      RegistrasiBloc.registrasi(
        nama: _namaTextboxController.text,
        email: _emailTextboxController.text,
        password: _passwordTextboxController.text,
      ).then((value) {
        _showSuccessDialog();
      }).catchError((error) {
        _showWarningDialog();
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SuccessDialog(
        description: "Registrasi berhasil, silahkan login",
        okClick: () {
          Navigator.pop(context); // Tutup dialog
          Navigator.pop(context); // Kembali ke halaman login
        },
      ),
    );
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const WarningDialog(
        description: "Registrasi gagal, silahkan coba lagi",
      ),
    );
  }
}
