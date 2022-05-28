import 'package:ctc_rpg_game/active_skill.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/buff.dart';

import '../basics.dart';

class GhostBook extends ActiveSkill {
  static const String _description = "消耗 10% 的现有生命值，获得额外一个回合初始血量 40";

  GhostBook() : super("予鬼书", _description, const DamageValue(0, 0, 0));

  // Ensure that it could only be used once a round
  int lastUsedRound = -1;

  @override
  int use(Entity self, Entity target) {
    if (GlobalData.singleton.round != lastUsedRound) {
      formMessage(
          "“${self.name}”消耗了 10% 生命值 (${(0.1 * self.blood).round()} 点)，获得额外回合");
      self.blood = (0.9 * self.blood).round();
      self.remainingUses++;

      lastUsedRound = GlobalData.singleton.round;
    } else {
      formMessage("“${self.name}”本回合已经使用过予鬼书，无法重复使用");
    }

    return 0;
  }

  @override
  ActiveSkill clone() {
    return GhostBook();
  }
}
