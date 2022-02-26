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
      return 0;
    }

    for (var element in weapon.passiveSkillList) {
      damage -= element.onDamaged(this, attacker, damage);
    }

    blood -= damage;
    if (blood < 0) {
      blood = 0;
    }

    return damage;
  }
}
