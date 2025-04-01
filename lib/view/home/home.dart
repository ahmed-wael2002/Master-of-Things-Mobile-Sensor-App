import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mot_app/model/accelerometer_sensor.dart';
import 'package:mot_app/model/gyroscope_sensor.dart';
import 'package:mot_app/model/light_sensor.dart';
import 'package:mot_app/view/accelerometer/accelerometer_widget.dart';
import 'package:mot_app/view/gyroscope/gyroscope_widget.dart';
import 'package:mot_app/view/light/lightsensor_widget.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});
  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _disposed = false;
  Duration sensorInterval = SensorInterval.normalInterval;

  // Initialize sensors immediately to avoid late initialization errors
  final AccelerometerSensor _accelerometerSensor = AccelerometerSensor(
    sensorId: 59190,
    samplingPeriod: SensorInterval.normalInterval,
  );

  final GyroscopeSensor _gyroscopeSensor = GyroscopeSensor(
    sensorId: 59191,
    samplingPeriod: SensorInterval.normalInterval,
  );

  final LightLuxSensor _lightLuxSensor = LightLuxSensor(
    sensorId: 59204,
    samplingPeriod: SensorInterval.normalInterval,
  );

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _initSensorStreams();
  }

  void _initSensorStreams() {
    if (_disposed) return;
    // Add accelerometer stream - don't use setState in the stream callbacks
    _streamSubscriptions.add(_accelerometerSensor.getStream());
    // Add gyroscope stream - don't use setState in the stream callbacks
    _streamSubscriptions.add(_gyroscopeSensor.getStream());
    // Add lightsensor stream
    _streamSubscriptions.add(_lightLuxSensor.getStream());

    // Set up a periodic timer to refresh the UI instead
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      if (mounted) {
        setState(() {
          // This empty setState will trigger a rebuild with latest sensor values
        });
      }
    });
  }

  void _updateSensors() {
    if (_disposed) return;
    // Cancel existing subscriptions
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();

    // Update sensor sampling periods
    _accelerometerSensor.samplingPeriod = sensorInterval;
    _gyroscopeSensor.samplingPeriod = sensorInterval;
    // Reinitialize sensor streams with new interval
    _initSensorStreams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Sensors Dashboard'),
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Use the widget from our accelerometer sensor
                  AccelerometerWidget(sensor: _accelerometerSensor),
                  // Gyroscope widget
                  GyroscopeWidget(sensor: _gyroscopeSensor),
                  // Light Sensor widget
                  LightWidget(sensor: _lightLuxSensor),
                ],
              ),
            ),
          ),

          _buildButtonSegment(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    // Cancel all subscriptions
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
    super.dispose();
  }

  _buildButtonSegment() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Update Interval:'),
          const SizedBox(height: 8),
          SegmentedButton<Duration>(
            segments: [
              ButtonSegment(
                value: SensorInterval.gameInterval,
                label: Text(
                  'Game\n'
                  '(${SensorInterval.gameInterval.inMilliseconds}ms)',
                ),
              ),
              ButtonSegment(
                value: SensorInterval.uiInterval,
                label: Text(
                  'UI\n'
                  '(${SensorInterval.uiInterval.inMilliseconds}ms)',
                ),
              ),
              ButtonSegment(
                value: SensorInterval.normalInterval,
                label: Text(
                  'Normal\n'
                  '(${SensorInterval.normalInterval.inMilliseconds}ms)',
                ),
              ),
              const ButtonSegment(
                value: Duration(milliseconds: 500),
                label: Text('500ms'),
              ),
              const ButtonSegment(
                value: Duration(seconds: 1),
                label: Text('1s'),
              ),
            ],
            selected: {sensorInterval},
            showSelectedIcon: false,
            onSelectionChanged: (value) {
              setState(() {
                sensorInterval = value.first;
                _updateSensors();
              });
            },
          ),
        ],
      ),
    );
  }
}
