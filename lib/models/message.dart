import 'package:chat_app/constant.dart';

class Message {
  final String message;
  final String id;

  Message(this.message, this.id);

  factory Message.fromJson(dynamic jsonData) {
    return Message(
      jsonData[kMessage],
      jsonData['id'],
    );
  }
}
