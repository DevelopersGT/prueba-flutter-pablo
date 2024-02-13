
import 'package:flutter/material.dart';
import 'package:practica/presentation/widgets/weather_forecast.dart';

class WeatherForecastCard extends StatelessWidget {
  final WeatherForecast weatherForecast;

  const WeatherForecastCard({Key? key, required this.weatherForecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: const Color.fromARGB(116, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${weatherForecast.temperature.toStringAsFixed(0)}°C',
                style: const TextStyle(fontSize: 27),
              ),
              const SizedBox(height: 5),
              Text(
                weatherForecast.date,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Image.network(
                weatherForecast.iconUrl,
                width: 70,
                height: 50,
              ),
            ],
          ),
        ),
    );
  }
}
