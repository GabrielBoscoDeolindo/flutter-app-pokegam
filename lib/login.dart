import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  Future<void> _fazerLogin() async {
    String usuario = _userController.text.trim();
    String senha = _passController.text.trim();

    if (usuario.isNotEmpty && senha == "1234") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", usuario);
      if (!mounted) return;

      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => ProfilePage(username: usuario),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Senha incorreta! Tente '1234'"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo_pokegam.png",
                height: 100,
              ),

              const SizedBox(height: 20),

              const Text("Pokegam",
                  style: TextStyle(fontSize: 40, color: Colors.white)),

              const SizedBox(height: 10),
              const Text(
                "Entre com o nome de usuário de sua escolha!\nSuas informações serão salvas",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: _userController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  hintText: "Nome de usuário",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  hintText: "Senha",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _fazerLogin,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB241FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text("Entrar",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "(ei, a senha é 1234 shhhhhh)",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
