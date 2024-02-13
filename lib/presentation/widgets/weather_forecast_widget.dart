import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherForecastWidget extends StatefulWidget {
  const WeatherForecastWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WeatherForecastWidgetState createState() => _WeatherForecastWidgetState();
}

class _WeatherForecastWidgetState extends State<WeatherForecastWidget>
    with SingleTickerProviderStateMixin {
  late List<dynamic> forecastData;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
    _fetchWeatherForecast();
  }

  Future<void> _fetchWeatherForecast() async {
    const apiKey = 'e593027583ce70088e6e944d2e82b829';
    const apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=Guatemala&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        forecastData = data['list'];
      });
    } else {
      throw Exception('Failed to load weather forecast data');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (forecastData == null) {
      return const CircularProgressIndicator();
    }

    return FadeTransition(
      opacity: _opacityAnimation,
      child: ListView.builder(
        itemCount: forecastData.length,
        itemBuilder: (BuildContext context, int index) {
          final forecastItem = forecastData[index];
          final DateTime forecastDateTime =
              DateTime.fromMillisecondsSinceEpoch(forecastItem['dt'] * 1000);
          final String forecastTime =
              '${forecastDateTime.hour}:${forecastDateTime.minute}0';

          return ListTile(
            title: Text(forecastTime),
            subtitle: Text(
                '${forecastItem['main']['temp']}°C - ${forecastItem['weather'][0]['description']}'),
            leading: Image.network(
              _getWeatherIconUrl(forecastItem['weather'][0]['icon']),
              width: 50,
              height: 50,
            ),
          );
        },
      ),
    );
  }

  String _getWeatherIconUrl(String iconCode) {
    const baseUrl = 'https://openweathermap.org/img/wn/';
    return '$baseUrl$iconCode.png';
  }
}
