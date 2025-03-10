import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mot_app/model/accelerometer_sensor.dart';
import 'package:mot_app/view/accelerometer_widget.dart';
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

  // gyroscope sensor parameters
  GyroscopeEvent? _gyroscopeEvent;
  DateTime? _gyroscopeUpdateTime;
  int? _gyroscopeLastInterval;
  bool _disposed = false;
  Duration sensorInterval = SensorInterval.normalInterval;

  // Use late with nullable to avoid initialization issues
  late AccelerometerSensor _accelerometerSensor;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

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
    _streamSubscriptions.add(_accelerometerSensor.getStream());
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
              AccelerometerWidget(sensor: _accelerometerSensor),

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
