import '../entity.dart';
import '../skill.dart';

class TicArise extends PassiveSkill {
  int _additionalDamage = 0;

  TicArise() : super("将魂苏醒");

  @override
  int onAttack(Entity self, Entity target, int damage) {
    damage += _additionalDamage;
    if (_additionalDamage < 5) {
      _additionalDamage++;
    }

    return damage;
  }
}
