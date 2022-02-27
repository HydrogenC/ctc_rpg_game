import 'package:flutter/cupertino.dart';
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
      required this.text,
      required this.tooltip,
      required this.backgroundColor})
      : super(key: key);

  final IUsable usable;
  final double width, height;
  final String tooltip, text;
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return Draggable<IUsable>(
      // Data is the value this Draggable stores.
      data: widget.usable,
      child: Tooltip(
        message: widget.tooltip,
        child: Container(
          height: widget.height,
          width: widget.width,
          child: Center(
              child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          )),
          decoration: BoxDecoration(
              color: widget.backgroundColor,
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

class TooltipButton extends StatelessWidget {
  const TooltipButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.text,
      required this.tooltip,
      required this.backgroundColor})
      : super(key: key);

  final double width, height;
  final String tooltip, text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        height: height,
        width: width,
        child: Center(
            child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        )),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      ),
      textStyle: tooltipText,
      padding: const EdgeInsets.all(12),
      preferBelow: false,
    );
  }
}

class OperationView extends StatelessWidget {
  const OperationView({Key? key, required this.enabled}) : super(key: key);

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    debugPrint("Redrew the operation area");
    var activeEntity = GlobalData.singleton.activeEntity;

    return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  activeEntity.weapon.name,
                  style: const TextStyle(fontSize: 18),
                )),
            enabled
                ? DraggableButton(
                    usable: activeEntity.weapon,
                    width: 100,
                    height: 60,
                    text: '普攻',
                    tooltip: '攻击伤害: ${activeEntity.weapon.attackDamage}',
                    backgroundColor: Colors.blueAccent,
                  )
                : TooltipButton(
                    width: 100,
                    height: 60,
                    text: '普攻',
                    tooltip: '攻击伤害: ${activeEntity.weapon.attackDamage}',
                    backgroundColor: Colors.grey),
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "被动技能",
                  style: TextStyle(fontSize: 18),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ...activeEntity.weapon.passiveSkillList
                    .map((e) => TooltipButton(
                          width: 100,
                          height: 60,
                          tooltip: e.description,
                          text: e.name,
                          backgroundColor: Colors.blueAccent,
                        ))
              ],
            ),
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "主动技能",
                  style: TextStyle(fontSize: 18),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ...activeEntity.weapon.activeSkillList.map((e) => enabled
                    ? DraggableButton(
                        width: 100,
                        height: 60,
                        tooltip: e.description,
                        usable: e,
                        text: e.name,
                        backgroundColor: Colors.blueAccent,
                      )
                    : TooltipButton(
                        width: 100,
                        height: 60,
                        text: e.name,
                        tooltip: e.description,
                        backgroundColor: Colors.grey,
                      ))
              ],
            ),
          ]),
        ));
  }
}
