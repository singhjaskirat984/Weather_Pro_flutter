import 'package:flutter/material.dart';
import 'package:weatherpro/weather_forecast/ui/bottom_view.dart';
import 'package:weatherpro/weather_forecast/ui/mid_view.dart';

import 'model/weather_forecast_model.dart';
import 'network/network.dart';

class WeatherForecast extends StatefulWidget {
  @override
  _WeatherForecastState createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {

  Future<WeatherForecastModel> forecastObject;
  String _cityName = "New Delhi";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forecastObject = Network().getWeatherForecast(cityName: _cityName);
            forecastObject.then((weather) {
        print(weather.list[0].weather[0].main);
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          textFieldView(),
          Container(
            child: FutureBuilder<WeatherForecastModel>(
              future: forecastObject,
              builder: (BuildContext context, AsyncSnapshot<WeatherForecastModel> snapshot){
                if(snapshot.hasData){
                  return Column(
                    children: <Widget>[
                      midView(snapshot),
                      bottomView(snapshot,context),
                    ],
                  );
                }else{
                  return Container(
                    child: Center(child: CircularProgressIndicator(),),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textFieldView() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: TextField(
          decoration: InputDecoration(
              hintText: "Enter City Name",
              prefixIcon: Icon(Icons.search),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.all(8)),
          onSubmitted: (value) {
            setState(() {
              _cityName = value;
              getweather(city: _cityName);
            });
          },
        ),
      ),
    );
  }

  Future<WeatherForecastModel> getweather({String city}) {
     forecastObject = Network().getWeatherForecast(cityName: _cityName);
  }
}
