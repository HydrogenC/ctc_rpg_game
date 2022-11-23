import 'package:ctc_rpg_game/messages/property_change_message.dart';
import 'package:flutter/material.dart';

class PropertyDisplay extends StatefulWidget {
  const PropertyDisplay(
      {Key? key,
      required this.stream,
      required this.propertyName,
      required this.icon,
      required this.enabledByDefault})
      : super(key: key);

  final Stream<dynamic> stream;
  final IconData icon;
  final String propertyName;
  final bool enabledByDefault;

  @override
  State<PropertyDisplay> createState() => _PropertyDisplayState();
}

class _PropertyDisplayState extends State<PropertyDisplay> {
  int maxValue = -1;
  int currentValue = 0;
  bool? enabled;

  var textPadding = const EdgeInsets.fromLTRB(5, 0, 0, 0);
  var whiteText = const TextStyle(color: Colors.white, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    enabled ??= widget.enabledByDefault;

    return StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var info = snapshot.data as PropertyChangeMessage;
            if (info.properties.containsKey(widget.propertyName)) {
              currentValue = info.properties[widget.propertyName]!;
            }

            var maxValueKey = "max_${widget.propertyName}";
            if (info.properties.containsKey(maxValueKey)) {
              maxValue = info.properties[maxValueKey]!;
              enabled = maxValue != -1;
            }
          }

          return (enabled!)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: Colors.white, size: 16),
                    Padding(
                      padding: textPadding,
                      child: Text("$currentValue/$maxValue", style: whiteText),
                    ),
                  ],
                )
              : const SizedBox.shrink();
        });
  }
}
