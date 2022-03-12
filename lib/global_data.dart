import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/weapon.dart';
import 'package:flutter/foundation.dart';
import 'active_skill.dart';

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

  int activeIndex = 0, round = 0;
  late int friendsAlive, enemiesAlive;

  Entity get activeEntity => friends[activeIndex];
  static GlobalData singleton = GlobalData._internal();
  List<String> messageList = [];

  ValueNotifier<bool> messageAppended = ValueNotifier(false);
  ValueNotifier<bool> operationDone = ValueNotifier(false);

  void appendMessage(String str) {
    messageAppended.value = !messageAppended.value;
    messageList.add(str);
  }

  void moveNext() {
    if (friendsAlive == 0) {
      return;
    }

    bool newTurnFlag = false;
    do {
      activeIndex++;
      if (activeIndex >= friends.length) {
        newTurnFlag = true;
        activeIndex = 0;
      }
    } while (friends[activeIndex].blood <= 0);

    if (newTurnFlag) {
      round++;
      for (var entity in friends) {
        if (entity.blood > 0) {
          entity.remainingUses = 1;
          for (var element in entity.weapon.passiveSkillList) {
            element.onNewTurn(entity);
          }

          entity.checkBuff();
          for (var element in entity.buffs) {
            element.onNewTurn(entity);
          }
        }
      }
    }

    operationDone.value = !operationDone.value;
  }
}
