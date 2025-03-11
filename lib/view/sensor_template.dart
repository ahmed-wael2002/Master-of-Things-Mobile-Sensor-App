import 'package:flutter/material.dart';
import 'package:mot_app/common/style.extension.dart';
import 'package:mot_app/model/Sensor.dart';

/// A template class for sensor widgets using the Template Design Pattern
abstract class SensorWidgetTemplate extends StatefulWidget {
  final Sensor sensor;

  const SensorWidgetTemplate({super.key, required this.sensor});
}

abstract class SensorWidgetTemplateState<T extends SensorWidgetTemplate>
    extends State<T> {
  // Abstract methods to be implemented by concrete sensor widgets
  Widget buildReadingsWidget(BuildContext context);
  Widget buildBottomSheet(BuildContext context);
  IconData getSensorIcon();

  void _showEditSensorBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => buildBottomSheet(context),
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
              Icon(getSensorIcon(), size: context.iconSize),
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
                    buildReadingsWidget(context),
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
