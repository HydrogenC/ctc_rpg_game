import 'package:ctc_rpg_game/entity.dart';
import 'package:flutter/foundation.dart';

class GlobalData {
  GlobalData._internal() {
    friendsAlive = friends.length;
    enemiesAlive = enemies.length;
  }

  List<Entity> friends = [
    Entity("玩家1", 30, 0.8),
    Entity("玩家2", 50, 0.6),
    Entity("玩家3", 100, 0.2),
    Entity("玩家4", 200, 0.1),
  ];

  List<Entity> enemies = [
    Entity("敌人1", 50, 0),
  ];

  int remainingAttacks = 1;
  late int friendsAlive, enemiesAlive;

  Entity get activeEntity => friends[activeEntityChanged.value];
  static GlobalData singleton = GlobalData._internal();
  List<String> messageList = [];

  ValueNotifier<bool> messageAppended = ValueNotifier(false);
  late ValueNotifier<int> activeEntityChanged = ValueNotifier(0);

  void appendMessage(String str) {
    messageAppended.value = !messageAppended.value;
    messageList.add(str);
  }

  void moveNext() {
    if (friendsAlive == 0) {
      return;
    }

    do {
      activeEntityChanged.value += 1;
      if (activeEntityChanged.value >= friends.length) {
        activeEntityChanged.value = 0;
      }
    } while (friends[activeEntityChanged.value].blood <= 0);
  }
}
