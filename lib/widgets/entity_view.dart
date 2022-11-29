import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/view_models/entity_view_model.dart';
import 'package:ctc_rpg_game/widgets/operation_view.dart';
import 'package:ctc_rpg_game/widgets/property_display.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/view_models/global_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  static const double imageSize = 80;
  Image? profileImage;
  Stream<dynamic>? propertyMessageStream;
  bool highlighted = false;

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
                          child: Consumer<GlobalViewModel>(
                              builder: (context, vm, child) {
                            late Color bgColor;
                            if (highlighted) {
                              bgColor = Colors.lightBlue.shade100;
                            } else {
                              if (widget.entity.hp == 0) {
                                bgColor = Colors.grey.shade700;
                              } else if (vm.activeEntity == widget.entity) {
                                bgColor = Colors.blueAccent.shade400;
                              } else {
                                bgColor = const Color(0xFF161616);
                              }
                            }

                            return Container(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              enabledByDefault: true),
                                          PropertyDisplay(
                                              propertyName: 'shield',
                                              icon: Icons.shield,
                                              enabledByDefault: false)
                                        ],
                                      ),
                                    ],
                                  )),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                  onWillAccept: (data) {
                    if (widget.entity.hp > 0) {
                      setState(() {
                        highlighted = true;
                      });
                    }
                    return widget.entity.hp > 0;
                  },
                  onAccept: (data) {
                    setState(() {});
                  },
                  onLeave: (data) {
                    setState(() {
                      highlighted = false;
                    });
                  },
                ))));
  }
}
