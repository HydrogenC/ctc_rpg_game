import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/buff.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/widgets/operation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

var whiteText = const TextStyle(color: Colors.white, fontSize: 16);
var titleText = const TextStyle(color: Colors.white, fontSize: 18);
var textPadding = const EdgeInsets.fromLTRB(5, 0, 0, 0);

class _EntityViewState extends State<EntityView> {
  EntityState currentState = EntityState.normal;
  static const double imageSize = 80;
  Image? profileImage;

  Future loadImageOrDefault(String path) async {
    AssetImage assetImage;
    try {
      await rootBundle.load(path);
      assetImage = AssetImage(path);
    } catch (_) {
      assetImage = const AssetImage('assets/Default.png');
    }

    profileImage = Image(
      image: assetImage,
      fit: BoxFit.fill,
      height: imageSize,
      width: imageSize,
    );
  }

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

    var message = "";
    List<Widget> nameBarAdditionalWidgets = [];
    List<Widget> weaponBarAdditionalWidgets = [];
    List<Widget> healthBarAdditionalWidgets = [];

    for (var element in widget.entity.buffs) {
      if (element != widget.entity.buffs.first) {
        message += '\n';
      }

      var roundData = element is TemporaryBuff
          ? "剩余${element.remainingRounds()}回合"
          : "武器被动";
      message += "${element.name} ($roundData): \n${element.description}";

      if (element is ICustomEntityDisplay) {
        var casted = element as ICustomEntityDisplay;
        nameBarAdditionalWidgets
            .addAll(casted.getNameBarAdditionalWidgets(widget.entity));
        weaponBarAdditionalWidgets
            .addAll(casted.getWeaponBarAdditionalWidgets(widget.entity));
        healthBarAdditionalWidgets
            .addAll(casted.getHealthBarAdditionalWidgets(widget.entity));
      }
    }

    Widget imageWidget = profileImage ??
        FutureBuilder(
          future: loadImageOrDefault('assets/${widget.entity.name}.jpg'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return profileImage!;
            } else {
              return const SizedBox(
                width: imageSize,
                height: imageSize,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );

    return Tooltip(
        message: message,
        textStyle: tooltipText,
        padding: const EdgeInsets.all(12),
        child: Container(
            padding: const EdgeInsets.all(5.0),
            child: DragTarget<IUsable>(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    imageWidget,
                    ValueListenableBuilder(
                      valueListenable: GlobalData.singleton.operationDone,
                      builder:
                          (BuildContext context, bool value, Widget? child) =>
                              Expanded(
                                  child: Container(
                        height: imageSize,
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.circular(10),
                            )),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: textPadding,
                                          child: Text(widget.entity.name,
                                              style: titleText)),
                                      ...nameBarAdditionalWidgets
                                    ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.architecture,
                                        color: Colors.white, size: 16),
                                    Padding(
                                        padding: textPadding,
                                        child: Text(widget.entity.weapon.name,
                                            style: whiteText)),
                                    ...weaponBarAdditionalWidgets
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.favorite,
                                        color: Colors.white, size: 16),
                                    Padding(
                                      padding: textPadding,
                                      child: Text(
                                          widget.entity.blood.toString(),
                                          style: whiteText),
                                    ),
                                    ...healthBarAdditionalWidgets
                                  ],
                                ),
                              ],
                            )),
                      )),
                    )
                  ],
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
                  data.use(activeEntity, widget.entity);
                  GlobalData.singleton.operationDone.value =
                      !GlobalData.singleton.operationDone.value;

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
            )));
  }
}
