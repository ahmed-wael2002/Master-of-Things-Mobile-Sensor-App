import 'package:flutter/material.dart';
import 'package:mot_app/common/style.extension.dart';
import 'package:mot_app/model/Sensor.dart';

@Deprecated('Use SensorTemplate instead')

class SensorCard extends StatefulWidget {
  final Sensor sensor;
  final Widget readingsWidget;
  final Widget bottomSheetWidget;
  final IconData icon;

  const SensorCard({
    super.key,
    required this.sensor,
    required this.readingsWidget,
    required this.bottomSheetWidget,
    required this.icon,
  });

  @override
  State<SensorCard> createState() => _SensorCardState();
}

@Deprecated('Use SensorTemplateState instead')
class _SensorCardState extends State<SensorCard> {
  void _showEditSensorBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // builder: (context) => AccelerometerBottomSheet(sensor: widget.sensor),
      // TODO: Generalize Bottom Sheet and pass parent widget
      builder: (context) => widget.bottomSheetWidget,
    ).then((_) {
      // Refresh the widget when bottom sheet is closed
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showEditSensorBottomSheet,
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 2,
        child: Container(
          width: double.infinity,
          padding: context.cardPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Widget icon illustrating the sensor used
              Icon(
                widget.icon,
                size: context.iconSize,
              ), // Using the icon from the sensor with appropriate color
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
                    widget.readingsWidget,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
