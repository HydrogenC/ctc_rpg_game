import 'package:ctc_rpg_game/weapon_defs.dart';
import 'package:flutter/material.dart';
import 'basics.dart';
import 'entity.dart';

void main() {
  friends[0].weapon = weapons['tomb']!;
  friends[1].weapon = weapons['boss']!;
  runApp(const MyApp());
}

void showSnackBar(BuildContext context, String msg) {
  var snackBar =
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2));
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

List<Entity> friends = [
  Entity("姜哥", 30, 0.8),
  Entity("崔哥", 50, 0.6),
  Entity("金哥", 100, 0.2),
  Entity("翔哥", 200, 0.1),
];

List<Entity> enemies = [
  Entity("袁泉", 50, 0),
];

Widget buildEntityPanel({bool friend = true}) {
  return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Center(
              child: Text(friend ? "友方单位" : "敌方单位",
                  style: const TextStyle(fontSize: 24)),
            ),
          ),
          ...(friend ? friends : enemies).map((e) => EntityView(entity: e)),
        ],
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: '黑体'),
      home: const MyHomePage(title: '崔哥 RPG 模拟器'),
    );
  }
}

class EntityView extends StatefulWidget {
  const EntityView({Key? key, required this.entity}) : super(key: key);

  final Entity entity;

  @override
  State<EntityView> createState() => _EntityViewState();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class DraggableButton extends StatefulWidget {
  const DraggableButton({Key? key, required this.usable}) : super(key: key);

  final IUsable usable;

  @override
  State<StatefulWidget> createState() => _DraggableButtonState();
}

enum EntityState {
  normal,
  highlighted,
  dead,
  operating,
}

class _DraggableButtonState extends State<DraggableButton> {
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      // Data is the value this Draggable stores.
      data: 'red',
      child: Container(
        height: 100,
        width: 100,
        child: const Center(
            child: Text(
          '普攻',
          style: TextStyle(color: Colors.white, fontSize: 18),
        )),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
      ),
      feedback: const SizedBox(
          height: 100,
          width: 100,
          child: Center(
              child: Icon(
            Icons.adjust,
            size: 40,
            color: Colors.red,
          ))),
    );
  }
}

class _EntityViewState extends State<EntityView> {
  EntityState currentState = EntityState.normal;

  @override
  Widget build(BuildContext context) {
    var activeEntity =
        context.findAncestorStateOfType<_MyHomePageState>()!.activeEntity;

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
        child: DragTarget<String>(builder: (
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
                      width: 40,
                      child: Center(
                          child: Text(widget.entity.blood.toString(),
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
                        child: Center(
                          child:
                              Text(widget.entity.weapon.name, style: whiteText),
                        )),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(10)),
          );
        }, onWillAccept: (data) {
          if (widget.entity.blood > 0) {
            setState(() {
              currentState = EntityState.highlighted;
            });
          }
          return widget.entity.blood > 0;
        }, onAccept: (data) {
          setState(() {
            int damage = activeEntity.weapon.use(activeEntity, widget.entity);
            currentState = widget.entity.blood == 0
                ? EntityState.dead
                : EntityState.normal;
            showSnackBar(context, "${widget.entity.name} 受到 $damage 点伤害");
          });
        }));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int activeIndex = 0;
  Entity activeEntity = friends[0];
  Widget? operationArea;

  void moveNext() {
    setState(() {
      do {
        activeIndex++;
        if (activeIndex >= friends.length) {
          activeIndex = 0;
        }
      } while (friends[activeIndex].blood <= 0);
      activeEntity = friends[activeIndex];
    });
  }

  void redraw() {}

  void regenerateOperationArea() {
    operationArea = Expanded(
      flex: 4,
      child: Center(child: DraggableButton(usable: activeEntity.weapon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (operationArea == null) {
      regenerateOperationArea();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: <Widget>[
          Expanded(flex: 3, child: buildEntityPanel(friend: true)),
          operationArea!,
          Expanded(flex: 3, child: buildEntityPanel(friend: false)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: moveNext,
        tooltip: '结束回合',
        child: const Icon(Icons.next_plan_outlined),
      ),
    );
  }
}
