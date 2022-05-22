import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? temparature;
  String location = "Bangalore";
  int woeid = 2295420;
  String weather = "clear";
  String abbreviation = 'c';
  String errMsg = '';

  String searchApiUrl =
      'https://www.metaweather.com/api/location/search/?query=';

  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchSearch(String input) async {
    try {
      var searchResults = await http.get(Uri.parse(searchApiUrl + input));
      var result = json.decode(searchResults.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errMsg = '';
      });
    } catch (error) {
      setState(() {
        errMsg = 'Data for selected city is not available';
      });
    }
  }

  Future<void> fetchLocation() async {
    var locresult =
        await http.get(Uri.parse(locationApiUrl + woeid.toString()));
    var result = json.decode(locresult.body);
    var consolidatedweather = result["consolidated_weather"];
    var data = consolidatedweather[0];

    setState(() {
      temparature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ', '').toLowerCase();
      abbreviation =
          data["weather_state_abbr"].replaceAll(' ', '').toLowerCase();
    });
  }

  void onTextFieldSubmitted(String input) async {
    await fetchSearch(input);
    await fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/images/$weather.png'), fit: BoxFit.cover),
        ),
        child: temparature == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                    'lib/images/icons/$abbreviation.png'),
                                width: 100.0,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                weather.toString().toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.thermostat,
                                size: 50.0,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                temparature.toString() + '\u2103',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50.0),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pin_drop_outlined,
                                size: 50.0,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                location,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  // backgroundColor:
                                  //     Color.fromARGB(100, 22, 44, 33),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          child: TextField(
                            onSubmitted: (String input) =>
                                onTextFieldSubmitted(input),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search Another Location',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          errMsg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              backgroundColor: Colors.black12,
                              fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
