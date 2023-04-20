import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapienpantry/controller/auth_controller.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/view/login_view.dart';
import 'package:sapienpantry/view/register_view.dart';
import 'package:sapienpantry/widgets/app_logo.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}
class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const AppLogo(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email to reset your password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Obx(() {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8.0),
                    height: 60,
                    decoration: BoxDecoration(
                      color: authController.isAuthenticating
                          ? pPrimaryColor
                          : pPrimaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: authController.isAuthenticating
                        ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : MaterialButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (formKey.currentState!.validate()) {
                          debugPrint('Ok');
                          final result = await authController
                              .resetPassword(emailController.text);
                          if (result) {
                            Get.offAll(() => const LoginScreen());
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('A reset link has been sent to your email'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Failed to reset password'),
                            ));
                          }
                        }
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),

                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text('Return to'),
                          TextButton(
                            onPressed: () {
                              Get.off(() => const LoginScreen());
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Dont have an account?'),
                          TextButton(
                            onPressed: () {
                              Get.off(() => const RegisterScreen());
                            },
                            child: const Text('SignUp'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
