import 'dart:async';
import 'package:flutter/material.dart';

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

  // Factory method to create a sensor by type
  static Sensor? createSensor(
    String type, {
    int? sensorId,
    Duration? samplingPeriod,
  }) {
    // This will be implemented when we have more sensor types
    return null;
  }

  void updateSensorId(int sensorId) {
    this.sensorId = sensorId;
  }
}
