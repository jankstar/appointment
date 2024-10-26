import '../models/models.dart';

abstract class SettingState {}

class SettingInitial extends SettingState {}
class SettingLoaded extends SettingState {
  final Setting setting;
  SettingLoaded(this.setting);
}
class SettingError extends SettingState {
  final String error;
  SettingError(this.error);
}