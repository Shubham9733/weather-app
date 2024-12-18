import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Fetch weather data for the default city ("Delhi")
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherService>(context, listen: false)
          .fetchWeatherData('Delhi');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchWeather() {
    final cityName = _searchController.text.trim();
    if (cityName.isNotEmpty) {
      Provider.of<WeatherService>(context, listen: false)
          .fetchWeatherData(cityName);
      _searchController.clear(); // Clear search bar after search
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);

    // Dynamically set background color based on temperature
    Color _getBackgroundColor() {
      if (weatherService.weatherData != null &&
          weatherService.weatherData!.isNotEmpty) {
        final temp = weatherService.weatherData!['main']['temp'] as double;
        if (temp <= 15) return Colors.blue.shade300; // Cool
        if (temp <= 25) return Colors.orange.shade300; // Warm
        return Colors.red.shade300; // Hot
      }
      return Colors.blueGrey.shade300;
    }

    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App title
              const Text(
                'Search for Weather 🌦️',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter city name...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchWeather,
                      color: Colors.blueAccent,
                    ),
                  ),
                  onSubmitted: (_) => _searchWeather(),
                ),
              ),
              const SizedBox(height: 30),

              // Weather Card or Error Message
              weatherService.errorMessage != null
                  ? Column(
                      children: [
                        Icon(Icons.error, size: 80, color: Colors.red.shade400),
                        const SizedBox(height: 10),
                        Text(
                          weatherService.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : weatherService.weatherData != null &&
                          weatherService.weatherData!.isNotEmpty
                      ? AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            _controller.forward();
                            return Opacity(
                              opacity: _controller.value,
                              child: _buildWeatherCard(weatherService),
                            );
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Weather Card with icons and dynamic data
  Widget _buildWeatherCard(WeatherService weatherService) {
    final weatherData = weatherService.weatherData!;
    final weatherIcon =
        'https://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // City name
          Text(
            weatherData['name'],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          // Weather icon
          Image.network(
            weatherIcon,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          // Temperature
          Text(
            '${weatherData['main']['temp']}°C',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          // Weather description
          Text(
            weatherData['weather'][0]['description'],
            style: const TextStyle(
              fontSize: 18,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 20),
          // Additional weather details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'Humidity',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  Text(
                    '${weatherData['main']['humidity']}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Wind',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  Text(
                    '${weatherData['wind']['speed']} m/s',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
