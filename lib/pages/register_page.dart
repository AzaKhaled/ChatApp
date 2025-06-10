import 'package:chat_app/constant.dart';
import 'package:chat_app/cubit/register/register_cubit.dart';
import 'package:chat_app/helper/show_snakbar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatelessWidget {
  static String id = 'RegisterPage';
  String? email;

  String? password;

  bool isloading = false;

  //عشان اعمل key بستخدمه مع form state
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isloading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pushNamed(context, ChatPage.id);
        } else if (state is RegisterFailure) {
          ShowSnakbar(context, state.errMessage);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isloading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: formkey,
                child: ListView(
                  //  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 75,
                    ),
                    Image.asset(
                      'assets/images/scholar.jpg',
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Scholar Chat',
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontFamily: 'Pacifico')),
                      ],
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Row(
                      children: [
                        Text('Register',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomTextFiled.CustomTextFormFiled(
                      OnChaing: (data) {
                        email = data;
                      },
                      hintText: 'Email',
                    ),
                    SizedBox(height: 10),
                    CustomTextFiled.CustomTextFormFiled(
                      obscureText: true,
                      OnChaing: (data) {
                        password = data;
                      },
                      hintText: 'Password',
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                      //to cheak data is not null or wronge we useformekey and validate fromt textformfiled
                      ontap: () async {
                        if (formkey.currentState!.validate()) {
                          BlocProvider.of<RegisterCubit>(context)
                              .RegisterUser(email: email!, password: password!);
                        } else {}
                      },
                      text: 'Register',
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '  Login',
                            style: TextStyle(color: Color(0xffC7EDE6)),
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
      },
    );
  }

  Future<void> RegisterUser() async {
    //to send email and password to firebase
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
