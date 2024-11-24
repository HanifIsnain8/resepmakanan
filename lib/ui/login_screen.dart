import 'package:flutter/material.dart';
import 'package:resepmakanan/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

String? _emailError;
String? _passwordError;
AuthService _authService = AuthService();

void _login(context) async {
  if (_formKey.currentState!.validate()) {
    try {
        final response = await _authService.login(
          _emailController.text,
          _passwordController.text
        );

        if (response["status"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"]))
          );
          // coding navigasi ke home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          //code untuk pesan kesalahan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"]))
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: $e"))
        );
      }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: _emailError
                ),
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              // password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",                  
                  errorText: _passwordError
                ),
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(onPressed: (){
                _login(context);
              }, child: Text("Login")),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, '/register');
              }, child: Text("Tidak punya akun? daftar dong disini!"))
            ],
          ),
        ),
      ),
    );
  }
}