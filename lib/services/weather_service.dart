import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService extends ChangeNotifier {
  Map<String, dynamic>? weatherData = {};
  String? errorMessage;

  Future<void> fetchWeatherData(String cityName) async {
    const apiKey = 'eb8345d867a832435ccd8c770967e438';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        weatherData = json.decode(response.body);
        errorMessage = null;
        notifyListeners();
      } else {
        throw Exception('City not found');
      }
    } catch (e) {
      weatherData = {};
      errorMessage = 'Failed to fetch weather for "$cityName". Please try again.';
      notifyListeners();
    }
  }
}
