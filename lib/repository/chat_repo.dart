import '../provider/model/amity_channel_model.dart';
import '../provider/model/amity_message_model.dart';

class AmityChatRepo {
  Future<void> initRepo(String accessToken) async {}

  Future<void> listenToChannel(Function(AmityMessage) callback) async {}

  Future<void> fetchChannelById(
      String channelId, Function(AmityMessage?, String?) callback) async {}

  Future<void> sendTextMessage() async {}

  Future<void> sendImageMessage() async {}

  Future<void> reactMessage(String messageId) async {}

  Future<void> fetchChannels(Function(ChannelList?, String?) callback) async {}

  Future<void> listenToChannelList(Function(ChannelList) callback) async {}
}
