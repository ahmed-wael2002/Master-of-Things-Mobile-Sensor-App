import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mot_app/data/http_service.dart';
import 'package:mot_app/model/accelerometer_sensor.dart';
import 'package:mot_app/model/gyroscope_sensor.dart';

abstract class Sensor {
  int sensorId;
  Duration samplingPeriod;
  final String name;
  final IconData icon;

  Sensor({
    required this.sensorId,
    required this.samplingPeriod,
    required this.name,
    required this.icon,
  });

  // Method to update sensorId
  void updateSensorId(int id) {
    sensorId = id;
  }

  // Abstract methods to be implemented by concrete sensors
  StreamSubscription getStream();
  Map<String, dynamic> getData();

  // Common method to post readings to a server
  Future<void> postReadings() async {
    try {
      final data = getData();
      HttpService().postRequest(data);
      // return response.data;
    } 
    catch (e) {
      debugPrint('Error posting readings: $e');
    }
  }

  // Factory method to create a sensor by type
  static Sensor? createSensor(
    String type, {
    int? sensorId,
    Duration? samplingPeriod,
  }) {
    final Sensor? sensor;
    switch (type.toLowerCase()) {
      case 'accelerometer':
        sensor = AccelerometerSensor(
          sensorId: sensorId ?? 59190,
          samplingPeriod: samplingPeriod ?? const Duration(milliseconds: 200),
        ); // Remove unnecessary cast
      case 'gyroscope':
        sensor = GyroscopeSensor(
          sensorId: sensorId ?? 59191,
          samplingPeriod: samplingPeriod ?? const Duration(milliseconds: 200),
        ); // Remove unnecessary cast and fix ID
      default:
        sensor = null;
    }
    return sensor;
  }
}
