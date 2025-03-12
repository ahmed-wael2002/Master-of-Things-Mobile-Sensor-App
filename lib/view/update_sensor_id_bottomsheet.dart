import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mot_app/common/style.extension.dart';
import 'package:mot_app/model/Sensor.dart';

class UpdateSensorIdBottomSheet extends StatefulWidget {
  final Sensor sensor;

  const UpdateSensorIdBottomSheet({super.key, required this.sensor});

  @override
  State<UpdateSensorIdBottomSheet> createState() =>
      _UpdateSensorIdBottomSheetState();
}

class _UpdateSensorIdBottomSheetState extends State<UpdateSensorIdBottomSheet> {
  late TextEditingController _sensorIdController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _sensorIdController = TextEditingController(
      text: widget.sensor.sensorId.toString(),
    );
  }

  @override
  void dispose() {
    _sensorIdController.dispose();
    super.dispose();
  }

  void _updateSensorId() {
    final newIdText = _sensorIdController.text.trim();
    if (newIdText.isEmpty) {
      setState(() {
        _errorText = 'Sensor ID cannot be empty';
      });
      return;
    }

    try {
      final newId = int.parse(newIdText);
      widget.sensor.updateSensorId(newId);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorText = 'Please enter a valid integer';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sensor ID: ${widget.sensor.sensorId}',
            style: context.widgetTitle,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _sensorIdController,
            decoration: InputDecoration(
              labelText: 'Enter new Sensor ID',
              errorText: _errorText,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: true,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _updateSensorId,
                child: const Text('Update'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
