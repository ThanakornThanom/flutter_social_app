import '../provider/model/amity_channel_model.dart';
import '../provider/model/amity_message_model.dart';

class AmityChatRepo {
  Future<void> initRepo(String accessToken) async {}

  Future<void> listenToChannel(Function(AmityMessage) callback) async {}

  Future<void> fetchChannelById(
      String channelId, Function(AmityMessage?, String?) callback) async {}

  Future<void> sendTextMessage(String channelId, String text,
      Function(AmittyMessage?, String?) callback) async {}

  Future<void> sendImageMessage(String channelId, String text,
      Function(AmittyMessage?, String?) callback) async {}

  Future<void> reactMessage(String messageId) async {}
}
