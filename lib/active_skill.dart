import 'basics.dart';
import 'entity.dart';
import 'global_data.dart';

abstract class ActiveSkill implements IUsable {
  DamageValue skillDamage;

  ActiveSkill(this.name, this.description, this.skillDamage);

  ActiveSkill clone();

  @override
  int use(Entity self, Entity target) {
    int damage = skillDamage.getDamage();
    damage = target.receiveDamage(
        self, damage + proceedPassive(self, target, damage));

    for (var element in self.buffs) {
      element.afterActiveSkill(self, target, damage, this);
    }

    self.remainingUses--;
    return damage;
  }

  // Calculate the additional damage dealt by passives
  int proceedPassive(Entity self, Entity target, int damage) {
    int add = 0;

    for (var element in self.buffs) {
      add += element.onActiveSkill(self, target, damage, this);
    }
    return add;
  }

  void formMessage(String msg) {
    GlobalData.singleton.appendMessage("(主动)$name: $msg");
  }

  @override
  String name;
  String description;
}
