import 'package:flutter/material.dart';
import '../bloc/login_bloc.dart';
import '../helpers/user_info.dart';
import '../widget/warning_dialog.dart';
import '/ui/registrasi_page.dart';
import 'package:manajemenkesehatan/ui/pengingat_obat_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
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
                  _emailTextField(),
                  const SizedBox(height: 16),
                  _passwordTextField(),
                  const SizedBox(height: 32),
                  _buttonLogin(),
                  const SizedBox(height: 20),
                  _menuRegistrasi(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Logo aplikasi
  Widget _logo() {
    return Column(
      children: const [
        Icon(Icons.health_and_safety, size: 80, color: Colors.red),
        SizedBox(height: 8),
        Text(
          "Manajemen Kesehatan",
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

  // TextBox Email
  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email, color: Colors.red),
        labelText: "Email",
        labelStyle: const TextStyle(fontFamily: 'Arial', color: Colors.red),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Arial'),
    );
  }

  // TextBox Password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.red),
        labelText: "Password",
        labelStyle: const TextStyle(fontFamily: 'Arial', color: Colors.red),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Arial'),
    );
  }

  // Tombol Login
  Widget _buttonLogin() {
    return SizedBox(
      width: double.infinity, // Tombol diperpanjang
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Warna tombol merah
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(fontFamily: 'Arial', fontSize: 18),
        ),
        onPressed: _isLoading ? null : _submit, // Nonaktif saat loading
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
                "Login",
                style: TextStyle(color: Colors.white), // Teks putih
              ),
      ),
    );
  }

  // Fungsi submit untuk login
  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      LoginBloc.login(
        email: _emailTextboxController.text,
        password: _passwordTextboxController.text,
      ).then((value) async {
        if (value.code == 200) {
          await UserInfo().setToken(value.token!);
          await UserInfo().setUserID(value.userID!);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PengingatObatPage()),
          );
        } else {
          _showWarningDialog("Login gagal, silahkan coba lagi");
        }
      }).catchError((error) {
        _showWarningDialog("Login gagal, silahkan coba lagi");
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  // Fungsi untuk menampilkan dialog peringatan
  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WarningDialog(description: message),
    );
  }

  // Menu Registrasi
  Widget _menuRegistrasi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Belum punya akun?",
          style: TextStyle(fontFamily: 'Arial', fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistrasiPage()),
            );
          },
          child: const Text(
            "Registrasi",
            style: TextStyle(
              fontFamily: 'Arial',
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
