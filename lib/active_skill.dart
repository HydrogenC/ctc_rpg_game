import 'basics.dart';
import 'entity.dart';
import 'global_data.dart';

abstract class ActiveSkill {
  DamageValue skillDamage;

  ActiveSkill(this.name, this.description, this.skillDamage);

  ActiveSkill clone();

  int use(Entity self, Entity target) {
    int damage = skillDamage.getDamage();
    damage = target.receiveDamage(
        self, damage + proceedPassive(self, target, damage));

    for (var element in self.buffs.toList()) {
      element.afterActiveSkill(self, target, damage, this);
    }

    if (self.remainingUses > 0) {
      self.remainingUses--;
    }
    return damage;
  }

  // Calculate the additional damage dealt by passives
  int proceedPassive(Entity self, Entity target, int damage) {
    int add = 0;

    for (var element in self.buffs.toList()) {
      add += element.onActiveSkill(self, target, damage, this);
    }
    return add;
  }

  void formMessage(String msg) {
    GlobalData.singleton.appendMessage("(主动)$name: $msg");
  }

  String name;
  String description;
}
