import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  Future<void> LoginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    //to send email and password to firebase
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user not found') {
        //this class used to use object snackbar to show message to the user
        emit(LoginFailure(errMessage: "user not found"));
      } else if (e.code == 'wrong-password') {
        //this class used to use object snackbar to show message to the user
        emit(LoginFailure(errMessage: "wrong-password"));
      }
    } on Exception catch (e) {
      emit(LoginFailure(errMessage: "something wrong"));
    }
  }
}
