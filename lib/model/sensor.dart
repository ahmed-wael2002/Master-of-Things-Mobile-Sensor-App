abstract class Sensor {
  final String name;
  int sensorId;
  final Duration samplingPeriod;

  Sensor({
    required this.name,
    required this.sensorId,
    required this.samplingPeriod,
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

  void updateSensorId(int sensorId) {
    this.sensorId = sensorId;
  }
}
