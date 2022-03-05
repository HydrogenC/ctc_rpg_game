import '../entity.dart';
import '../skill.dart';

class Transform extends PassiveSkill {
  static const String _description = "每次攻击时候会汲取对手的能量反哺自身，生命值+(攻击的伤害/2)";

  Transform() : super("转化", _description);

  @override
  void afterAttack(Entity self, Entity target, int damage) {
    damage ~/= 2;
    self.cure(damage);
    formMessage("生命值+$damage");
  }

  @override
  PassiveSkill clone() {
    return Transform();
  }
}
