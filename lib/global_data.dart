import 'dart:math';

import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/weapon_defs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class GlobalData {
  static Random random = Random();

  GlobalData._internal() {
    friendsAlive = friends.length;
    enemiesAlive = enemies.length;
  }

  List<Entity> friends = [
    Entity("姜哥", 30, 0.8, weapons['tomb']!.clone()),
    Entity("崔哥", 50, 0.4, weapons['elder']!.clone()),
    Entity("金哥", 100, 0.2),
    Entity("翔哥", 200, 0.1),
  ];

  List<Entity> enemies = [
    Entity("袁哥", 400, 0),
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

  void turnStart() {
    if (round != 0) {
      for (var entity in enemies) {
        // Target index in living allies
        int target = random.nextInt(friendsAlive);

        // Target index in all allies
        int targetIndex = 0;

        while (true) {
          if (friends[targetIndex].blood > 0) {
            if (target == 0) {
              break;
            }
            target--;
          }

          targetIndex++;
        }

        entity.weapon.use(entity, friends[targetIndex]);
        GlobalData.singleton.operationDone.value =
            !GlobalData.singleton.operationDone.value;
      }
    }

    for (var entity in friends) {
      if (entity.blood > 0) {
        entity.remainingUses = 1;

        entity.checkBuffExpired();
        for (var element in entity.buffs.toList()) {
          element.onNewTurn(entity);
        }
      }
    }

    for (var entity in enemies) {
      if (entity.blood > 0) {
        entity.remainingUses = 1;
        entity.checkBuffExpired();
      }
    }
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
      turnStart();
    }

    operationDone.value = !operationDone.value;
  }
}
