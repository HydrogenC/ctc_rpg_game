import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:ctc_rpg_game/basics.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/skills_and_buffs/ghost_book.dart';
import 'package:ctc_rpg_game/skills_and_buffs/tic_arise.dart';
import 'package:ctc_rpg_game/skills_and_buffs/toughness.dart';
import 'package:ctc_rpg_game/skills_and_buffs/transform.dart';
import 'package:ctc_rpg_game/buff_type.dart';
import 'package:flutter/material.dart';

class GlobalData {
  static Random random = Random();

  GlobalData._internal() {
    friendsAlive = friends.length;
    enemiesAlive = enemies.length;
  }

  List<Entity> friends = [
    Entity("姜哥", 30, 0.8, const DamageValue(1, 4, 2), [GhostBook()],
        [TicArise(BuffType())]),
    Entity("崔哥", 50, 0.4, const DamageValue(1, 4, 5), [],
        [BloodTransform(BuffType()), Toughness(BuffType())]),
    Entity("金哥", 100, 0, const DamageValue(1, 4, 2), [], []),
    Entity("翔哥", 200, 0, const DamageValue(1, 4, 2), [], []),
  ];

  List<Entity> enemies = [
    Entity("袁哥", 400, 0, const DamageValue(1, 4, 1), [], []),
  ];

  int activeIndex = 0, round = 0;
  late int friendsAlive, enemiesAlive;

  Entity get activeEntity => friends[activeIndex];
  static GlobalData singleton = GlobalData._internal();
  List<String> messageList = [];

  ValueNotifier<bool> messageAppended = ValueNotifier(false);
  ValueNotifier<bool> operationDone = ValueNotifier(false);

  SendPort? messageIn;
  late StreamController messageOut = StreamController.broadcast();



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
          if (friends[targetIndex].hp > 0) {
            if (target == 0) {
              break;
            }
            target--;
          }

          targetIndex++;
        }

        entity.use(entity, friends[targetIndex]);
        GlobalData.singleton.operationDone.value =
            !GlobalData.singleton.operationDone.value;
      }
    }

    for (var entity in friends) {
      if (entity.hp > 0) {
        entity.remainingUses = 1;

        entity.checkBuffExpired();
        for (var element in entity.buffs.toList()) {
          element.onNewTurn(entity);
        }
      }
    }

    for (var entity in enemies) {
      if (entity.hp > 0) {
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
    } while (friends[activeIndex].hp <= 0);

    if (newTurnFlag) {
      round++;
      turnStart();
    }

    operationDone.value = !operationDone.value;
  }
}
