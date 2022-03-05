import 'package:ctc_rpg_game/global_data.dart';

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

  // Calculate damage addition and return
  int onAttack(Entity self, Entity target, int damage) {
    return 0;
  }

  // Calculate damage addition and return
  int onActiveSkill(Entity self, Entity target, int damage, ActiveSkill skill) {
    return 0;
  }

  void onTurnStart(Entity self) {}

  void onTurnEnd(Entity self) {}

  void afterAttack(Entity self, Entity target, int damage) {}

  void afterActiveSkill(
      Entity self, Entity target, int damage, ActiveSkill skill) {}

  void afterDamaged(Entity self, Entity attacker, int damage) {}

  // Calculate damage reduction and return
  int onDamaged(Entity self, Entity attacker, int damage) {
    return 0;
  }

  void onDeath(Entity self) {}

  void formMessage(String msg){
    GlobalData.singleton.appendMessage("(被动)$name: $msg");
  }

  PassiveSkill(this.name, this.description);

  PassiveSkill clone();
}
