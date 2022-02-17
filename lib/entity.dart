import 'weapon.dart';
import 'basics.dart';

class Entity {
  String name = "NULL";
  int maxBlood;
  double evadePossibility;
  Weapon weapon = Weapon('手', const DamageValue(1, 3, 0), [], []);
  late int blood;

  Entity(this.name, this.maxBlood, this.evadePossibility) {
    blood = maxBlood;
  }

  int receiveDamage(Entity attacker, int damage) {
    if (random.nextDouble() < evadePossibility) {
      return 0;
    }

    for (var element in weapon.passiveSkillList) {
      damage = element.onDamaged(this, attacker, damage);
    }

    blood -= damage;
    if (blood < 0) {
      blood = 0;
    }

    return damage;
  }
}
