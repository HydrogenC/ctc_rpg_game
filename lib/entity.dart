import 'dart:math';

import 'package:ctc_rpg_game/buff_type.dart';
import 'package:ctc_rpg_game/view_models/entity_view_model.dart';
import 'package:ctc_rpg_game/view_models/limited_property.dart';

import 'active_skill.dart';
import 'buff.dart';
import 'global_data.dart';
import 'basics.dart';

class Entity implements IUsable {
  @override
  String name = "NULL";

  int maxHp, remainingUses = 1;
  double evadePossibility;
  List<Buff> buffs = [];
  List<ActiveSkill> activeSkillList;

  // Passive skills are functionally equal to buffs
  List<Buff> passiveSkillList;
  DamageValue normalAttackDamage;
  late int hp;
  EntityViewModel? viewModel;

  Entity(this.name, this.maxHp, this.evadePossibility, this.normalAttackDamage,
      this.activeSkillList, this.passiveSkillList,
      [List<Buff>? initialBuffs]) {
    hp = maxHp;

    if (initialBuffs != null) {
      for (var element in initialBuffs) {
        addBuff(element.clone(CharacterBuff()));
      }
    }
  }

  Entity.clone(Entity other)
      : this(
            other.name,
            other.maxHp,
            other.evadePossibility,
            other.normalAttackDamage,
            other.activeSkillList,
            other.passiveSkillList);

  int cure(int amount) {
    amount = amount.clamp(0, maxHp - hp);
    hp += amount;

    GlobalData.singleton.operationDone.value =
        !GlobalData.singleton.operationDone.value;
    return amount;
  }

  // Do normal attack
  @override
  int use(Entity self, Entity target) {
    int damage = normalAttackDamage.getDamage();

    GlobalData.singleton.appendMessage("(武器)$name: 伤害=$damage");

    damage = target.receiveDamage(
        self, damage + proceedPassive(self, target, damage));

    for (var element in self.buffs.toList()) {
      element.afterAttack(self, target, damage);
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
      add += element.onAttack(self, target, damage);
    }
    return add;
  }

  int receiveDamage(Entity attacker, int damage) {
    if (random.nextDouble() < evadePossibility) {
      GlobalData.singleton
          .appendMessage("“$name”成功闪避来自“${attacker.name}”的$damage点伤害");
      return 0;
    }

    for (var element in buffs.toList()) {
      damage -= element.onDamaged(this, attacker, damage);
    }

    damage = damage.clamp(0, hp);
    hp -= damage;

    GlobalData.singleton
        .appendMessage("“$name”受到来自“${attacker.name}”的$damage点伤害");
    GlobalData.singleton.operationDone.value =
        !GlobalData.singleton.operationDone.value;

    for (var element in buffs.toList()) {
      element.afterDamaged(this, attacker, damage);
    }

    return damage;
  }

  void addBuff(Buff buff) {
    buffs.add(buff);
    buff.onGain(this);
  }

  void removeBuff(Buff buff) {
    buff.onRemove(this);
    buffs.remove(buff);
  }

  void checkBuffExpired() {
    for (var element in buffs.where((value) =>
        value.buffType is TemporaryBuff &&
        (value.buffType as TemporaryBuff).expired())) {
      removeBuff(element);
    }
  }
}
