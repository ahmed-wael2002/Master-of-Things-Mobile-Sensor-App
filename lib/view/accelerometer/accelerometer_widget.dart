import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mot_app/common/style.extension.dart';
import 'package:mot_app/model/accelerometer_sensor.dart';
import 'package:mot_app/view/accelerometer/accelerometer_bottom_sheet.dart';
import 'package:mot_app/view/sensor_template.dart';

class AccelerometerWidget extends SensorWidgetTemplate {
  final AccelerometerSensor sensor;

  const AccelerometerWidget({super.key, required this.sensor})
    : super(sensor: sensor);

  @override
  State<AccelerometerWidget> createState() => _AccelerometerWidgetState();
}

class _AccelerometerWidgetState
    extends SensorWidgetTemplateState<AccelerometerWidget> {
  @override
  Widget buildReadingsWidget(BuildContext context) {
    return Row(
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
    );
  }

  @override
  Widget buildBottomSheet(BuildContext context) {
    return AccelerometerBottomSheet(sensor: widget.sensor);
  }

  @override
  IconData getSensorIcon() {
    return LineAwesome.arrows_alt_solid;
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
