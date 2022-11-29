import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/view_models/limited_property.dart';

Future<void> startGameLoop() async {
  await Future.delayed(const Duration(seconds: 2));
  var messageQueue = GlobalData.singleton.messageOut;

  for (var entity in GlobalData.singleton.friends) {
    entity.viewModel!
        .modifyProperty('hp', LimitedProperty(entity.maxHp, entity.maxHp));
  }
}

void turnStartCheck() {
  for (var entity in GlobalData.singleton.friends) {
    if (entity.hp > 0) {
      entity.remainingUses = 1;

      entity.checkBuffExpired();
      for (var element in entity.buffs.toList()) {
        element.onNewTurn(entity);
      }
    }
  }

  for (var entity in GlobalData.singleton.enemies) {
    if (entity.hp > 0) {
      entity.remainingUses = 1;
      entity.checkBuffExpired();
    }
  }
}
