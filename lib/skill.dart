import 'basics.dart';
import 'entity.dart';

class ActiveSkill implements IUsable {
  DamageValue skillDamage;

  ActiveSkill(this.name, this.skillDamage);

  @override
  int use(Entity self, Entity target) {
    int damage = skillDamage.getDamage();

    for (var element in self.weapon.passiveSkillList) {
      damage = element.onAttack(self, target, damage);
    }

    return target.receiveDamage(self, damage);
  }

  @override
  String name;
}

class PassiveSkill {
  String name;

  int onAttack(Entity self, Entity target, int damage) {
    return damage;
  }

  int onActiveSkill(Entity self, Entity target, int damage, ActiveSkill skill) {
    return damage;
  }

  void onTurnStart(Entity self) {}

  int onDamaged(Entity self, Entity attacker, int damage) {
    return damage;
  }

  void onDeath(Entity self) {}

  PassiveSkill(this.name);
}