import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:poralekha_app/common/button.dart';
import 'package:poralekha_app/common/text_filed.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.network(
                  "https://lottie.host/c2f90682-e881-44a2-8db3-3edb81ac2c4e/zmw5G9db1o.json",
                  height: 200),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Forget Password?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Don't worry sometimes people can forget too, enter your email we will send you password reset link",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 80, 78, 78)),
              ),
              const SizedBox(
                height: 32 * 2,
              ),
              TextFormFiledCommon(
                  controller: emailController,
                  text: "E-mail",
                  textInputType: TextInputType.emailAddress,
                  obscure: false),
              const SizedBox(
                height: 32,
              ),
              Center(
                  child: RoundedButton(
                      title: "Reset Password", onTap: () {}, width: 250))
            ],
          ),
        ),
      ),
    );
  }
}
