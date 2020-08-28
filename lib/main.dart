import 'package:flutter/material.dart';
import 'package:screen/screen.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.red, brightness: Brightness.dark),
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
    home: ScreenBrightness()));

class ScreenBrightness extends StatefulWidget {
  @override
  _ScreenBrightnessState createState() => _ScreenBrightnessState();
}

class _ScreenBrightnessState extends State<ScreenBrightness> {
  @override
  double _brightness;
  bool _enableKeptOn;

  @override
  void initState() {
    super.initState();
    getBrightness();
    getIsKeptOnScreen();
  }

  void getBrightness() async {
    double value = await Screen.brightness;
    setState(() {
      _brightness = double.parse(value.toStringAsFixed(1));
    });
  }

  void getIsKeptOnScreen() async {
    bool value = await Screen.isKeptOn;
    setState(() {
      _enableKeptOn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Screen Brightness")),
      body: Column(
        children: <Widget>[
          // Notice
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            alignment: Alignment(0, 0),
            height: 50,
            decoration: BoxDecoration(color: Colors.orange),
            child: Text(
              "Do this example on a Real Phone, not an Emulator.",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Brightness Settings
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Brightness:"),
                (_brightness == null)
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                      )
                    : Slider(
                        activeColor: Colors.grey,
                        value: _brightness,
                        min: 0,
                        max: 1.0,
                        divisions: 20,
                        onChanged: (newValue) {
                          setState(() {
                            _brightness = newValue;
                          });
                          // set screen's brightness
                          Screen.setBrightness(_brightness);
                        },
                      ),
                Text((_brightness * 100).toStringAsFixed(1) + "%"),
              ],
            ),
          ),
          // Kept-On Settings
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Kept on Screen:"),
                Text(_enableKeptOn.toString()),
                (_enableKeptOn == null)
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      )
                    : Switch(
                        activeColor: Colors.grey,
                        value: _enableKeptOn,
                        onChanged: (flag) {
                          Screen.keepOn(flag);
                          getIsKeptOnScreen();
                        },
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
