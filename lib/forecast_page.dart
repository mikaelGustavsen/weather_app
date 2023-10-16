import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'fetch_weather.dart';
import 'package:intl/intl.dart';
import 'forecast_class_from_json.dart';
import 'weather_Images.dart';

class ForecastPage extends StatefulWidget {
  final WeatherFetch weatherFetcher;

  const ForecastPage({Key? key, required this.weatherFetcher})
      : super(key: key);

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  Forecast? forecast;
  String backgroundImage = 'assets/clouds2.jpg';
  String iconUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  String getFormattedDate(int unixTimestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return DateFormat('EEEE, MMMM d, y').format(dateTime);
  }

  Future<void> _fetchForecast() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    try {
      if (permissionStatus.isGranted) {
        final Position pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final Map<String, dynamic> jsonData = await widget.weatherFetcher
            .getForecastAtLocation(pos.latitude, pos.longitude);

        final Forecast forecastData = Forecast.fromJson(jsonData);

        setState(() {
          forecast = forecastData;
          final String? condition = forecast!
              .forecastList!
              .first
              .weather![forecast!.forecastList!.first.weather!.length ~/ 2]
              .description;
          backgroundImage =
              WeatherImages().weatherToImage[condition] ?? 'assets/clouds2.jpg';
        });
      }
    } catch (error) {
      setState(() {
        forecast = null;
        backgroundImage = 'assets/clouds2.jpg';
      });
    }
  }

  String getFormattedTime(int unixTimestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (forecast == null) {
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        )),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            backgroundColor: Colors.amber,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListView.separated(
                itemCount: forecast!.forecastList!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Image.network(
                              'https://openweathermap.org/img/wn/${forecast!.forecastList![index].weather!.first.icon}.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getFormattedDate(
                                  forecast!.forecastList![index].dt ?? 0),
                              style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.quicksand().fontFamily,
                                  fontSize: 14,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        offset: const Offset(-0.5, -0.5),
                                        blurRadius: 4.0,
                                        color: Colors.black.withOpacity(0.8))
                                  ]),
                            ),
                            Text(
                              getFormattedTime(
                                  forecast!.forecastList![index].dt ?? 0),
                              style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.quicksand().fontFamily,
                                  fontSize: 14,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        offset: const Offset(-0.5, -0.5),
                                        blurRadius: 4.0,
                                        color: Colors.black.withOpacity(0.8))
                                  ]),
                            ),
                            Text(
                              '${(forecast!.forecastList![index].main!.temp!).toStringAsFixed(0)} °C - ${forecast!.forecastList![index].weather!.first.description}',
                              style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.quicksand().fontFamily,
                                  fontSize: 14,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        offset: const Offset(-0.5, -0.5),
                                        blurRadius: 4.0,
                                        color: Colors.black.withOpacity(0.8))
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(
                  thickness: 2,
                ),
              ),
            ),
          ],
        ));
  }
}
