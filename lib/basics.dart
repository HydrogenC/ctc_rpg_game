import 'dart:math';
import 'entity.dart';

Random random = Random();

abstract class IUsable {
  int use(Entity self, Entity target) => 0;

  String get name;

  set name(String value);
}

class DamageValue {
  final int maxDamage, minDamage, fixedDamage;

  const DamageValue(this.minDamage, this.maxDamage, this.fixedDamage);

  int getDamage() {
    return random.nextInt(maxDamage - minDamage + 1) + minDamage + fixedDamage;
  }

  @override
  String toString(){
    return "${minDamage}d$maxDamage+$fixedDamage";
  }
}
