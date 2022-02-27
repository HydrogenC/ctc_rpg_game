import 'package:ctc_rpg_game/global_data.dart';

import 'weapon.dart';
import 'basics.dart';

class Entity {
  String name = "NULL";
  int maxBlood;
  double evadePossibility;
  late Weapon weapon;
  late int blood;

  Entity(this.name, this.maxBlood, this.evadePossibility, [Weapon? wp]) {
    blood = maxBlood;
    weapon = wp ?? Weapon('手', const DamageValue(1, 3, 0), [], []);
  }

  Entity.clone(Entity other)
      : this(other.name, other.maxBlood, other.evadePossibility);

  int receiveDamage(Entity attacker, int damage) {
    if (random.nextDouble() < evadePossibility) {
      GlobalData.singleton
          .appendMessage("“$name”成功闪避来自“${attacker.name}”的$damage点伤害");
      return 0;
    }

    for (var element in weapon.passiveSkillList) {
      damage -= element.onDamaged(this, attacker, damage);
    }

    blood -= damage;
    if (blood < 0) {
      blood = 0;
    }

    GlobalData.singleton
        .appendMessage("“$name”受到来自“${attacker.name}”的$damage点伤害");
    return damage;
  }
}
