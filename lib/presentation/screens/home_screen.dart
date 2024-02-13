import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practica/config/router/app_router.dart';
import 'package:practica/presentation/widgets/weather_forecast.dart';
import 'package:practica/presentation/widgets/weather_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double? temperature;
  String? description;
  String? iconCode;
  List<WeatherForecast> forecastList = [];
  late String userEmail;


  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _fetchWeatherForecast();
    getUserEmail();
  }

  Future<void> _fetchWeatherData() async {
    const apiKey = 'e593027583ce70088e6e944d2e82b829';
    const apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=Guatemala&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        temperature = data['main']['temp'];
        description = data['weather'][0]['description'];
        iconCode = data['weather'][0]['icon'];
      });
    } else {
      throw Exception('No se pudieron cargar los datos meteorológicos');
    }
  }

  Future<void> _fetchWeatherForecast() async {
    const apiKey = 'e593027583ce70088e6e944d2e82b829';
    const apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=Guatemala&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> forecastData =
          (data['list'] as List).cast<Map<String, dynamic>>();
      setState(() {
        forecastList = forecastData.map((item) {
          final DateTime forecastDateTime =
              DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
          final String forecastTime =
              '${forecastDateTime.hour}:${forecastDateTime.minute}0';
          return WeatherForecast(
            temperature: (item['main']['temp'] as num)
                .toDouble(), // Convertir a double
            date: forecastTime,
            iconUrl: _getWeatherIconUrl(item['weather'][0]['icon']),
          );
        }).toList();
      });
    } else {
      throw Exception(
          'No se pudieron cargar los datos del pronóstico del tiempo');
    }
  }

  String _getWeatherIconUrl(String iconCode) {
    const baseUrl = 'https://openweathermap.org/img/wn/';
    return '$baseUrl$iconCode.png';
  }

  void _showDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  Future<void> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    }
  }

  Future<void> _saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // ignore: unused_element
  Future<bool> _getLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: const Color.fromARGB(139, 149, 148, 148),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _showDrawer,
          ),
        ),
        drawer: FadeIn(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                FadeIn(
                  duration: const Duration(milliseconds: 400),
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 188, 193, 201),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 400),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.person, size: 60),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 300),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Hola $userEmail',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 530),
                FadeInLeft(
                  duration: const Duration(milliseconds: 300),
                  child: ListTile(
                    title: const Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text('Cerrar Sesión'),
                      ],
                    ),
                    onTap: () async {
                      await _saveLoginState(false);
                      appRouter.go('/login_screen');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/nuvesf.gif',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Center(
              child: temperature != null &&
                      description != null &&
                      iconCode != null
                  ? WeatherWidget(
                      temperature: temperature!,
                      description: description!,
                      iconUrl:
                          'https://openweathermap.org/img/wn/$iconCode.png',
                      forecastList: forecastList,
                    )
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
