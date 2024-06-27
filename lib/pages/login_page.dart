import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/show_snakbar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
  static String id = 'LoginPage';
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;

  bool isloading = false;
  //عشان اعمل key بستخدمه مع form state
  GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    //used to show loading icons 
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
                    Text('LOGIN',
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
                  //to disapear password
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
                      isloading = true;
                      setState(() {});
                      try {
                        //to send email and password to firebase
                        await LoginUser();
                        Navigator.pushNamed(context, ChatPage.id,arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user not found') {
                          //this class used to use object snackbar to show message to the user
                          ShowSnakbar(context, 'Weak Password');
                        } else if (e.code == 'wrong-password') {
                          //this class used to use object snackbar to show message to the user
                          ShowSnakbar(context, 'wrong password');
                        }
                      } catch (e) {
                        print(e);
                        ShowSnakbar(context, 'These an error');
                      }
                      isloading = false;
                      setState(() {});
                    } else {}
                  },
                  text: 'Login',
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'dont\'t have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: Text(
                        '  Register',
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
  }

  Future<void> LoginUser() async {
    //to send email and password to firebase
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
