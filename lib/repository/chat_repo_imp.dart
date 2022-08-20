import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/repository/chat_repo.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChannelRepoImp implements ChannelRepo {
  late Socket socket;

  @override
  Future<void> initRepo(String accessToken, String channelId) async {
    print("initRepo...");
    socket = await io.io('wss://api.sg.amity.co/?token=$accessToken',
        io.OptionBuilder().setTransports(["websocket"]).build());
    socket.onConnectError((data) => print("onConnectError:$data"));
    socket.onConnecting((data) => print("connecting..."));

    socket.onConnect((_) {
      print('connected');
    });

    socket.onDisconnect((data) => print("onDisconnect:$data"));
  }

  @override
  Future<void> fetchChannelById() async {
    print("fetchChannelById...");
  }

  @override
  Future<void> listenToChannel(Function(AmittyMessage) callback) async {
    print("listenToChannelById...");
    socket.on('message.didCreate', (data) async {
      var messageObj = await AmittyMessage.fromJson(data);

      callback(messageObj);
    });
  }

  @override
  Future<void> reactMessage(String messageId) async {
    print("reactMessage...");
  }

  @override
  Future<void> sendImageMessage() async {
    print("sendImageMessage...");
  }

  @override
  Future<void> sendTextMessage() async {
    print("sendTextMessage...");
  }
}
