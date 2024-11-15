import 'dart:typed_data';
import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class AIChatBot extends StatefulWidget {
  const AIChatBot({super.key});

  @override
  State<AIChatBot> createState() => _AIChatBotState();
}

class _AIChatBotState extends State<AIChatBot> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: 'Gemini',
    profileImage:
    'https://i.pinimg.com/236x/ca/59/84/ca5984fe778c501215a4107dff8cf2f5.jpg',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        title: const Text(
          'Pregnancy ChatBot',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: buildUI(),
    );
  }

  Widget buildUI() {
    return Container(
      child: DashChat(
        inputOptions: InputOptions(
          inputDecoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Type a message...',
            hintStyle: TextStyle(color: Colors.grey.shade700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          leading: [
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.pinkAccent),
              onPressed: _sendMediaMesseage,
            )
          ],
          trailing: [
            IconButton(
              icon: const Icon(Icons.send, color: Colors.pinkAccent),
              onPressed: () {

              },
            ),
          ],
        ),
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.pinkAccent.shade100,
          currentUserTextColor: Colors.white,
          containerColor: Colors.grey.shade200,
          textColor: Colors.black,
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    messages = [chatMessage, ...messages];
    setState(() {});
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        String response = event.content?.parts?.fold(
          '',
              (previous, current) => '$previous${current.text}',
        ) ??
            '';
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          lastMessage.text += response;
          messages = [lastMessage, ...messages];
          setState(() {});
        } else {
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          messages = [message, ...messages];
          setState(() {});
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMesseage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: 'Describe this picture?',
        medias: [
          ChatMedia(url: file.path, fileName: '', type: MediaType.image),
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}
