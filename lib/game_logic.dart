import 'package:ctc_rpg_game/global_data.dart';

import 'messages/property_change_message.dart';

Future<void> startGameLoop() async {
  await Future.delayed(const Duration(seconds: 2));
  var messageQueue = GlobalData.singleton.messageOut;

  messageQueue.add(PropertyChangeMessage(
      GlobalData.singleton.friends[0], {"hp": 8848, "use": 3}));
}
