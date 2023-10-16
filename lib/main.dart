import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'current_weather_page.dart';
import 'fetch_weather.dart';
import 'package:flutter/services.dart';
import 'forecast_page.dart';
import 'about_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));

  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  final WeatherFetch weatherFetcher =
      WeatherFetch('85f664ab3345cd7521baf5ca1504bc6a');

  WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _WeatherAppCreate(weatherFetcher: weatherFetcher),
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
        brightness: Brightness.dark,
      ),
    );
  }
}

class _WeatherAppCreate extends StatefulWidget {
  final WeatherFetch weatherFetcher;

  const _WeatherAppCreate({required this.weatherFetcher});

  @override
  State<_WeatherAppCreate> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<_WeatherAppCreate> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      CurrentWeatherPage(weatherFetcher: widget.weatherFetcher),
      ForecastPage(weatherFetcher: widget.weatherFetcher),
      AboutPage(weatherFetcher: widget.weatherFetcher),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 1,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.grey.withOpacity(0.5),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.beach_access),
              label: 'Current Weather',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Forecast',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'About',
            ),
          ]),
    );
  }
}
