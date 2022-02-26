import 'package:flutter/material.dart';
import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/global_data.dart';

var tooltipText = const TextStyle(color: Colors.white, fontSize: 14);

class DraggableButton extends StatefulWidget {
  const DraggableButton(
      {Key? key,
      required this.usable,
      required this.width,
      required this.height,
      required this.tooltip})
      : super(key: key);

  final IUsable usable;
  final double width, height;
  final String tooltip;

  @override
  State<StatefulWidget> createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      // Data is the value this Draggable stores.
      data: 'red',
      child: Tooltip(
        message: widget.tooltip,
        child: Container(
          height: widget.height,
          width: widget.width,
          child: const Center(
              child: Text(
            '普攻',
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10)),
        ),
        textStyle: tooltipText,
        padding: const EdgeInsets.all(12),
        preferBelow: false,
      ),
      feedback: SizedBox(
          height: widget.height,
          width: widget.width,
          child: const Center(
              child: Icon(
            Icons.adjust,
            size: 40,
            color: Colors.red,
          ))),
    );
  }
}

class OperationView extends StatelessWidget {
  const OperationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var activeEntity = GlobalData.singleton.activeEntity;

    return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "普通攻击",
                  style: TextStyle(fontSize: 18),
                )),
            DraggableButton(
              usable: activeEntity.weapon,
              width: 100,
              height: 60,
              tooltip:
                  '普攻武器: ${activeEntity.weapon.name}\n攻击伤害: ${activeEntity.weapon.attackDamage}',
            ),
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "被动技能",
                  style: TextStyle(fontSize: 18),
                )),
            DraggableButton(
              usable: activeEntity.weapon,
              width: 100,
              height: 60,
              tooltip: '普通攻击',
            ),
          ]),
        ));
  }
}
