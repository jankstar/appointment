import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return AlertDialog(
        title: const Text('Login'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie einen Emailadresse ein';
                  }
                  if (!_isEmailValid(value)) {
                    return 'Emailadresse ist nicht zulässig';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Passwort'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie ein Passwort ein';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.green.shade100)),
            onPressed: _submit,
            child: const Text('Login'),
          ),
        ],
      );
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      print('username: ${_usernameController.text}');
      context.read<LoginBloc>().add(DoLoginEvent(_usernameController.text, _passwordController.text)); // do login
    }
  }

  bool _isEmailValid(String email) {
    String pattern = r'^[\w.+-]{2,}\@[\w.-]{2,}\.[a-z]{2,6}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
