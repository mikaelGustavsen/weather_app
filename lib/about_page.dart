import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'fetch_weather.dart';
import 'weather_class_from_json.dart';
import 'package:intl/intl.dart';
import 'weather_Images.dart';

class AboutPage extends StatefulWidget {
  final WeatherFetch weatherFetcher;

  const AboutPage({Key? key, required this.weatherFetcher}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  WeatherClass? weatherData;
  String backgroundImage = 'assets/clouds2.jpg';

  @override
  void initState() {
    super.initState();
    _fetchCurrentWeather();
  }

  String getFormattedDate(int unixTimestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return DateFormat('EEEE, MMMM d, y').format(dateTime);
  }

  Future<void> _fetchCurrentWeather() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    try {
      if (permissionStatus.isGranted) {
        final Position pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final Map<String, dynamic> jsonData = await widget.weatherFetcher
            .getWeatherAtLocation(pos.latitude, pos.longitude);

        final WeatherClass weatherClass = WeatherClass.fromJson(jsonData);

        setState(() {
          weatherData = weatherClass;
          final String? condition = weatherData!.weather!.first.main;
          backgroundImage =
              WeatherImages().weatherToImage[condition] ?? 'assets/clouds2.jpg';
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          weatherData = null;
          backgroundImage = 'assets/clouds2.jpg';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Text(
              'Weather App Project',
              style: TextStyle(
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                  fontSize: 32,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        offset: const Offset(-0.9, -0.9),
                        blurRadius: 4.0,
                        color: Colors.black.withOpacity(0.8))
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'This app was developed for the course 1DV535 at Linneaus University using Flutter and OpenWeatherMap API',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                  fontSize: 18,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        offset: const Offset(-0.9, -0.9),
                        blurRadius: 4.0,
                        color: Colors.black.withOpacity(0.8))
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Developed by Mikael Gustavsen',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                  fontSize: 18,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        offset: const Offset(-0.9, -0.9),
                        blurRadius: 4.0,
                        color: Colors.black.withOpacity(0.8))
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
