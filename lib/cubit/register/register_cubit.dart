import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());


  Future<void> RegisterUser(
    
      {required String email, required String password}) async {
    emit(RegisterLoading());
    //to send email and password to firebase
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //this class used to use object snackbar to show message to the user
        emit(RegisterFailure(errMessage: "Weak Password"));
      } else if (e.code == 'email-already-in-use') {
        //this class used to use object snackbar to show message to the user
        emit(RegisterFailure(errMessage: "Email Already Existe"));

        
      }
    } catch (e) {
              emit(RegisterFailure(errMessage: "These an error"));

    }
  }
}
