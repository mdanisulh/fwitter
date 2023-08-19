import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/features/auth/views/sign_up_view.dart';
import 'package:fwitter/features/auth/widgets/auth_field.dart';
import 'package:fwitter/theme/theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final appBar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthField(
                textEditingController: emailController,
                label: 'Email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25),
              AuthField(
                textEditingController: passwordController,
                label: 'Password',
                obscureText: true,
                textInputType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.topRight,
                child: RoundedSmallButton(
                  onTap: () {},
                  label: 'Login',
                ),
              ),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: "Don't have an account?",
                  style: const TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: ' Sign up',
                      style: const TextStyle(
                        color: Pallete.blueColor,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpView()));
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
