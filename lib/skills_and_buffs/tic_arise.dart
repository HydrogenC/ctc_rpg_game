import 'package:ctc_rpg_game/buff_type.dart';
import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/global_data.dart';
import 'package:ctc_rpg_game/skills_and_buffs/stunned.dart';
import 'package:ctc_rpg_game/buff.dart';

class TicArise extends Buff {
  static const String _description =
      "伤害加值随着攻击次数增加上限为+5，达到上限使获得鬼上身效果\n（鬼上身：效果开始后两个回合攻击改为两段攻击，第三回合清除所有被动并眩晕一回合）";
  int _additionalDamage = 0;

  @override
  int onAttack(Entity self, Entity target, int damage) {
    int ret = 0;
    if (_additionalDamage <= 5) {
      ret = _additionalDamage;
      formMessage("伤害+$ret");
    } else if (_additionalDamage <= 7) {
      ret = damage;
      formMessage("鬼上身伤害+$ret");

      if (_additionalDamage == 7) {
        _additionalDamage = -1;
        formMessage("鬼上身消失，眩晕1回合");
        self.addBuff(Stunned(TemporaryBuff(GlobalData.singleton.round, 1)));
      }
    }
    _additionalDamage++;

    return ret;
  }

  TicArise(BuffType type) : super("将魂觉醒", _description, type);

  @override
  Buff clone(BuffType type) => TicArise(type);
}
