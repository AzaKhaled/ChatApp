import 'package:chat_app/constant.dart';
import 'package:chat_app/cubit/chat/chat_cubit.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';
  List<Message> messageList = [];
  final _controller = ScrollController();
  //this is an object used to use data frome firebase can remove this line becouse iam using it bellow
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // make object from collectiinrefirence using firebasefirestore.instance to access  message from fire base

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //to recive email from login or registerpage
    var email = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLOgo,
              height: 50,
            ),
            Text(
              'Chat',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
              var messageList = BlocProvider.of<ChatCubit>(context).mesagesList;
              return ListView.builder(
                  reverse: true,
                  controller: _controller,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    return messageList[index].id == email
                        ? ChatBuble(
                            message: messageList[index],
                          )
                        : ChatBubleForFriend(message: messageList[index]);
                  });
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              // make me control in textfiled
              controller: controller,
              //cannot use on change becose it used to send only one number or characters
              // but use onsubmitted becouse to tell untill phase to end
              onSubmitted: (data) {
                BlocProvider.of<ChatCubit>(context)
                    .sendMessage(message: data, email: email.toString(),);
                controller.clear();
                _controller.animateTo(0,
                    // _controller.position.maxScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: Icon(
                  Icons.send,
                  color: kPrimaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
