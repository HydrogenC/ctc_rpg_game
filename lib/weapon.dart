import 'skill.dart';
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

    for (var element in self.weapon.passiveSkillList) {
      damage += element.onAttack(self, target, damage);
    }

    return target.receiveDamage(self, damage);
  }

  Weapon clone() {
    return Weapon(
        name,
        attackDamage,
        [...activeSkillList.map((e) => e.clone())],
        [...passiveSkillList.map((e) => e.clone())]);
  }
}
