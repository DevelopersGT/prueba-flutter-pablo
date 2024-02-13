import 'package:flutter/material.dart';
import 'package:practica/presentation/widgets/weather_forecast_widget.dart';

class TimeScreen extends StatelessWidget {
  static const String name = 'time_screen';

  const TimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción del Tiempo'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text(
              'Predicción del Clima para las siguientes horas y días',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            WeatherForecastWidget(), 
          ],
        ),
      ),
    );
  }
}
