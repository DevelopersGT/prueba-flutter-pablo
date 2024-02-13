import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica/config/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  void initState() {
    super.initState(); 
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      appRouter.go('/home_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 0,),
             FadeInDown(
              duration: const Duration(milliseconds: 500),
                    child: Image.asset('assets/images/logogogo2.png', height: 500, width: 500)
                  ),
            Offstage(
              offstage: error == "",
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  )),
            ),
            Padding(padding: const EdgeInsets.all(10), 
            child: formulario()),
            const SizedBox(height: 0,),
            buttonLogin(),
            resetPassword(),
            nuevoAqui(),
          ],
        ),
      ),
    );
  }

Widget nuevoAqui() {
    return FadeInUp(
              duration: const Duration(milliseconds: 500),
    delay: const Duration(milliseconds: 100),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Nuevo Aquí"),
          TextButton(
              onPressed: () {   
                appRouter.go('/register_screen');
              },
              child: const Text("Registrarse"))
        ],
      ),
    );
  }
  Widget resetPassword() {
    return FadeInUp(
              duration: const Duration(milliseconds: 500),
    delay: const Duration(milliseconds: 100),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Cambiar Contraseña"),
          TextButton(
              onPressed: () {   
                appRouter.go('/reset_screen');
              },
              child: const Text("He olvidado mi contraseña."))
        ],
      ),
    );
  }
  
  Widget formulario() {
    return FadeIn(
              duration: const Duration(milliseconds: 500),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildEmail(),
            const SizedBox(height: 15),
            buildPassword(),
          ],
        ),
      ),
    );
  }
 Widget buildPassword() {
  return FadeInUp(
    duration: const Duration(milliseconds: 500),
    delay: const Duration(milliseconds: 100),
    child: SizedBox(
      width: 500,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Contraseña",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.purple),
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
        onSaved: (String? value) {
          password = value!;
        },
      ),
    ),
  );
}
  Widget buildEmail() {
  return FadeInUp(
    duration: const Duration(milliseconds: 500),
    child: SizedBox(
      width: 500,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Correo Electrónico",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.purple),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        onSaved: (String? value) {
          email = value!;
        },
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
  );
}

  Widget buttonLogin() {
   return FadeInUp(
              duration: const Duration(milliseconds: 500),
    delay: const Duration(milliseconds: 100),
  child: SizedBox(
    width: 300, 
    child: ElevatedButton.icon(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          UserCredential? credentials = await login(email, password);
          if (credentials != null) {
            if (credentials.user != null) {
              if (credentials.user!.emailVerified) {
                await saveUserLoggedIn(true);
                appRouter.go('/home_screen');
              }
            } else {
              setState(() {
                error = "Usuario no encontrado o contraseña incorrecta";
              });
            }
          }
        }
      },
      icon: const Icon(Icons.login),
      label: const Text("Ingresar"),
    ),
  ),
);

  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          error = "Usuario no encontrado o contraseña incorrecta";
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          error = "Usuario no encontrado o contraseña incorrecta";
        });
      }
    }
    return null;
  }

  Future<void> saveUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }
}
