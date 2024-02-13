
import 'package:go_router/go_router.dart';
import 'package:practica/presentation/screens/home_screen.dart';
import 'package:practica/presentation/screens/login_screen.dart';
import 'package:practica/presentation/screens/register_screen.dart';
import 'package:practica/presentation/screens/reset_pasword.dart';
import 'package:practica/presentation/screens/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes:[
    GoRoute(
      path: '/',
      name: SplashScreen.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home_screen',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login_screen',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register_screen',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/reset_screen',
      name: ResetPassword.name,
      builder: (context, state) => const ResetPassword(),
    ),
  ],
);
