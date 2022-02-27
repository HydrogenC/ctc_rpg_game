import 'package:ctc_rpg_game/entity.dart';
import 'package:flutter/foundation.dart';

class GlobalData {
  GlobalData._internal() {
    friendsAlive = friends.length;
    enemiesAlive = enemies.length;
  }

  List<Entity> friends = [
    Entity("姜哥", 30, 0.8),
    Entity("崔哥", 50, 0.6),
    Entity("金哥", 100, 0.2),
    Entity("翔哥", 200, 0.1),
  ];

  List<Entity> enemies = [
    Entity("袁泉", 400, 0),
  ];

  int activeIndex = 0, remainingAttacks = 1;
  late int friendsAlive, enemiesAlive;

  Entity get activeEntity => friends[activeIndex];
  static GlobalData singleton = GlobalData._internal();
  List<String> messageList = [];

  ValueNotifier<bool> messageAppended = ValueNotifier(false);
  ValueNotifier<bool> operationViewUpdate = ValueNotifier(false);

  void appendMessage(String str) {
    messageAppended.value = !messageAppended.value;
    messageList.add(str);
  }

  void moveNext() {
    if (friendsAlive == 0) {
      return;
    }

    do {
      activeIndex++;
      if (activeIndex >= friends.length) {
        activeIndex = 0;
      }
    } while (friends[activeIndex].blood <= 0);

    operationViewUpdate.value = !operationViewUpdate.value;
  }

  void afterAttack() {
    remainingAttacks--;
    if (remainingAttacks == 0) {
      operationViewUpdate.value = !operationViewUpdate.value;
    }
  }
}
