import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mot_app/model/accelerometer_sensor.dart';
import 'package:mot_app/model/gyroscope_sensor.dart';
import 'package:mot_app/model/http_service.dart';

abstract class Sensor {
  final String name;
  int sensorId;
  final Duration samplingPeriod;
  final IconData icon; // Changed from Icon to IconData

  Sensor({
    required this.name,
    required this.sensorId,
    required this.samplingPeriod,
    required this.icon,
  });

  // Abstract method to be implemented by all sensor types
  StreamSubscription<dynamic> getStream();

  // Abstract method to be implemented by all sensor types
  Future<String> postReadings() async {
    try {
      final data = getData();
      final response = HttpService().postRequest(data);
      return response.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // Get file
  Map<String, dynamic> getData();

  // Factory method to create a sensor by type
  static Sensor? createSensor(
    String type, {
    int? sensorId,
    Duration? samplingPeriod,
  }) {
    switch (type.toLowerCase()) {
      case 'accelerometer':
        return AccelerometerSensor(
          sensorId: sensorId ?? 59190,
          samplingPeriod: samplingPeriod ?? const Duration(milliseconds: 200),
        ) as Sensor?;
      default:
        return null;
    }
  }

  void updateSensorId(int sensorId) {
    this.sensorId = sensorId;
  }
}
