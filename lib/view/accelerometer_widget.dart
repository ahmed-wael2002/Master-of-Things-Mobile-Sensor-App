import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mot_app/common/style.extension.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:mot_app/model/http_service.dart';

class AccelerometerWidget extends StatefulWidget {
  final Duration sensorInterval;
  final int sensorId;

  const AccelerometerWidget({
    super.key,
    this.sensorInterval = const Duration(milliseconds: 200),
    this.sensorId = 59190,
  });

  @override
  State<AccelerometerWidget> createState() => _AccelerometerWidgetState();
}

class _AccelerometerWidgetState extends State<AccelerometerWidget> {
  AccelerometerEvent? _accelerometerEvent;
  DateTime? _accelerometerUpdateTime;
  int? _accelerometerLastInterval;
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  static int captureTime = 10;
  bool _isSending = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _startAccelerometerStream();
  }

  @override
  void didUpdateWidget(AccelerometerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If interval changed, restart the stream
    if (oldWidget.sensorInterval != widget.sensorInterval) {
      _resetAccelerometerStream();
    }
  }

  void _resetAccelerometerStream() {
    if (_disposed) return;

    // Cancel existing subscriptions
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();

    // Start new stream with updated interval
    _startAccelerometerStream();
  }

  void _startAccelerometerStream() {
    if (_disposed) return;

    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: widget.sensorInterval).listen(
        (AccelerometerEvent event) {
          if (_disposed) return;

          final now = event.timestamp;
          if (mounted) {
            setState(() {
              _accelerometerEvent = event;
              if (_accelerometerUpdateTime != null) {
                final interval = now.difference(_accelerometerUpdateTime!);
                if (interval > _ignoreDuration) {
                  _accelerometerLastInterval = interval.inMilliseconds;
                }
              }
            });
            _accelerometerUpdateTime = now;
          }
        },
        onError: (e) {
          if (_disposed || !mounted) return;

          debugPrint('Error reading accelerometer: $e');
        },
        cancelOnError: false,
      ),
    );
  }

  Future<String> _postToMOT() async {
    if (_disposed) return "Widget disposed";

    setState(() {
      _isSending = true;
    });

    try {
      captureTime += 10;

      final data = {
        "Package": {
          "SensorInfo": {"SensorId": widget.sensorId},
          "SensorData": {
            "captureTime": captureTime,
            "phoneVersion": "Android 13.0",
            "appVersion": "1.0.0",
            "x": _accelerometerEvent?.x ?? 0,
            "y": _accelerometerEvent?.y ?? 0,
            "z": _accelerometerEvent?.z ?? 0,
          },
        },
        "Auth": {"DriverManagerId": "1", "DriverManagerPassword": "123"},
      };

      final response = await HttpService().postRequest(data);

      if (!_disposed && mounted) {
        setState(() {
          _isSending = false;
        });
      }

      return response.toString();
    } catch (e) {
      if (!_disposed && mounted) {
        setState(() {
          _isSending = false;
        });
      }
      return "Error: ${e.toString()}";
    }
  }

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
                    Text("Accelerometer", style: context.widgetTitle),
                    Text(
                      "Sensor ID: ${widget.sensorId}",
                      style: context.widgetLabel,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAxisDisplay(
                          'X',
                          _accelerometerEvent?.x ?? 0,
                          context,
                        ),
                        _buildAxisDisplay(
                          'Y',
                          _accelerometerEvent?.y ?? 0,
                          context,
                        ),
                        _buildAxisDisplay(
                          'Z',
                          _accelerometerEvent?.z ?? 0,
                          context,
                        ),
                        _buildInterval(
                          _accelerometerLastInterval?.toDouble() ?? 0,
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

  @override
  void dispose() {
    _disposed = true;
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
    super.dispose();
  }
}
