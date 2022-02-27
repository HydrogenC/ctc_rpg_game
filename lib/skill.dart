import 'basics.dart';
import 'entity.dart';

abstract class ActiveSkill implements IUsable {
  DamageValue skillDamage;

  ActiveSkill(this.name, this.description, this.skillDamage);

  ActiveSkill clone();

  @override
  int use(Entity self, Entity target) {
    int damage = skillDamage.getDamage();
    return target.receiveDamage(
        self, damage + proceedPassive(self, target, damage));
  }

  // Calculate the additional damage dealt by passives
  int proceedPassive(Entity self, Entity target, int damage) {
    int add = 0;
    for (var element in self.weapon.passiveSkillList) {
      add += element.onActiveSkill(self, target, damage, this);
    }

    return add;
  }

  @override
  String name;
  String description;
}

abstract class PassiveSkill {
  String name, description;

  int onAttack(Entity self, Entity target, int damage) {
    return 0;
  }

  int onActiveSkill(Entity self, Entity target, int damage, ActiveSkill skill) {
    return 0;
  }

  void onTurnStart(Entity self) {}

  int onDamaged(Entity self, Entity attacker, int damage) {
    return 0;
  }

  void onDeath(Entity self) {}

  PassiveSkill(this.name, this.description);

  PassiveSkill clone();
}
