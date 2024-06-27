import 'package:chat_app/constant.dart';

class Message {
  final String message;
  final String id;
  Message(this.message, this.id);

  factory Message.FromJason(jasonData) {
    return Message(jasonData[kMessage], jasonData['id']);
  }
}
