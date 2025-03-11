import 'dart:async';
import 'package:icons_plus/icons_plus.dart';
import 'package:mot_app/model/sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GryoscopeSensor extends Sensor {
  GyroscopeEvent? gyroscopeEvent;
  int captureTime = 0;

  GryoscopeSensor({
    super.sensorId = 59190,
    super.samplingPeriod = const Duration(milliseconds: 200),
  }) : super(name: 'Gryoscope', icon: LineAwesome.sync_solid);

  @override
  StreamSubscription getStream() {
    return gyroscopeEventStream(samplingPeriod: samplingPeriod).listen((
      GyroscopeEvent event,
    ) {
      gyroscopeEvent = event;
      captureTime += 10;
    }, 
    cancelOnError: true);
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
            "x": gyroscopeEvent?.x ?? 0,
            "y": gyroscopeEvent?.y ?? 0,
            "z": gyroscopeEvent?.z ?? 0,
          },
        },
        "Auth": {"DriverManagerId": "1", "DriverManagerPassword": "123"},
      };
  }
}
