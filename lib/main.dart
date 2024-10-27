import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/widgets/weatherdata_widget.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  String _bgImage = '';
  String _iconImg = '';
  String _cityName = '';
  String _temperature = '';
  String _tempMax = '';
  String _tempMin = '';
  String _sunrise = '';
  String _sunset = '';
  String _main = '';
  String _pressure = '';
  String _humidity = '';
  String _visibility = '';
  String _windSpeed = '';

  getData(String cityName) async {
    final WeatherService weatherService = WeatherService();
    var weatherData;
    if (cityName == '') {
      weatherData = await weatherService.fetchWeather();
    } else {
      weatherData = await weatherService.getweather(cityName);
    }
    debugPrint(weatherData.toString());
    setState(() {
      _cityName = weatherData['name'];
      _temperature = weatherData['main']['temp'].toStringAsFixed(1);
      _main = weatherData['weather'][0]['main'];
      _tempMax = weatherData['main']['temp_max'].toStringAsFixed(1);
      _tempMin = weatherData['main']['temp_min'].toStringAsFixed(1);
      _sunrise = DateFormat('hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunrise'] * 1000),
      );
      _sunset = DateFormat('hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunset'] * 1000),
      );
      _pressure = weatherData['main']['pressure'].toString();
      _humidity = weatherData['main']['humidity'].toString();
      _visibility = weatherData['visibility'].toString();
      _windSpeed = weatherData['wind']['speed'].toString();
      if (_main == 'Clear') {
        _bgImage = 'assets/images/clear.jpeg';
        _iconImg = 'assets/icons/clear.jpeg';
      } else if (_main == 'Clouds') {
        _bgImage = 'assets/images/clouds.jpeg';
        _iconImg = 'assets/icons/clouds.jpeg';
      } else if (_main == 'Rain') {
        _bgImage = 'assets/images/rain.webp';
        _iconImg = 'assets/icons/rain.jpg';
      } else if (_main == 'Fog') {
        _bgImage = 'assets/images/fog.jpeg';
        _iconImg = 'assets/icons/fog.png';
      } else if (_main == 'Thunderstorm') {
        _bgImage = 'assets/images/thunder.jpeg';
        _iconImg = 'assets/icons/thunder.png';
      } else {
        _bgImage = 'assets/images/haze.jpeg';
        _iconImg = 'assets/icons/haze.png';
      }
    });
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    getData('');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            _bgImage,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  TextField(
                    controller: _controller,
                    onChanged: (value) {
                      getData(value);
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                      hintText: 'Search The City',
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_sharp),
                      Text(
                        _cityName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text(
                    '$_temperature',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w200,
                      color: Colors.black38,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _main,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Image.asset(
                        _iconImg,
                        height: 40,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.arrow_upward),
                      Text('$_tempMax°C'),
                      Icon(Icons.arrow_downward),
                      Text('$_tempMin°C'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Card(
                    color: Colors.transparent,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Column(
                          children: [
                            WeatherDataTile(
                              index1: "Sunrise",
                              index2: "Sunset",
                              value1: _sunrise,
                              value2: _sunset,
                            
                            ),
                            SizedBox(height: 15),
                            WeatherDataTile(
                              index1: "Humidity",
                              index2: "Visibility",
                              value1: _humidity,
                              value2: _visibility,
                            ),
                            SizedBox(height: 15),
                            WeatherDataTile(
                              index1: "Pressure",
                              index2: "Wind Speed",
                              value1: _pressure,
                              value2: _windSpeed,
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
