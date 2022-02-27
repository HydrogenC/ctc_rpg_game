import 'package:ctc_rpg_game/global_data.dart';
import 'package:flutter/material.dart';

class ConsoleView extends StatelessWidget {
  ConsoleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: GlobalData.singleton.messageList.length,
        itemBuilder: (context, index) => Text(
              GlobalData.singleton.messageList[
                  GlobalData.singleton.messageList.length - 1 - index],
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ));
  }
}
