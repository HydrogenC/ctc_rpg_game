import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/view_models/entity_view_model.dart';
import 'package:ctc_rpg_game/widgets/operation_view.dart';
import 'package:ctc_rpg_game/widgets/property_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  Stream<dynamic>? propertyMessageStream;

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

    Entity activeEntity = GlobalData.singleton.activeEntity;
    if (widget.entity.hp > 0) {
      if (widget.entity == activeEntity) {
        currentState = EntityState.operating;
      } else if (currentState == EntityState.operating) {
        currentState = EntityState.normal;
      }
    }

    late Color bgColor;
    switch (currentState) {
      case EntityState.normal:
        bgColor = const Color(0xFF161616);
        break;
      case EntityState.highlighted:
        bgColor = Colors.lightBlue.shade100;
        break;
      case EntityState.dead:
        bgColor = Colors.grey;
        break;
      case EntityState.operating:
        bgColor = Colors.blueAccent.shade400;
        break;
    }

    var message = "";

    for (var element in widget.entity.buffs) {
      if (element != widget.entity.buffs.first) {
        message += '\n';
      }

      message +=
          "${element.name} (${element.buffType.getTypeName()}): \n${element.description}";
    }

    return ChangeNotifierProvider(
        create: (context) => EntityViewModel.fromEntity(widget.entity),
        child: Tooltip(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding: textPadding,
                                              child: Text(widget.entity.name,
                                                  style: titleText)),
                                        ]),
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      alignment: WrapAlignment.center,
                                      children: const [
                                        PropertyDisplay(
                                            propertyName: 'hp',
                                            icon: Icons.favorite,
                                            enabledByDefault: true),
                                        PropertyDisplay(
                                            propertyName: 'uses',
                                            icon: Icons.beenhere_rounded,
                                            enabledByDefault: true)
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                  onWillAccept: (data) {
                    if (widget.entity.hp > 0) {
                      setState(() {
                        currentState = EntityState.highlighted;
                      });
                    }
                    return widget.entity.hp > 0;
                  },
                  onAccept: (data) {
                    setState(() {
                      data.use(activeEntity, widget.entity);
                      GlobalData.singleton.operationDone.value =
                          !GlobalData.singleton.operationDone.value;

                      currentState = widget.entity.hp == 0
                          ? EntityState.dead
                          : EntityState.normal;
                    });
                  },
                  onLeave: (data) {
                    if (widget.entity.hp > 0) {
                      setState(() {
                        currentState = EntityState.normal;
                      });
                    }
                  },
                ))));
  }
}
