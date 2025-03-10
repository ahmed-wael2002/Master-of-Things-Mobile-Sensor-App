import 'package:flutter/material.dart';

abstract class Sensor {
  final int sensorId;
  Duration samplingPeriod;
  Widget widget;
  Sensor({required this.sensorId, required this.samplingPeriod, required this.widget});
}
