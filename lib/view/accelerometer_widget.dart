import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mot_app/common/style.extension.dart';

class AccelerometerWidget extends StatefulWidget {
  const AccelerometerWidget({super.key});

  @override
  State<AccelerometerWidget> createState() => _AccelerometerWidgetState();
}

class _AccelerometerWidgetState extends State<AccelerometerWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Icon(LineAwesome.arrows_alt_h_solid),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("59190", style: context.widgetTitle,),
              Text("Accelerometer", style: context.widgetLabel),
              Table(
                children: [
                  TableRow(
                    children: [
                      // X readings
                      Text('X:', style: context.widgetBodyBold,),
                      Text('_accelX', style: context.widgetBody,),

                      // Y readings
                      Text('Y:', style: context.widgetBodyBold,),
                      Text('_accelY', style: context.widgetBody,),

                      // X readings
                      Text('Z:', style: context.widgetBodyBold,),
                      Text('_accelZ', style: context.widgetBody,),
                    ]
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}