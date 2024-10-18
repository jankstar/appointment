import 'package:flutter/material.dart';

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
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop(false); // Schließt den Dialog
              },
            ),
            TextButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.green.shade100)),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true); // Schließt den Dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Der Dialog kann nicht durch Tippen außerhalb geschlossen werden
      builder: (context) => const AlertDialog(
        title: Text('Anwendung beenden'),
        content: Text('Bitte schließen Sie diesen Browser-Tab, um die Anwendung zu beenden.'),
        actions: [
          //TextButton(
          //  child: Text('OK'),
          //  onPressed: () => Navigator.of(context).pop(),
          //),
        ],
      ),
    );
  }
}
