import '../provider/model/amity_message_model.dart';

class ChannelRepo {
  Future<void> initRepo(String accessToken, String channelId) async {}

  Future<void> listenToChannel(Function(AmittyMessage) callback) async {}

  Future<void> fetchChannelById(
      String channelId, Function(AmittyMessage?, String?) callback) async {}

  Future<void> sendTextMessage() async {}

  Future<void> sendImageMessage() async {}

  Future<void> reactMessage(String messageId) async {}
}
