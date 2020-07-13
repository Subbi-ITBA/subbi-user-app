import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:subbi/models/profile/chat.dart';
import 'package:subbi/models/profile/profile.dart';
import 'package:subbi/models/user.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final Profile withProfile;

  ChatScreen({
    @required this.withProfile,
    @required this.user,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Chat chat;
  Socket _messageSocket;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    chat = Chat(
      userUid: widget.user.getUID(),
      withUid: widget.withProfile.profileUid,
    );

    _messageSocket = chat.getMessageSocket();

    _messageSocket.on(
      'message',
      (data) {
        setState(
          () {
            _messages.add(
              ChatMessage(
                text: data["msg"],
                createdAt: DateTime.parse(data["date"]).toLocal(),
                user: ChatUser(),
              ),
            );
          },
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _messageSocket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.withProfile.name),
      ),
      body: FutureBuilder(
        future: _loadMessages(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return DashChat(
            inverted: false,
            user: ChatUser(
              name: "Jhon Doe",
              uid: "123456789",
              avatar:
                  "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
            ),
            onSend: (message) async {
              _messages.add(
                ChatMessage(
                  createdAt: DateTime.now().toLocal(),
                  text: message.text,
                  user: ChatUser(
                    name: widget.user.profile.name,
                  ),
                ),
              );
              await chat.sendMessage(
                Message(
                  date: DateTime.now().toLocal(),
                  fromUid: chat.userUid,
                  toUid: chat.withUid,
                  text: message.text,
                ),
              );
            },
            messages: _messages,
            inputDisabled: false,
          );
        },
      ),
    );
  }

  Future<void> _loadMessages() async {
    if (_messages.isEmpty) {
      _messages = (await chat.getCurrentMessages()).map(
        (message) {
          return ChatMessage(
            text: message.text,
            createdAt: message.date.toLocal(),
            user: ChatUser(
              name: widget.withProfile.name,
            ),
          );
        },
      ).toList();
    }
  }
}
