import 'package:ctc_rpg_game/entity.dart';

class PropertyChangeMessage{
  PropertyChangeMessage(this.entity, this.properties);

  Entity entity;
  Map<String, int> properties;
}
