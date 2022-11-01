class VersionModel {
  String? version;
  String? downloadUrl;

  VersionModel({this.version, this.downloadUrl});

  VersionModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    downloadUrl = json['downloadUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['downloadUrl'] = this.downloadUrl;
    return data;
  }
}
