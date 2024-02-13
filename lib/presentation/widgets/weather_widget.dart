import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:practica/presentation/widgets/weather_forecast.dart';
import 'package:practica/presentation/widgets/weather_forecast_card.dart';

class WeatherWidget extends StatelessWidget {
  final double temperature;
  final String description;
  final String iconUrl;
  final List<WeatherForecast> forecastList;

  const WeatherWidget({
    Key? key,
    required this.temperature,
    required this.description,
    required this.iconUrl,
    required this.forecastList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
    const SizedBox(height: 0),
        FadeInDown(
          child: Text(
            '${temperature.toStringAsFixed(0)}°C',
            style: const TextStyle(fontSize: 75),
          ),
        ),
        const SizedBox(height: 0),
        FadeInRight(
          child: Text(
            description,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 20),
        FadeIn(
          child: Image.network(
            iconUrl,
            width: 60,
            height: 60,
          ),
        ),
        const SizedBox(height: 10),
        FadeInLeft(
          child: const Text(
            'Pronóstico para los próximos días:',
            style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
          ),
        ),
            const SizedBox(height: 40),
        FadeInUp(
          child: SizedBox(
            height: 200,
            child: FadeInRight(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: forecastList.length,
                itemBuilder: (BuildContext context, int index) {
                  final weatherForecast = forecastList[index];
                  return WeatherForecastCard(weatherForecast: weatherForecast);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 100),
        FadeIn(
          delay: const Duration(seconds: 1),
          child: const Text(
            '  Todo inicio es Complicado \n Lo importante es comenzar!',
            style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}
