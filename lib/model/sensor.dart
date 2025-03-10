import 'package:flutter/material.dart';

abstract class Sensor {
  final String name;
  final int sensorId;
  final Duration samplingPeriod;
  final Widget widget;

  Sensor({
    required this.name,
    required this.sensorId,
    required this.samplingPeriod,
    required this.widget,
  });

  // Factory method to create a sensor by type
  static Sensor? createSensor(
    String type, {
    int? sensorId,
    Duration? samplingPeriod,
  }) {
    // This will be implemented when we have more sensor types
    return null;
  }
}
