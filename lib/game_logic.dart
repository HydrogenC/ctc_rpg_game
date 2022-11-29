import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/messages.dart';

Future<void> startGameLoop() async {
  await Future.delayed(const Duration(seconds: 2));
  var messageQueue = GlobalData.singleton.messageOut;
  turnStartCheck();

  await for (var msg in messageQueue.stream) {
    if (msg is MoveNextMessage) {
      moveNext();
    } else if (msg is AttackMessage) {
      if (msg.type < 0) {
        msg.self.normalAttack(msg.target);
      } else {
        msg.self.activeSkillList[msg.type].use(msg.self, msg.target);
      }

      msg.self.viewModel?.updateEntity(msg.self);
      msg.target.viewModel?.updateEntity(msg.target);
      GlobalData.singleton.viewModel?.forceUpdate();
    }
  }
}

void moveNext() {
  var sing = GlobalData.singleton;
  if (sing.friendsAlive == 0) {
    return;
  }

  bool newTurnFlag = false;
  do {
    sing.activeIndex++;
    if (sing.activeIndex >= sing.friends.length) {
      newTurnFlag = true;
      sing.activeIndex = 0;
    }
  } while (sing.friends[sing.activeIndex].hp <= 0);

  if (newTurnFlag) {
    sing.round++;
    turnStartCheck();
  }

  sing.viewModel?.updateActiveEntity(sing.activeEntity);
}

void turnStartCheck() {
  for (var entity in GlobalData.singleton.friends) {
    if (entity.hp > 0) {
      entity.remainingUses = 1;

      entity.checkBuffExpired();
      for (var element in entity.buffs.toList()) {
        element.onNewTurn(entity);
      }

      entity.viewModel!.updateEntity(entity);
    }
  }

  for (var entity in GlobalData.singleton.enemies) {
    if (entity.hp > 0) {
      entity.remainingUses = 1;
      entity.checkBuffExpired();
    }

    entity.viewModel!.updateEntity(entity);
  }
}
