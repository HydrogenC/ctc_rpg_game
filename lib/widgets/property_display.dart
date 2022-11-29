import 'package:ctc_rpg_game/view_models/entity_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertyDisplay extends StatefulWidget {
  const PropertyDisplay(
      {Key? key,
      required this.propertyName,
      required this.icon,
      required this.enabledByDefault})
      : super(key: key);

  final IconData icon;
  final String propertyName;
  final bool enabledByDefault;

  @override
  State<PropertyDisplay> createState() => _PropertyDisplayState();
}

class _PropertyDisplayState extends State<PropertyDisplay> {
  bool? enabled;

  var textPadding = const EdgeInsets.fromLTRB(5, 0, 0, 0);
  var whiteText = const TextStyle(color: Colors.white, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    enabled ??= widget.enabledByDefault;

    return Consumer<EntityViewModel>(builder: (context, vm, child) {
      var key = widget.propertyName;
      enabled = vm.properties.containsKey(key) && vm.properties[key] != -1;

      return (enabled!)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.white, size: 16),
                Padding(
                  padding: textPadding,
                  child: Text(vm.properties[key].toString(), style: whiteText),
                ),
              ],
            )
          : const SizedBox.shrink();
    });
  }
}
