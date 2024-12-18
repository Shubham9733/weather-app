# Weather App

A Flutter application that shows weather information for any city.

## Features
- Search for any city's weather.
- Dynamic animations and images.
- Error handling for invalid searches.
- Responsive and user-friendly design.

## How to Run
1. Clone the repository:
    ```bash
    git clone https://github.com/Shubham9733/weather-app
    ```
2. Install dependencies:
    ```bash
    flutter pub get
    ```
3. Run the app:
    ```bash
    flutter run
    ```

## API
- OpenWeatherMap API: [https://openweathermap.org/](https://openweathermap.org/)

## Project Structure
- `lib/`: Contains all Dart files.
  - `main.dart`: Entry point of the application.
  - `screens/`: Contains UI screens like `HomeScreen`.
  - `services/`: Contains business logic like `WeatherService`.

## API Key Setup
1. Go to [OpenWeatherMap](https://openweathermap.org/).
2. Sign up and get an API key.
3. Replace the API key in `weather_service.dart` with your key.

## Future Enhancements
- Add temperature unit toggle (Celsius/Fahrenheit).
- Implement location-based weather updates.
