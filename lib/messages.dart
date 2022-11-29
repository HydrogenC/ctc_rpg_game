import 'package:ctc_rpg_game/entity.dart';

class NormalAttackMessage {
  NormalAttackMessage(this.self, this.target);

  Entity self, target;
}

class MoveNextMessage {
  MoveNextMessage();
}
