import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/skill.dart';
import 'package:ctc_rpg_game/weapon.dart';
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

  int activeIndex = 0;
  late int friendsAlive, enemiesAlive;

  Entity get activeEntity => friends[activeIndex];
  static GlobalData singleton = GlobalData._internal();
  List<String> messageList = [];

  ValueNotifier<bool> messageAppended = ValueNotifier(false);
  ValueNotifier<bool> playerUsed = ValueNotifier(false);
  ValueNotifier<bool> bloodChanged = ValueNotifier(false);

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
      for (var entity in friends) {
        if (entity.blood > 0) {
          entity.remainingUses = 1;
          for (var element in entity.weapon.passiveSkillList) {
            element.onNewTurn(entity);
          }
        }
      }
    }

    playerUsed.value = !playerUsed.value;
  }

  void use(Entity user, Entity target, IUsable usable) {
    int actualDamage = usable.use(user, target);
    if (usable is ActiveSkill) {
      for (var element in user.weapon.passiveSkillList) {
        element.afterActiveSkill(user, target, actualDamage, usable);
      }
    } else if (usable is Weapon) {
      for (var element in user.weapon.passiveSkillList) {
        element.afterAttack(user, target, actualDamage);
      }
    }
  }
}
