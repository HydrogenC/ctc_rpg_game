import 'skills/punishment.dart';
import 'skills/tic_arise.dart';
import 'weapon.dart';
import 'basics.dart';

var weapons = {
  'tomb': Weapon('墓将铲', const DamageValue(1, 4, 2), [], [TicArise()]),
  'boss': Weapon('终结之剑', const DamageValue(100, 100, 0), [Punishment()], [])
};
