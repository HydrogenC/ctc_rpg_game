import 'dart:isolate';

import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/widgets/console_view.dart';
import 'package:ctc_rpg_game/widgets/entity_panel.dart';
import 'package:ctc_rpg_game/widgets/operation_view.dart';
import 'package:flutter/material.dart';

void main() async {
  await GlobalData.singleton.startGameLoop();
  GlobalData.singleton.turnStart();

  runApp(const MyApp());
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void moveNext() {
    GlobalData.singleton.moveNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        Expanded(
            flex: 7,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: EntityPanel(
                      title: "友方单位",
                      entityList: GlobalData.singleton.friends,
                    )),
                Expanded(
                  flex: 4,
                  child: ValueListenableBuilder(
                      valueListenable: GlobalData.singleton.operationDone,
                      builder:
                          (BuildContext context, bool value, Widget? child) =>
                              OperationView(
                                  enabled: GlobalData.singleton.activeEntity
                                          .remainingUses !=
                                      0)),
                ),
                Expanded(
                    flex: 3,
                    child: EntityPanel(
                      title: "敌方单位",
                      entityList: GlobalData.singleton.enemies,
                    )),
              ],
            )),
        Expanded(
            flex: 3,
            child: Container(
              child: Scrollbar(
                  child: ValueListenableBuilder(
                valueListenable: GlobalData.singleton.messageAppended,
                builder: (BuildContext context, bool b, Widget? child) =>
                    ConsoleView(),
              )),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.indigo.shade800),
            )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: moveNext,
        tooltip: '结束回合',
        child: const Icon(Icons.next_plan_outlined),
      ),
    );
  }
}
