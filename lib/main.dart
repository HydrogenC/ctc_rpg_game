import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/messages.dart';
import 'package:ctc_rpg_game/view_models/global_view_model.dart';
import 'package:ctc_rpg_game/widgets/console_view.dart';
import 'package:ctc_rpg_game/widgets/entity_panel.dart';
import 'package:ctc_rpg_game/widgets/operation_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_logic.dart';

void main() {
  startGameLoop();
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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF212121),
        dividerColor: Colors.black12,
        fontFamily: '黑体',
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ChangeNotifierProvider(
          create: (context) => GlobalViewModel(),
          child: Column(children: [
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
                      child: OperationView(),
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
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GlobalData.singleton.messageOut.add(MoveNextMessage()),
        tooltip: '结束回合',
        child: const Icon(Icons.next_plan_outlined),
      ),
    );
  }
}
