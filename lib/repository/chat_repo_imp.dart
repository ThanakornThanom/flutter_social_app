import 'dart:convert';

import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/provider/model/amity_response_model.dart';
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
  Future<void> fetchChannelById(String channelId,
      Function(AmittyMessage? data, String? error) callback) async {
    print("fetchChannelById...");
    socket.emitWithAck('v3/message.query', {"channelId": "$channelId"},
        ack: (data) {
      var amityResponse = AmityResponse.fromJson(data);
      var responsedata = amityResponse.data;
      if (amityResponse.status == "success") {
        //success
        var amityMessages = AmittyMessage.fromJson(responsedata!.json!);

        callback(amityMessages, null);
      } else {
        //error
        callback(null, amityResponse.message);
      }
    });
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
  Future<void> sendImageMessage(String channelId, String text,
      Function(AmittyMessage?, String?) callback) async {
    print("sendImageMessage...");
  }

  @override
  Future<void> sendTextMessage(String channelId, String text,
      Function(AmittyMessage?, String?) callback) async {
    print("sendTextMessage...");
    print("fetchChannelById...");
    socket.emitWithAck('v3/message.create', {
      "channelId": "$channelId",
      "type": "text",
      "data": {"text": "$text"}
    }, ack: (data) {
      var amityResponse = AmityResponse.fromJson(data);
      var responsedata = amityResponse.data;
      if (amityResponse.status == "success") {
        //success
        print(responsedata!.json);
        var amityMessages = AmittyMessage.fromJson(responsedata.json!);

        callback(amityMessages, null);
      } else {
        //error
        callback(null, amityResponse.message);
      }
    });
  }

  @override
  void disposeRepo() {
    socket.clearListeners();
    socket.close();
  }
}
