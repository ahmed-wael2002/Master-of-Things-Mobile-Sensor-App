import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mot_app/model/Sensor.dart';
import 'package:light_sensor/light_sensor.dart';

class LightLuxSensor extends Sensor {
  // Private fields
  int _captureTime = 0;
  int _currentLuxValue = 0;

  // Getters
  int get captureTime => _captureTime;
  int get currentLuxValue => _currentLuxValue;

  // Constructor
  LightLuxSensor({
    super.sensorId = 59190,
    super.samplingPeriod = const Duration(milliseconds: 200),
  }) : super(name: 'Light', icon: LineAwesome.lightbulb_solid);

  @override
  Map<String, dynamic> getData() {
    return {
      "Package": {
        "SensorInfo": {"SensorId": sensorId},
        "SensorData": {
          "captureTime": _captureTime,
          "phoneVersion": "Android 13.0",
          "appVersion": "1.0.0",
          "currentLuxValue": _currentLuxValue,
        },
      },
      "Auth": {"DriverManagerId": "1", "DriverManagerPassword": "123"},
    };
  }

  @override
  StreamSubscription<int> getStream() {
    return LightSensor.luxStream().listen((lux) {
      _currentLuxValue = lux;
      _captureTime += 10;

      postReadings(context).catchError((error) {
        throw error;
      });
    }, cancelOnError: true);
  }
}
