import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/features/auth/views/login_view.dart';
import 'package:fwitter/features/auth/widgets/auth_field.dart';
import 'package:fwitter/theme/theme.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final appBar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.topRight,
                child: RoundedSmallButton(
                  onTap: () {},
                  label: 'Create',
                ),
              ),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: "Already have an account?",
                  style: const TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: ' Login',
                      style: const TextStyle(
                        color: Pallete.blueColor,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
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
