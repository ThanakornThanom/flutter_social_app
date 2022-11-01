import 'package:dio/dio.dart';
import 'package:verbose_share_world/model/version_model.dart';
import 'package:verbose_share_world/repository/version_repo.dart';

class VersionRepoImp implements VersionRepo {
  @override
  Future<VersionModel?> getVersion() async {
    var dio = Dio();
    final response = await dio.get(
      "https://p64ea4glic.execute-api.ap-southeast-1.amazonaws.com/test/version",
    );

    if (response.statusCode == 200) {
      print("getVersion success");

      var appVersion = await VersionModel.fromJson(response.data["data"]);

      return appVersion;
    } else {
      print("getVersion fail");
      return null;
    }
  }
}
