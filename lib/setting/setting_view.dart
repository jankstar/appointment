// ignore_for_file: non_constant_identifier_names

import 'package:appointment/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'setting_state.dart';
import 'setting_bloc.dart';
import 'setting_event.dart';

import '../login/login_bloc.dart';
import '../login/login_state.dart';
import '../login/login_event.dart';

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
  final List<String> timeZones = tz.timeZoneDatabase.locations.keys.toList();
  //default
  String? _langu;
  ThemeMode? _themeMode;
  String? _timezone;
  String? _username;
  String? _name;
  String? _secondary_email;
  String? _avatar_url;
  var meChanged = false;

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    List<String> timeZones = tz.timeZoneDatabase.locations.keys.toList();
//
    return BlocBuilder<SettingBloc, SettingState>(builder: (context, settingState) {
      return BlocBuilder<LoginBloc, LoginState>(builder: (context, loginState) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settings),
          content: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  /// theme
                  DropdownButtonFormField<ThemeMode>(
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.theme),
                    value: settingState is SettingLoaded ? settingState.setting.themeMode : ThemeMode.system,
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

                  /// language
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.language),
                    value: settingState is SettingLoaded ? settingState.setting.langu : 'en',
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
                  if (loginState is LoggedIn) ...[
                    /// timezone
                    DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.timezone),
                        value: loginState.me.timezone,
                        onChanged: (value) {
                          setState(() {
                            _timezone = value!;
                            meChanged = true;
                          });
                        },
                        items: List.generate(timeZones.length, (int index) {
                          return DropdownMenuItem(
                            value: timeZones[index],
                            child: Text(timeZones[index]),
                          );
                        })),

                    /// username
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'Username'),
                        initialValue: loginState.me.username,
                        onChanged: (value) {
                          setState(() {
                            _username = value;
                            meChanged = true;
                          });
                        }),
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        initialValue: loginState.me.name,
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                            meChanged = true;
                          });
                        }),
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'Secondary Email'),
                        initialValue: loginState.me.preferred_email,
                        onChanged: (value) {
                          setState(() {
                            _secondary_email = value;
                            meChanged = true;
                          });
                        }),
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'Avatar URL'),
                        initialValue: loginState.me.avatar_url,
                        onChanged: (value) {
                          setState(() {
                            _avatar_url = value;
                            meChanged = true;
                          });
                        }),
                  ],
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
              onPressed: () => _save(context, settingState, loginState, meChanged: meChanged),
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      });
    });
  }

  void _save(BuildContext context, SettingState settingState, LoginState loginState, {bool meChanged = false}) {
    context.read<SettingBloc>().add(DoSaveEvent(Setting(
        //
        _langu ?? (settingState is SettingLoaded ? settingState.setting.langu : 'en'),
        _themeMode ?? (settingState is SettingLoaded ? settingState.setting.themeMode : ThemeMode.system))));

    if (loginState is LoggedIn && meChanged == true) {
      _timezone = _timezone ?? loginState.me.timezone ?? 'Europe/Dublin';
      _username = _username ?? loginState.me.username ?? '';
      _name = _name ?? loginState.me.name ?? '';
      _avatar_url = _avatar_url ?? loginState.me.avatar_url ?? '';
      _secondary_email = _secondary_email ?? loginState.me.secondary_email ?? '';
      context.read<LoginBloc>().add(DoSetMeEvent(
          loginState.token, //
          _timezone!,
          _username!,
          _name!,
          _avatar_url!,
          _secondary_email!));
    }
    Navigator.pop(context);
  }
}
