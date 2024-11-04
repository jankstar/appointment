import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login/login_view.dart';
import 'login/login_bloc.dart';
import 'login/login_state.dart';
import 'login/login_event.dart';

import 'repository/lib_repository.dart';
import 'repository/api_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'setting/setting_view.dart';
import 'setting/setting_bloc.dart';
import 'setting/setting_state.dart';
import 'setting/setting_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          //
          BlocProvider(create: (context) => LoginBloc(ApiRepository())),
          BlocProvider(create: (context) => SettingBloc()..add(DoLoadEvent()))
        ],
        child: BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
          return MaterialApp(
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
            locale: state is SettingLoaded ? Locale(state.setting.langu) : const Locale('en'),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
              useMaterial3: true,
            ),
            home: const Home(title: 'Appointment'),
          );
        }));
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var emailLogin = '';
  var passwordLogin = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
            //
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: state is LoggedIn ? Text('Hi, ${state.me.name}') : Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: AppLocalizations.of(context)!.settings, // 'Settings',
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsDialog(),
                      //settings: RouteSettings(
                      //  arguments: null,
                      //),
                    ),
                  ),
                },
              ),
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
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  state is LoggedIn ? Text(state.me.toString()) : const LoginDialog(), 
                  state is LoginError ? Text(state.error,style: const TextStyle(color: Colors.redAccent)) : const Text(''),]),
        ),
      );
    });
  }

  void _goExit() async {
    var answer = await LibRepository().showOkCancelDialog(
        context,
        AppLocalizations.of(context)!.confirmation, //'Bestätigung',
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
