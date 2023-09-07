import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/bloc/auth/auth_bloc.dart';
import 'package:hive/constants/asset_storage_image.dart';
import 'package:hive/modules/dashboard/views/dashboard.dart';
import 'package:hive/routes/app_router.dart';

part 'sign_up_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final isShowPassword = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffBA68C8),
        title: const Text("SignUp"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorSignUp) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AuthenticatedSignUp) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashBoard()),
              (route) => false,
            );
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil('/dashboard', (Route route) => false);
          }
        },
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
                        child: Image.asset(AssetStorageImage.signUpBg)),
                    const Text(
                      "Create An Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: "Name",
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
                            TextFormField(
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
                                      color: Color(0xffBA68C8),
                                      onPressed: () {
                                        isShowPassword.value =
                                            !isShowPassword.value;
                                      },
                                    ),
                                    hintText: "Password",
                                    border: OutlineInputBorder(),
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
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  backgroundColor: Colors.white,
                                  shape: const StadiumBorder()),
                              onPressed: state is Loading
                                  ? null
                                  : () {
                                      _createAccountWithEmailAndPassword();
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Create Account',
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            RouterPageAnimation.routePageAnimation(
                                context, RouterPageAnimation.goToSignIn());
                          },
                          child: const Text("Sign In"),
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
    );
  }
}
