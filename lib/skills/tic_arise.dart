import 'package:ctc_rpg_game/entity.dart';
import 'package:ctc_rpg_game/skill.dart';

class TicArise extends PassiveSkill {
  int _additionalDamage = 0;

  TicArise() : super("将魂苏醒");

  @override
  int onAttack(Entity self, Entity target, int damage) {
    int ret = 0;
    if (_additionalDamage <= 5) {
      ret = _additionalDamage;
    } else if (_additionalDamage <= 7) {
      ret = damage;
    } else {
      _additionalDamage = -1;
    }
    _additionalDamage++;

    return ret;
  }

  @override
  PassiveSkill clone() {
    return TicArise();
  }
}
