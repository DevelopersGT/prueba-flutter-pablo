import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica/config/router/app_router.dart';

class ResetPassword extends StatefulWidget {
  static const String name = 'reset_screen';
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Solicitud Válida'),
          content: const Text(
              'Hemos enviado un mensaje a tu correo para que cambies tu contraseña y puedas ingresar.'),
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
    } on FirebaseAuthException catch (e) {
      // Si ocurre un error, mostrar el mensaje de error
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.message ?? 'Error desconocido'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        appRouter.go('/login_screen');
        return true; 
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), 
            onPressed: () {
              appRouter.go('/login_screen');
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: const Text(
                      'Ingresa el correo al que quieres que llegue \n el método para reestablecer tu contraseña',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Correo Electronico",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: Colors.purple),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Este Campo Es Obligatorio";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    onPressed: passwordReset,
                    child: const Text('Cambiar Contraseña'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
