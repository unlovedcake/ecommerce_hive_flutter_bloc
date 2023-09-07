import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/bloc/auth/auth_bloc.dart';
import 'package:hive/constants/asset_storage_image.dart';
import 'package:hive/modules/dashboard/views/dashboard.dart';
import 'package:hive/routes/app_router.dart';

part 'sign_in_controller.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final isShowPassword = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color(0xffBA68C8),
      //   automaticallyImplyLeading: false,
      //   title: const Text("SignIn"),
      // ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Loading) {
            showLoaderDialog(context);
          } else if (state is AuthErrorSignIn) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is Authenticated) {
            // RouterPageAnimation.routePageAnimation(
            //     context, RouterPageAnimation.goToDashBoard());
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil('/dashboard', (Route route) => false);
            Navigator.pop(context);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashBoard()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.asset(AssetStorageImage.loginBg)),
                      const SizedBox(
                        height: 18,
                      ),
                      Center(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: "Email",
                                  border: OutlineInputBorder(),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // validator: (value) {
                                //   return value != null &&
                                //           !EmailValidator.validate(value)
                                //       ? 'Enter a valid email'
                                //       : null;
                                // },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ValueListenableBuilder<bool>(
                                builder: (context, value, Widget? child) {
                                  return TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    controller: _passwordController,
                                    obscureText: !isShowPassword.value,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(isShowPassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        color: const Color(0xffBA68C8),
                                        onPressed: () {
                                          isShowPassword.value =
                                              !isShowPassword.value;
                                        },
                                      ),
                                      hintText: "Password",
                                      border: const OutlineInputBorder(),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null && value.length < 6
                                          ? "Enter min. 6 characters"
                                          : null;
                                    },
                                  );
                                },
                                valueListenable: isShowPassword,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    backgroundColor: Colors.white,
                                    shape: const StadiumBorder()),
                                onPressed: state is Loading
                                    ? null
                                    : () {
                                        _authenticateWithEmailAndPassword();
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Sign In',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    state is Loading
                                        ? const SpinKitFadingCircle(
                                            color: Colors.blue,
                                            size: 40.0,
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.blue,
                                            size: 20,
                                          )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const Text(
                            '  OR  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                //minimumSize: const Size(100, 50),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.white,
                                shape: const StadiumBorder()),
                            onPressed: () async {},
                            child: Image.asset(AssetStorageImage.facebook),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                //minimumSize: const Size(100, 50),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.white,
                                shape: const StadiumBorder()),
                            onPressed: () async {
                              _authenticateWithGoogle();
                            },
                            child: Image.asset(AssetStorageImage.google),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              RouterPageAnimation.routePageAnimation(
                                  context, RouterPageAnimation.goToSignUp());
                            },
                            child: const Text("Sign Up"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
