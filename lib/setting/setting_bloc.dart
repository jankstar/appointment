import 'package:bloc/bloc.dart';

import 'setting_event.dart';
import 'setting_state.dart';

import '../repository/lib_repository.dart';


class SettingBloc extends Bloc<SettingEvent, SettingState> {

  SettingBloc() : super(SettingInitial()) {
    on<DoLoadEvent>(_onLoad);
    on<DoSaveEvent>(_onSave);
  }

  Future<void> _onLoad(DoLoadEvent event, Emitter<SettingState> emit) async {
    emit(SettingInitial());
    try {
      final settingData = await LibRepository().loadSetting();
      emit(SettingLoaded(settingData));
    } catch (e) {
      LibRepository().getLogger().e('Setting loading failed: $e');
      emit(SettingError(e.toString()));
    }   
  }

  Future<void> _onSave(DoSaveEvent event, Emitter<SettingState> emit) async {
    emit(SettingInitial());
    try {
      final settingData = await LibRepository().saveSetting(event.setting);
      emit(SettingLoaded(settingData));
    } catch (e) {
      LibRepository().getLogger().e('Setting saving failed: $e');
      emit(SettingError(e.toString()));
    }   
  }
}