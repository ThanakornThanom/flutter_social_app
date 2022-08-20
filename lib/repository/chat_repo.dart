import '../provider/model/amity_message_model.dart';

class ChannelRepo {
  Future<void> initRepo(String accessToken, String channelId) async {}

  Future<void> listenToChannel(Function(AmittyMessage) callback) async {}

  Future<void> fetchChannelById(
      String channelId, Function(AmittyMessage?, String?) callback) async {}

  Future<void> sendTextMessage(String channelId, String text,
      Function(AmittyMessage?, String?) callback) async {}

  Future<void> sendImageMessage(String channelId, String text,
      Function(AmittyMessage?, String?) callback) async {}

  Future<void> reactMessage(String messageId) async {}

  void disposeRepo() {}
}
