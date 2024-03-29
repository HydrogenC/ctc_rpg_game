import 'dart:math';
import 'active_skill.dart';
import 'entity.dart';

Random random = Random();

class DamageValue {
  final int maxDamage, minDamage, fixedDamage;

  const DamageValue(this.minDamage, this.maxDamage, this.fixedDamage);

  int getDamage() {
    return random.nextInt(maxDamage - minDamage + 1) + minDamage + fixedDamage;
  }

  @override
  String toString() {
    return "${minDamage}d$maxDamage+$fixedDamage";
  }
}

class LimitedProperty<T> {
  late T maxValue;
  late T value;

  LimitedProperty(this.value, this.maxValue);

  @override
  String toString() {
    return "$value/$maxValue";
  }
}

abstract class IGameEventListener {
  // Calculate damage addition and return
  int onAttack(Entity self, Entity target, int damage) {
    return 0;
  }

  // Calculate damage addition and return
  int onActiveSkill(Entity self, Entity target, int damage, ActiveSkill skill) {
    return 0;
  }

  void onNewTurn(Entity self) {}

  void afterAttack(Entity self, Entity target, int damage) {}

  void afterActiveSkill(
      Entity self, Entity target, int damage, ActiveSkill skill) {}

  void afterDamaged(Entity self, Entity attacker, int damage) {}

  // Calculate damage reduction and return
  int onDamaged(Entity self, Entity attacker, int damage) {
    return 0;
  }

  void onDeath(Entity self) {}
}
