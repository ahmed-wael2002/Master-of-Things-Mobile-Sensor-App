import 'package:mot_app/model/Sensor.dart';
import 'package:mot_app/model/http_service.dart';
import 'package:mot_app/view/accelerometer_widget.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerSensor extends Sensor {
  // final AccelerometerEvent? accelerometerEvent;

  AccelerometerSensor({
    int sensorId = 59190,
    Duration samplingPeriod = const Duration(milliseconds: 200),
  }) : super(
         name: 'Accelerometer',
         sensorId: sensorId,
         samplingPeriod: samplingPeriod,
         widget: AccelerometerWidget(
           sensorId: sensorId,
           sensorInterval: samplingPeriod,
         ),
       );

  // Method to get the latest accelerometer data
  Stream<AccelerometerEvent> getStream() {
    return accelerometerEventStream(samplingPeriod: samplingPeriod);
  }

  // Future<String> _postReadings() async {
  //   try {
  //     final data = {
  //       "Package": {
  //         "SensorInfo": {"SensorId": sensorId},
  //         "SensorData": {
  //           "captureTime": 10,
  //           "phoneVersion": "Android 13.0",
  //           "appVersion": "1.0.0",
  //           "x": accelerometerEvent?.x ?? 0,
  //           "y": accelerometerEvent?.y ?? 0,
  //           "z": accelerometerEvent?.z ?? 0,
  //         },
  //       },
  //       "Auth": {"DriverManagerId": "1", "DriverManagerPassword": "123"},
  //     };

  //     final response = HttpService().post Request(data);
  //     return response.toString();
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }
}
