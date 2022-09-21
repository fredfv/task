import 'package:auth_module/src/views/widgets/login_button.dart';
import 'package:auth_module/src/views/widgets/login_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../blocs/events/login_event.dart';
import '../blocs/login_bloc.dart';
import '../blocs/states/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bloc = Modular.get<LoginBloc>();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController secretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.stream.listen((state) async {
      if (state is LoginSucces) {
        await Future.delayed(const Duration(milliseconds: 500));
        Modular.to.navigate('/task/');
      }

      if (state is LoginFailure) {
        const snack = SnackBar(
          content: Text('Error login'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LoginSucces) {
              return const Center(
                child: Text('Entrou'),
              );
            }
            return Container(
              color: Colors.white70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoginEntry(
                          controller: loginController,
                          obscureText: false,
                          icon: const Icon(Icons.alternate_email),
                          hintText: 'Login com email',
                          labeltext: 'Login',
                        ),
                        LoginEntry(
                          controller: secretController,
                          obscureText: true,
                          icon: const Icon(Icons.password),
                          hintText: 'Senha',
                          labeltext: 'Senha',
                        ),
                        LoginButton(onPressed: () {
                          bloc.add(LoginWithEmail(
                              email: loginController.text,
                              secret: secretController.text));
                        })
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
