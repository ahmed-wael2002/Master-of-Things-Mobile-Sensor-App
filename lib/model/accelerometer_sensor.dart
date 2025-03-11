import 'dart:async';
import 'package:icons_plus/icons_plus.dart';
import 'package:mot_app/model/Sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerSensor extends Sensor {
  // Attributes
  AccelerometerEvent? accelerometerEvent;
  int captureTime = 0;

  // Constructor
  AccelerometerSensor({
    super.sensorId = 59190,
    super.samplingPeriod = const Duration(milliseconds: 200),
  }) : super(
    name: 'Accelerometer',
    icon:LineAwesome.arrows_alt_solid,
  );

  // Method to return the getStream for streamSubscriptions in the main.dart
  @override
  StreamSubscription<AccelerometerEvent> getStream() {
    return accelerometerEventStream(samplingPeriod: samplingPeriod).listen((
      AccelerometerEvent event,
    ) {
      accelerometerEvent = event;
      captureTime += 10;
      // Handle the Future properly or comment out if not needed
      // Use unawaited or simply don't await as this is in a callback
      postReadings().then((_) {}).catchError((error) {
        print('Error posting readings: $error');
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
          "x": accelerometerEvent?.x ?? 0,
          "y": accelerometerEvent?.y ?? 0,
          "z": accelerometerEvent?.z ?? 0,
        },
      },
      "Auth": {"DriverManagerId": "1", "DriverManagerPassword": "123"},
    };
  }
}
