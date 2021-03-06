import 'package:ctc_rpg_game/buff_type.dart';
import 'package:ctc_rpg_game/skills_and_buffs/ghost_book.dart';
import 'package:ctc_rpg_game/skills_and_buffs/punishment.dart';
import 'package:ctc_rpg_game/skills_and_buffs/tic_arise.dart';
import 'package:ctc_rpg_game/skills_and_buffs/toughness.dart';
import 'package:ctc_rpg_game/skills_and_buffs/transform.dart';
import 'weapon.dart';
import 'basics.dart';

var weapons = {
  'tomb': Weapon(
      '墓将铲', const DamageValue(1, 4, 2), [GhostBook()], [TicArise(BuffType())]),
  'boss': Weapon('终结之剑', const DamageValue(0, 0, 100), [Punishment()], []),
  'elder': Weapon('祖传的圣剑', const DamageValue(1, 4, 5), [],
      [Transform(BuffType()), Toughness(BuffType())]),
};
