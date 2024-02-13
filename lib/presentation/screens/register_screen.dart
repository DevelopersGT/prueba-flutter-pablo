import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica/config/router/app_router.dart';

class RegisterScreen extends StatefulWidget {
  static const String name = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Usuario"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            appRouter.go('/login_screen');
          },
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            appRouter.pop();
          }
        },
        child: Center(
          // Centro de la pantalla
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    'assets/images/user.png',
                    height: 200,
                    width: 200,
                  ),
                ),
                const SizedBox(height: 50),
                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Correo Electrónico",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                    const BorderSide(color: Colors.purple),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => email = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                              if (!value.contains('@gmail.com')) {
                                return "El correo debe ser de Gmail";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                    const BorderSide(color: Colors.purple),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                              if (value.length <= 5) {
                                return "La contraseña debe tener más de 5 caracteres";
                              }
                              return null;
                            },
                            onSaved: (value) => password = value!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        UserCredential? credentials =
                            await createUser(email, password);
                        if (credentials != null && credentials.user != null) {
                          await credentials.user!.sendEmailVerification();
                          // Mostrar diálogo de éxito
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cuenta creada'),
                              content: const Text(
                                  'Hemos enviado un mensaje a tu correo para que verifiques tu cuenta y puedas ingresar.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    appRouter.go('/login_screen');
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Crear"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> createUser(String email, String password) async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? 'Error desconocido';
      });
    }
    return null;
  }
}
