import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:subbi/apis/server_api.dart';

class Chat {
  final String userUid;
  final String withUid;

  Chat({
    @required this.userUid,
    @required this.withUid,
  });

  Future<void> sendMessage(Message message) async {
    await ServerApi.instance().sendMessage(
      message: message.text,
      toUid: message.toUid,
    );
  }

  Future<List<Message>> getCurrentMessages() async {
    return await ServerApi.instance().getCurrentMessages(
      withUid: withUid,
    );
  }

  Socket getMessageSocket() {
    return ServerApi.instance().getMessageSocket();
  }
}

class Message {
  final String fromUid, toUid, text;
  final DateTime date;

  Message({
    @required this.fromUid,
    @required this.toUid,
    @required this.text,
    @required this.date,
  });
}
