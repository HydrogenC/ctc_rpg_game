import 'package:ctc_rpg_game/entity.dart';

class GlobalData {
  GlobalData._internal(){
    friendsAlive=friends.length;
    enemiesAlive=enemies.length;
  }

  List<Entity> friends = [
    Entity("玩家1", 30, 0.8),
    Entity("玩家2", 50, 0.6),
    Entity("玩家3", 100, 0.2),
    Entity("玩家4", 200, 0.1),
  ];

  List<Entity> enemies = [
    Entity("敌人1", 50, 0),
  ];

  int activeIndex = 0;
  late int friendsAlive, enemiesAlive;

  Entity get activeEntity => friends[activeIndex];

  static GlobalData singleton = GlobalData._internal();

  void moveNext(){
    if(friendsAlive==0){
      return;
    }

    do {
      activeIndex++;
      if (activeIndex >= friends.length) {
        activeIndex = 0;
      }
    } while (friends[activeIndex].blood <= 0);
  }
}
