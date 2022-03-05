import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:flutter/material.dart';
import '../entity.dart';

enum EntityState {
  normal,
  highlighted,
  dead,
  operating,
}

class EntityView extends StatefulWidget {
  const EntityView({Key? key, required this.entity}) : super(key: key);

  final Entity entity;

  @override
  State<EntityView> createState() => _EntityViewState();
}

class _EntityViewState extends State<EntityView> {
  EntityState currentState = EntityState.normal;

  @override
  Widget build(BuildContext context) {
    Entity activeEntity = GlobalData.singleton.activeEntity;

    if (widget.entity.blood > 0) {
      if (widget.entity == activeEntity) {
        currentState = EntityState.operating;
      } else if (currentState == EntityState.operating) {
        currentState = EntityState.normal;
      }
    }

    var whiteText = const TextStyle(color: Colors.white, fontSize: 18);
    late Color bgColor;
    switch (currentState) {
      case EntityState.normal:
        bgColor = Colors.blueAccent;
        break;
      case EntityState.highlighted:
        bgColor = Colors.lightBlue.shade100;
        break;
      case EntityState.dead:
        bgColor = Colors.grey;
        break;
      case EntityState.operating:
        bgColor = Colors.red.shade800;
        break;
    }

    return Container(
        padding: const EdgeInsets.all(5.0),
        child: DragTarget<IUsable>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(widget.entity.name, style: whiteText),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite, color: Colors.white),
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 50,
                        child: ValueListenableBuilder(
                            valueListenable: GlobalData.singleton.bloodChanged,
                            builder: (BuildContext context, bool value,
                                    Widget? child) =>
                                Text(widget.entity.blood.toString(),
                                    style: whiteText)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.architecture, color: Colors.white),
                      Container(
                          padding: const EdgeInsets.all(5),
                          width: 100,
                          child: Text(widget.entity.weapon.name,
                              style: whiteText)),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: bgColor, borderRadius: BorderRadius.circular(10)),
            );
          },
          onWillAccept: (data) {
            if (widget.entity.blood > 0) {
              setState(() {
                currentState = EntityState.highlighted;
              });
            }
            return widget.entity.blood > 0;
          },
          onAccept: (data) {
            setState(() {
              GlobalData.singleton.use(activeEntity, widget.entity, data);
              activeEntity.remainingUses--;
              if (activeEntity.remainingUses == 0) {
                GlobalData.singleton.playerUsed.value =
                    !GlobalData.singleton.playerUsed.value;
              }

              currentState = widget.entity.blood == 0
                  ? EntityState.dead
                  : EntityState.normal;
            });
          },
          onLeave: (data) {
            if (widget.entity.blood > 0) {
              setState(() {
                currentState = EntityState.normal;
              });
            }
          },
        ));
  }
}
