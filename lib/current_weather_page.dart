import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'fetch_weather.dart';
import 'weather_class_from_json.dart';
import 'package:intl/intl.dart';
import 'weather_Images.dart';

class CurrentWeatherPage extends StatefulWidget {
  final WeatherFetch weatherFetcher;

  const CurrentWeatherPage({Key? key, required this.weatherFetcher})
      : super(key: key);

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  WeatherClass? weatherData;
  String backgroundImage = 'assets/clouds2.jpg';
  String iconUrl = '';

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

        final String? iconCode = weatherClass.weather!.first.icon;
        iconUrl = 'https://openweathermap.org/img/wn/$iconCode.png';

        setState(() {
          weatherData = weatherClass;
          final String? condition = weatherData!.weather!.first.main;
          backgroundImage =
              WeatherImages().weatherToImage[condition] ?? 'assets/clouds2.jpg';
        });
      }
    } catch (error) {
      setState(() {
        weatherData = null;
        backgroundImage = 'assets/clouds2.jpg';
      });
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (weatherData != null)
                Padding(
                  padding: const EdgeInsets.only(top: 400.0, left: 40.0),
                  child: Row(
                    children: [
                      Image.network(iconUrl),
                      Text('${weatherData!.name}, ${weatherData!.sys!.country}',
                          style: TextStyle(
                              fontFamily: GoogleFonts.quicksand().fontFamily,
                              fontSize: 26,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    offset: const Offset(-0.5, -0.5),
                                    blurRadius: 4.0,
                                    color: Colors.black.withOpacity(0.8))
                              ])),
                    ],
                  ),
                ),
              if (weatherData != null)
                Padding(
                  padding: const EdgeInsets.only(left: 90.0),
                  child: Text(
                    getFormattedDate(weatherData?.dt ?? 0),
                    style: TextStyle(
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              offset: const Offset(-0.5, -0.5),
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.8))
                        ]),
                  ),
                ),
              if (weatherData != null)
                Padding(
                  padding: const EdgeInsets.only(left: 90.0),
                  child: Text(
                    '${weatherData!.weather!.first.description}',
                    style: TextStyle(
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              offset: const Offset(-0.5, -0.5),
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.8))
                        ]),
                  ),
                ),
              if (weatherData != null)
                Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: Text(
                      '${(weatherData!.main!.temp!).toStringAsFixed(0)} °C',
                      style: TextStyle(
                          fontFamily: GoogleFonts.quicksand().fontFamily,
                          fontSize: 18,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                offset: const Offset(-0.5, -0.5),
                                blurRadius: 4.0,
                                color: Colors.black.withOpacity(0.8))
                          ]),
                    )),
            ]),
      ),
    );
  }
}
