import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mot_app/common/style.extension.dart';
import 'package:mot_app/model/accelerometer_sensor.dart';

class AccelerometerWidget extends StatefulWidget {
  final AccelerometerSensor sensor;

  const AccelerometerWidget({
    super.key,
    required this.sensor
  });

  @override
  State<AccelerometerWidget> createState() => _AccelerometerWidgetState();
}

class _AccelerometerWidgetState extends State<AccelerometerWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: Container(
          width: double.infinity,
          padding: context.cardPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(LineAwesome.arrows_alt_solid, size: context.iconSize),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.sensor.name, style: context.widgetTitle),
                    Text(
                      "Sensor ID: ${widget.sensor.sensorId}",
                      style: context.widgetLabel,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAxisDisplay(
                          'X',
                          widget.sensor.accelerometerEvent?.x ?? 0,
                          context,
                        ),
                        _buildAxisDisplay(
                          'Y',
                          widget.sensor.accelerometerEvent?.y ?? 0,
                          context,
                        ),
                        _buildAxisDisplay(
                          'Z',
                          widget.sensor.accelerometerEvent?.z ?? 0,
                          context,
                        ),
                        _buildInterval(
                          widget.sensor.samplingPeriod.inMilliseconds.toDouble(),
                          context,
                        ),
                      ],
                    ),
                    // Commented out send button section
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAxisDisplay(String axis, double value, BuildContext context) {
    return Row(
      children: [
        Text('$axis:', style: context.widgetBodyBold),
        const SizedBox(width: 4),
        Text(value.toStringAsFixed(2), style: context.widgetBody),
      ],
    );
  }

  Widget _buildInterval(double value, BuildContext context) {
    return Row(
      children: [
        Text('Interval:', style: context.widgetBodyBold),
        const SizedBox(width: 4),
        Text('${value.toStringAsFixed(0)} ms', style: context.widgetBody),
      ],
    );
  }


}
