import 'dart:convert';

import 'package:appointment/models/models.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// library for general functions
class LibRepository {
  /// show a modal display with yes/no choise
  Future<bool?> showOkCancelDialog(BuildContext context, String title, String question) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Der Dialog kann nicht durch Tippen außerhalb geschlossen werden
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(question),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.red.shade100)),
              child: Text(AppLocalizations.of(context)!.cancel), // 'Abbruch'
              onPressed: () {
                Navigator.of(context).pop(false); // Schließt den Dialog
              },
            ),
            TextButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.green.shade100)),
              child: Text(AppLocalizations.of(context)!.ok), // 'Ok'
              onPressed: () {
                Navigator.of(context).pop(true); // Schließt den Dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showEndWebDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Der Dialog kann nicht durch Tippen außerhalb geschlossen werden
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.exitApplication), // 'Anwendung beenden',
        content: Text(AppLocalizations.of(context)!.exitApplicationHint), //'Bitte schließen Sie diesen Browser-Tab, um die Anwendung zu beenden.'
        actions: const [
          //TextButton(
          //  child: Text('OK'),
          //  onPressed: () => Navigator.of(context).pop(),
          //),
        ],
      ),
    );
  }

  Logger getLogger() => Logger(
        filter: null, // Use the default LogFilter (-> only log in debug mode)
        printer: PrettyPrinter(
          methodCount: 2, // Number of method calls to be displayed
          errorMethodCount: 8, // Number of method calls if stacktrace is provided
          lineLength: 120, // Width of the output
          colors: false, // Colorful log messages
          printEmojis: false, // Print an emoji for each log message
          // Should each log print contain a timestamp
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ), // Use the PrettyPrinter to format and print log
        output: null, // Use the default LogOutput (-> send everything to console)
      );

// Create storage
  SharedPreferences? _prefs;
  var _setting = const Setting('en', ThemeMode.system);

  Future<Setting> loadSetting() async {
    try {
      // Obtain shared preferences.
      _prefs ??= await SharedPreferences.getInstance();
      String? value = _prefs?.getString('settings');

      if (value != null) {
        _setting = Setting.fromJson(jsonDecode(value));
      }
    } catch (e) {
      getLogger().d('loadSetting ${e.toString()}');
      if (_prefs != null) {
        await _prefs?.remove('settings'); //im Falle eines Fehlers den Speicher leeren
      }
    }

    return _setting;
  }

  Future<Setting> saveSetting(Setting setting) async {
    _setting = setting;
    try {
      _prefs ??= await SharedPreferences.getInstance();

      _prefs?.setString('settings', jsonEncode(setting.toJson()));
    } catch (e) {
      getLogger().d('saveSetting ${e.toString()}');
      if (_prefs != null) {
        await _prefs?.remove('settings'); //im Falle eines Fehlers den Speicher leeren
      }
    }
    return _setting;
  }
}
