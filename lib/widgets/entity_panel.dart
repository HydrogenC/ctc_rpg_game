import 'package:flutter/material.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/widgets/entity_view.dart';

class EntityPanel extends StatelessWidget {
  const EntityPanel(
      {Key? key,
        required this.title,
        required this.entityList})
      : super(key: key);

  final List<Entity> entityList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
              child: Center(
                child: Text(title, style: const TextStyle(fontSize: 24)),
              ),
            ),
            ...entityList.map((e) => EntityView(entity: e)),
          ],
        ));
  }
}