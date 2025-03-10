import 'dart:async';

import 'package:mot_app/model/Sensor.dart';
import 'package:mot_app/model/http_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerSensor extends Sensor {
  AccelerometerEvent? accelerometerEvent;
  int captureTime = 0;

  AccelerometerSensor({
    super.sensorId = 59190,
    super.samplingPeriod = const Duration(milliseconds: 200),
  }) : super(
         name: 'Accelerometer',
       );

  // Method to get the latest accelerometer data
  StreamSubscription<AccelerometerEvent> getStream() {
    return accelerometerEventStream(samplingPeriod: samplingPeriod).listen((
      AccelerometerEvent event,
    ) {
      accelerometerEvent = event;
      captureTime += 10;
      _postReadings();
    });
  }

  Future<String> _postReadings() async {
    try {
      final data = {
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

      final response = HttpService().postRequest(data);
      return response.toString();
      
    } catch (e) {
      return e.toString();
    }
  }

  // accelerometerEventStream(samplingPeriod: widget.sensorInterval).listen(
  //       (AccelerometerEvent event) {
  //         if (_disposed) return;

  //         final now = event.timestamp;
  //         if (mounted) {
  //           setState(() {
  //             _accelerometerEvent = event;
  //             if (_accelerometerUpdateTime != null) {
  //               final interval = now.difference(_accelerometerUpdateTime!);
  //               if (interval > _ignoreDuration) {
  //                 _accelerometerLastInterval = interval.inMilliseconds;
  //               }
  //             }
  //           });
  //           _accelerometerUpdateTime = now;
  //         }
  //       },
  //       onError: (e) {
  //         if (_disposed || !mounted) return;

  //         debugPrint('Error reading accelerometer: $e');
  //       },
  //       cancelOnError: false,
  //     ),
}
