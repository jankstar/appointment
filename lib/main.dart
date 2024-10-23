import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:appointment/bloc/login_event.dart';
import 'package:appointment/repository/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'view/login.dart';
import 'repository/lib_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginBloc(ApiRepository()),
        child: MaterialApp(
          title: 'Thunderbird Pro Appointment',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // Englisch
            Locale('de', ''), // Deutsch
          ],
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
            useMaterial3: true,
          ),
          home: const Home(title: 'Appointment'),
        ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var emailLogin = '';
  var passwordLogin = '';

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the Home object that was created by
            // the App.build method, and use it to set our appbar title.
            title: state is LoggedIn ? Text('Hi, ${state.me.name}') : Text(widget.title),
            actions: [
              if (state is LoggedIn)
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: AppLocalizations.of(context)!.logout, // 'Logout',
                  onPressed: () => context.read<LoginBloc>().add(DoLogoutEvent(state.token.access_token)),
                )
              else
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  tooltip: AppLocalizations.of(context)!.exit, // 'Beenden',
                  onPressed: () async => _goExit(),
                )
            ]),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: state is LoggedIn ? Text(state.me.toString()) : const LoginDialog(),
        ),
      );
    });
  }

  void _goExit() async {
    var answer = await LibRepository().showOkCancelDialog(
        context,
        AppLocalizations.of(context)!.confirmation,      //'Bestätigung',
        AppLocalizations.of(context)!.exitConfirmation); //'Wollen Sie die Anwendung beenden?');
    if (answer == true) {
      if (kIsWeb) {
        // ignore: use_build_context_synchronously
        LibRepository().showEndWebDialog(context);
      } else if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        exit(0);
      }
    }
  }
}
