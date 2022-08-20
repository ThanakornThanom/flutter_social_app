import 'dart:convert';

import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:verbose_share_world/provider/model/amity_channel_model.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/provider/model/amity_response_model.dart';
import 'package:verbose_share_world/repository/chat_repo.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class AmityChatRepoImp implements AmityChatRepo {
  late Socket socket;

  @override
  Future<void> initRepo(String accessToken) async {
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
      Function(AmityMessage? data, String? error) callback) async {
    print("fetchChannelById...");
    socket.emitWithAck('v3/message.query', {
      "channelId": "$channelId",
      "options": {
        "last": 100,
      }
    }, ack: (data) {
      var amityResponse = AmityResponse.fromJson(data);
      var responsedata = amityResponse.data;
      if (amityResponse.status == "success") {
        //success
        var amityMessages = AmityMessage.fromJson(responsedata!.json!);

        callback(amityMessages, null);
      } else {
        //error
        callback(null, amityResponse.message);
      }
    });
  }

  @override
  Future<void> listenToChannel(Function(AmityMessage) callback) async {
    print("listenToChannelById...");
    socket.on('message.didCreate', (data) async {
      var messageObj = await AmityMessage.fromJson(data);

      callback(messageObj);
    });
  }

  @override
  Future<void> reactMessage(String messageId) async {
    print("reactMessage...");
  }

  @override
  Future<void> sendImageMessage(String channelId, String text,
      Function(AmityMessage?, String?) callback) async {
    print("sendImageMessage...");
  }

  @override
  Future<void> sendTextMessage(String channelId, String text,
      Function(AmityMessage?, String?) callback) async {
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
        var amityMessages = AmityMessage.fromJson(responsedata.json!);

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

  @override
  Future<void> fetchChannels(
      Function(ChannelList? data, String? error) callback) async {
    print("fetchChannels...");
    socket.emitWithAck('v3/channel.query', {
      "filter": "member",
      "options": {
        "limit": 100,
      }
    }, ack: (data) {
      var amityResponse = AmityResponse.fromJson(data);
      var responsedata = amityResponse.data;
      if (amityResponse.status == "success") {
        //success
        var amityChannels = ChannelList.fromJson(responsedata!.json!);
        print("check amity channel list imp ${amityChannels}");
        callback(amityChannels, null);
      } else {
        //error
        callback(null, amityResponse.message);
      }
    });
  }

  @override
  Future<void> listenToChannelList(Function(ChannelList) callback) async {
    print("listenToChannelListUpdate...");
    socket.on('channel.update', (data) async {
      var channelObj = await ChannelList.fromJson(data);

      callback(channelObj);
    });
  }
}
