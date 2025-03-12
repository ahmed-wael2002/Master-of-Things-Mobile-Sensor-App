import 'package:flutter/material.dart';
import 'package:mot_app/common/style.extension.dart';
import 'package:mot_app/model/light_sensor.dart';
import 'package:mot_app/view/sensor_template.dart';
import 'package:mot_app/view/update_sensor_id_bottomsheet.dart';

class LightWidget extends SensorWidgetTemplate {
  @override
  final LightLuxSensor sensor;

  const LightWidget({super.key, required this.sensor}) : super(sensor: sensor);

  @override
  State<LightWidget> createState() => _LightWidgetState();
}

class _LightWidgetState extends SensorWidgetTemplateState<LightWidget> {
  @override
  Widget buildBottomSheet(BuildContext context) {
    // return AccelerometerBottomSheet(sensor: );
    return UpdateSensorIdBottomSheet(sensor: widget.sensor,);
  }

  @override
  Widget buildReadingsWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Lux: ', style: context.widgetBodyBold),
        const SizedBox(width: 13.0),
        Text(
          widget.sensor.currentLuxValue.toString(),
          style: context.widgetBody,
        ),
      ],
    );
  }
}
