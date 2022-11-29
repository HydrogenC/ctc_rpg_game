import 'package:ctc_rpg_game/entity.dart';

class MoveNextMessage {
  MoveNextMessage();
}

class AttackMessage{
  AttackMessage(this.self, this.target, this.type);

  Entity self, target;

  //  -1: Normal Attack
  // 0~n: Active skill 0~n
  int type;
}
