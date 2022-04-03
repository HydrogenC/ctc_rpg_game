import 'package:flutter/material.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/widgets/entity_view.dart';

class EntityPanel extends StatelessWidget {
  EntityPanel({Key? key, required this.title, required this.entityList})
      : super(key: key);

  final List<Entity> entityList;
  final String title;
  final ScrollController _scrollController = ScrollController();

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
            Expanded(
                child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [...entityList.map((e) => EntityView(entity: e))],
                ),
              ),
            )),
          ],
        ));
  }
}
