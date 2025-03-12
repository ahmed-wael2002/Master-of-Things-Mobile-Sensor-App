import 'package:flutter/material.dart';
import 'package:mot_app/common/style.extension.dart';
import 'package:mot_app/model/gyroscope_sensor.dart';
import 'package:mot_app/view/sensor_template.dart';

class GyroscopeWidget extends SensorWidgetTemplate {
  @override
  // ignore: overridden_fields
  final GyroscopeSensor sensor;
  const GyroscopeWidget({super.key, required this.sensor})
    : super(sensor: sensor);

  @override
  State<GyroscopeWidget> createState() => _GyroscopeWidgetState();
}

class _GyroscopeWidgetState extends SensorWidgetTemplateState<GyroscopeWidget> {

  @override
  Widget buildReadingsWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAxisDisplay("X", widget.sensor.gyroscopeEvent?.x ?? 0, context),
        _buildAxisDisplay("Y", widget.sensor.gyroscopeEvent?.y ?? 0, context),
        _buildAxisDisplay("Z", widget.sensor.gyroscopeEvent?.z ?? 0, context),
        _buildInterval(widget.sensor.samplingPeriod.inMilliseconds.toDouble(), context)
      ],
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
