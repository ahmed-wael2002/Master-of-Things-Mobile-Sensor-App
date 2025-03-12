import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mot_app/model/Sensor.dart'; // Fixed import path to match actual file name case
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeSensor extends Sensor {
  GyroscopeEvent? gyroscopeEvent;
  int captureTime = 0;

  GyroscopeSensor({
    super.sensorId = 59191,
    super.samplingPeriod = const Duration(milliseconds: 200),
  }) : super(name: 'Gyroscope', icon: LineAwesome.sync_solid);

  @override
  StreamSubscription<GyroscopeEvent> getStream() {
    return gyroscopeEventStream(samplingPeriod: samplingPeriod).listen((
      GyroscopeEvent event,
    ) {
      gyroscopeEvent = event;
      captureTime += 10;
      // Handle the Future properly
      postReadings().then((_) {}).catchError((error) {
        debugPrint('Error posting gyroscope readings: $error');
      });
    }, cancelOnError: true);
  }

  @override
  Map<String, dynamic> getData() {
    return {
      "Package": {
        "SensorInfo": {"SensorId": sensorId},
        "SensorData": {
          "captureTime": captureTime,
          "phoneVersion": "Android 13.0",
          "appVersion": "1.0.0",
          "x": gyroscopeEvent?.x ?? 0,
          "y": gyroscopeEvent?.y ?? 0,
          "z": gyroscopeEvent?.z ?? 0,
        },
      },
      "Auth": {"DriverManagerId": "1", "DriverManagerPassword": "123"},
    };
  }
}
