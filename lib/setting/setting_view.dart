import 'package:appointment/models/models.dart';
import 'package:appointment/setting/setting_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'setting_state.dart';
import 'setting_bloc.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsDialog createState() => _SettingsDialog();
}

class _SettingsDialog extends State<SettingsDialog> {
  final _formKey = GlobalKey<FormState>();
  //default
  String? _langu;
  ThemeMode? _themeMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
      return AlertDialog(
        title: const Text('Settings'),
        content: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //
                DropdownButtonFormField<ThemeMode>(
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.theme),
                  value: state is SettingLoaded ? state.setting.themeMode : ThemeMode.system,
                  onChanged: (value) {
                    setState(() {
                      _themeMode = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Theme'),
                    )
                  ],
                ),

                ///
                ///
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.language),
                  value: state is SettingLoaded ? state.setting.langu : 'en',
                  onChanged: (value) {
                    setState(() {
                      _langu = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'de',
                      child: Text('deutsch'),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('englisch'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.red.shade100)),
            child: Text(AppLocalizations.of(context)!.cancel), // 'Abbruch'
            onPressed: () {
              Navigator.pop(context); // Schließt den Dialog ohne Save
            },
          ),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.green.shade100)),
            onPressed: () => _save(state),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      );
    });
  }

  void _save(SettingState state) {
    context.read<SettingBloc>().add(DoSaveEvent(Setting(
      _langu ?? (state is SettingLoaded ? state.setting.langu : 'en'), 
      _themeMode ?? (state is SettingLoaded ? state.setting.themeMode : ThemeMode.system))));
    Navigator.pop(context);
  }
}
