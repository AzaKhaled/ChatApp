import 'package:bloc/bloc.dart';
import 'package:chat_app/constant.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollection);
  List<Message> mesagesList = [];

  void sendMessage({required String message, required String email}) {
    try {
      print('send');
      messages
          .add({kMessage: message, kCreatedAt: DateTime.now(), 'id': email});
    } on Exception catch (e) {
      // TODO
    }
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen(
      (event) {
        print(event.docs);
        mesagesList.clear();
        for (var doc in event.docs) {
          print('docs = ${doc}');
          mesagesList.add(Message.fromJson(doc));
        }
        emit(ChatSuccess(message: mesagesList));
      },
    );
  }
}
