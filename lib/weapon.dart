import 'active_skill.dart';
import 'global_data.dart';
import 'passive_skill.dart';
import 'basics.dart';
import 'entity.dart';

class Weapon implements IUsable {
  @override
  String name;

  DamageValue attackDamage;
  List<ActiveSkill> activeSkillList;
  List<PassiveSkill> passiveSkillList;

  Weapon(this.name, this.attackDamage, this.activeSkillList,
      this.passiveSkillList);

  @override
  int use(Entity self, Entity target) {
    int damage = attackDamage.getDamage();

    GlobalData.singleton.appendMessage("(武器)$name: 伤害=$damage");
    damage = target.receiveDamage(
        self, damage + proceedPassive(self, target, damage));

    for (var element in self.weapon.passiveSkillList) {
      element.afterAttack(self, target, damage);
    }

    for (var element in self.buffs) {
      element.afterAttack(self, target, damage);
    }

    self.remainingUses--;
    return damage;
  }

  // Calculate the additional damage dealt by passives
  int proceedPassive(Entity self, Entity target, int damage) {
    int add = 0;
    for (var element in self.weapon.passiveSkillList) {
      add += element.onAttack(self, target, damage);
    }

    for (var element in self.buffs) {
      add += element.onAttack(self, target, damage);
    }
    return add;
  }

  Weapon clone() {
    return Weapon(
        name,
        attackDamage,
        [...activeSkillList.map((e) => e.clone())],
        [...passiveSkillList.map((e) => e.clone())]);
  }
}
