import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/section/error_handler/global_event_handler_cubit.dart';

import 'package:flutter_template/ui/signin/signin_cubit.dart';
import 'package:flutter_template/ui/widgets/design_system/buttons/base_button.dart';
import 'package:flutter_template/ui/widgets/design_system/buttons/primary_button.dart';
import 'package:flutter_template/ui/widgets/design_system/text_fields/input_text.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            SignInCubit(context.read<GlobalEventHandlerCubit>()),
        child: _SignInContentScreen(),
      );
}

class _SignInContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SignInCubit, SignInBaseState>(
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 180,
                  ),
                  _SignInForm(),
                  if (context.read<SignInCubit>().state.error.isNotEmpty)
                    Text(
                      context.localizations
                          .error(context.read<SignInCubit>().state.error),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: AppPrimaryButton(
                          text: context.localizations.sign_in,
                          onPressed: () => context.read<SignInCubit>().signIn(),
                          style: StyleButton.filled,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppPrimaryButton(
                          text: context.localizations.dont_have_an_account,
                          onPressed: () => context.read<SignInCubit>().signIn(),
                          style: StyleButton.ghost,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _SignInForm extends StatefulWidget {
  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  late SignInCubit _signInCubit;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _signInCubit = context.read<SignInCubit>();
    // TODO: This should be bound
    _emailTextController.text = _signInCubit.state.email ?? '';
    _passwordTextController.text = _signInCubit.state.password ?? '';
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: AppTextInputField(
              controller: _emailTextController,
              labelText: context.localizations.mail,
              onChanged: (String text) => _signInCubit.changeEmail(text),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: AppTextInputField(
              obscureText: true,
              controller: _passwordTextController,
              onChanged: (String password) =>
                  _signInCubit.changePassword(password),
              labelText: context.localizations.password,
            ),
          ),
        ],
      );
}
