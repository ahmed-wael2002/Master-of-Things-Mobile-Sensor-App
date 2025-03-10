// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mot_app/model/accelerometer_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Add error handler for Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // You can add custom error logging here if needed
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(title: 'Sensors Dashboard'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  UserAccelerometerEvent? _userAccelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;
  BarometerEvent? _barometerEvent;

  DateTime? _userAccelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  DateTime? _magnetometerUpdateTime;
  DateTime? _barometerUpdateTime;

  int? _userAccelerometerLastInterval;
  int? _gyroscopeLastInterval;
  int? _magnetometerLastInterval;
  int? _barometerLastInterval;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _disposed = false;

  Duration sensorInterval = SensorInterval.normalInterval;

  // Use late with nullable to avoid initialization issues
  late AccelerometerSensor? _accelerometerSensor;

  @override
  void initState() {
    super.initState();
    _initAccelerometerSensor();
    _initSensorStreams();
  }

  void _initAccelerometerSensor() {
    _accelerometerSensor = AccelerometerSensor(
      sensorId: 59190,
      samplingPeriod: sensorInterval,
    );
  }

  void _updateSensors() {
    if (_disposed) return;

    // Cancel existing subscriptions
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();

    // Recreate accelerometer sensor with new interval
    _initAccelerometerSensor();

    // Reinitialize sensor streams with new interval
    _initSensorStreams();
  }

  void _initSensorStreams() {
    if (_disposed) return;

    // Set up user accelerometer stream
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          if (_disposed) return;

          final now = event.timestamp;
          if (mounted) {
            setState(() {
              _userAccelerometerEvent = event;
              if (_userAccelerometerUpdateTime != null) {
                final interval = now.difference(_userAccelerometerUpdateTime!);
                if (interval > _ignoreDuration) {
                  _userAccelerometerLastInterval = interval.inMilliseconds;
                }
              }
              _userAccelerometerUpdateTime = now;
            });
          }
        },
        onError: _handleSensorError('User Accelerometer'),
        cancelOnError: false,
      ),
    );

    // Set up gyroscope stream
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          if (_disposed) return;

          final now = event.timestamp;
          if (mounted) {
            setState(() {
              _gyroscopeEvent = event;
              if (_gyroscopeUpdateTime != null) {
                final interval = now.difference(_gyroscopeUpdateTime!);
                if (interval > _ignoreDuration) {
                  _gyroscopeLastInterval = interval.inMilliseconds;
                }
              }
              _gyroscopeUpdateTime = now;
            });
          }
        },
        onError: _handleSensorError('Gyroscope'),
        cancelOnError: false,
      ),
    );

    // Set up magnetometer stream
    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen(
        (MagnetometerEvent event) {
          if (_disposed) return;

          final now = event.timestamp;
          if (mounted) {
            setState(() {
              _magnetometerEvent = event;
              if (_magnetometerUpdateTime != null) {
                final interval = now.difference(_magnetometerUpdateTime!);
                if (interval > _ignoreDuration) {
                  _magnetometerLastInterval = interval.inMilliseconds;
                }
              }
              _magnetometerUpdateTime = now;
            });
          }
        },
        onError: _handleSensorError('Magnetometer'),
        cancelOnError: false,
      ),
    );

    // Set up barometer stream
    _streamSubscriptions.add(
      barometerEventStream(samplingPeriod: sensorInterval).listen(
        (BarometerEvent event) {
          if (_disposed) return;

          final now = event.timestamp;
          if (mounted) {
            setState(() {
              _barometerEvent = event;
              if (_barometerUpdateTime != null) {
                final interval = now.difference(_barometerUpdateTime!);
                if (interval > _ignoreDuration) {
                  _barometerLastInterval = interval.inMilliseconds;
                }
              }
              _barometerUpdateTime = now;
            });
          }
        },
        onError: _handleSensorError('Barometer'),
        cancelOnError: false,
      ),
    );
  }

  void Function(Object) _handleSensorError(String sensorName) {
    return (Object error) {
      if (_disposed || !mounted) return;

      // Show error dialog only if the app is still running
      debugPrint('Error reading $sensorName sensor: $error');
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Sensors Dashboard'),
        elevation: 4,
      ),
      body: MouseRegion(
        // Fix mouse pointer issues by adding proper mouse region
        cursor: SystemMouseCursors.basic,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Use the widget from our accelerometer sensor
              _accelerometerSensor?.widget ?? const SizedBox.shrink(),

              // Rest of the sensor data display
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Other Sensors',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(4),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    const TableRow(
                      children: [
                        SizedBox.shrink(),
                        Text('X'),
                        Text('Y'),
                        Text('Z'),
                        Text('Interval'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('UserAccelerometer'),
                        ),
                        Text(
                          _userAccelerometerEvent?.x.toStringAsFixed(1) ?? '?',
                        ),
                        Text(
                          _userAccelerometerEvent?.y.toStringAsFixed(1) ?? '?',
                        ),
                        Text(
                          _userAccelerometerEvent?.z.toStringAsFixed(1) ?? '?',
                        ),
                        Text(
                          '${_userAccelerometerLastInterval?.toString() ?? '?'} ms',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Gyroscope'),
                        ),
                        Text(_gyroscopeEvent?.x.toStringAsFixed(1) ?? '?'),
                        Text(_gyroscopeEvent?.y.toStringAsFixed(1) ?? '?'),
                        Text(_gyroscopeEvent?.z.toStringAsFixed(1) ?? '?'),
                        Text('${_gyroscopeLastInterval?.toString() ?? '?'} ms'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Magnetometer'),
                        ),
                        Text(_magnetometerEvent?.x.toStringAsFixed(1) ?? '?'),
                        Text(_magnetometerEvent?.y.toStringAsFixed(1) ?? '?'),
                        Text(_magnetometerEvent?.z.toStringAsFixed(1) ?? '?'),
                        Text(
                          '${_magnetometerLastInterval?.toString() ?? '?'} ms',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Barometer section
              if (_barometerEvent != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      const TableRow(
                        children: [
                          SizedBox.shrink(),
                          Text('Pressure'),
                          Text('Interval'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Barometer'),
                          ),
                          Text(
                            '${_barometerEvent?.pressure.toStringAsFixed(1) ?? '?'} hPa',
                          ),
                          Text('${_barometerLastInterval?.toString() ?? '?'} ms'),
                        ],
                      ),
                    ],
                  ),
                ),
              Padding(
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update sensor sampling period
          setState(() {
            sensorInterval = sensorInterval == SensorInterval.normalInterval
                ? SensorInterval.gameInterval
                : SensorInterval.normalInterval;

            _updateSensors();

            // Display a message about the change
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sampling period updated to ${sensorInterval.inMilliseconds}ms',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          });
        },
        tooltip: 'Adjust Sampling Rate',
        child: const Icon(Icons.settings),
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
}
