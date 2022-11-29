import 'package:ctc_rpg_game/messages.dart';
import 'package:ctc_rpg_game/view_models/global_view_model.dart';
import 'package:flutter/material.dart';
import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:provider/provider.dart';

var tooltipText = const TextStyle(color: Colors.black, fontSize: 14);

class DraggableButton extends StatefulWidget {
  const DraggableButton(
      {Key? key,
      required this.msg,
      required this.width,
      required this.height,
      required this.text,
      required this.tooltip,
      required this.backgroundColor})
      : super(key: key);

  final AttackMessage msg;
  final double width, height;
  final String tooltip, text;
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _DraggableButtonState();
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      // Data is the value this Draggable stores.
      data: widget.msg,
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
  OperationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Redrew the operation area");

    return Consumer<GlobalViewModel>(builder: (context, vm, child) {
      var activeEntity = vm.activeEntity;
      var enabled = activeEntity.remainingUses > 0;

      return Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '普通攻击',
                    style: TextStyle(fontSize: 18),
                  )),
              enabled
                  ? DraggableButton(
                      // Target unknown, set as self temporarily
                      msg: AttackMessage(activeEntity, activeEntity, -1),
                      width: 100,
                      height: 60,
                      text: '普攻',
                      tooltip: '攻击伤害: ${activeEntity.normalAttackDamage}',
                      backgroundColor: Colors.blueAccent.shade400,
                    )
                  : TooltipButton(
                      width: 100,
                      height: 60,
                      text: '普攻',
                      tooltip: '攻击伤害: ${activeEntity.normalAttackDamage}',
                      backgroundColor: Colors.grey.shade800),
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "被动技能",
                    style: TextStyle(fontSize: 18),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ...activeEntity.passiveSkillList.map((e) => TooltipButton(
                        width: 100,
                        height: 60,
                        tooltip: e.description,
                        text: e.name,
                        backgroundColor: Colors.blueAccent.shade400,
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
                  ...activeEntity.activeSkillList
                      .asMap()
                      .entries
                      .map((e) => enabled
                          ? DraggableButton(
                              width: 100,
                              height: 60,
                              tooltip: e.value.description,
                              msg: AttackMessage(
                                  activeEntity, activeEntity, e.key),
                              text: e.value.name,
                              backgroundColor: Colors.blueAccent.shade400,
                            )
                          : TooltipButton(
                              width: 100,
                              height: 60,
                              text: e.value.name,
                              tooltip: e.value.description,
                              backgroundColor: Colors.grey.shade800,
                            ))
                ],
              ),
            ]),
          ));
    });
  }
}
