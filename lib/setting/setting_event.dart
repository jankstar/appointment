import '../models/models.dart';

abstract class SettingEvent {}

class DoLoadEvent extends SettingEvent {
  DoLoadEvent();
}

class DoSaveEvent extends SettingEvent {
  final Setting setting;
  DoSaveEvent(this.setting);
}