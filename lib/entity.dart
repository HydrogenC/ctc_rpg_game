import 'package:ctc_rpg_game/buff_type.dart';

import 'buff.dart';
import 'global_data.dart';
import 'weapon.dart';
import 'basics.dart';

class Entity {
  String name = "NULL";
  int maxBlood, remainingUses = 1;
  double evadePossibility;
  List<Buff> buffs = [];
  Weapon weapon = Weapon('手', const DamageValue(1, 3, 0), [], []);
  late int blood;

  Entity(this.name, this.maxBlood, this.evadePossibility,
      [Weapon? wp, List<Buff>? initialBuffs]) {
    blood = maxBlood;
    if (wp != null) {
      changeWeapon(wp);
    }

    if (initialBuffs != null) {
      for (var element in initialBuffs) {
        addBuff(element.clone(CharacterBuff()));
      }
    }
  }

  Entity.clone(Entity other)
      : this(other.name, other.maxBlood, other.evadePossibility);

  void changeWeapon(Weapon newWeapon) {
    for (var element in weapon.permanentBuffList) {
      removeBuff(buffs.firstWhere((e) => e.runtimeType == element.runtimeType));
    }

    weapon = newWeapon;

    for (var element in weapon.permanentBuffList) {
      addBuff(element.clone(WeaponBuff(weapon)));
    }
  }

  int cure(int amount) {
    amount = amount.clamp(0, maxBlood - blood);
    blood += amount;

    GlobalData.singleton.operationDone.value =
        !GlobalData.singleton.operationDone.value;
    return amount;
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

    damage = damage.clamp(0, blood);
    blood -= damage;

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
