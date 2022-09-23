class ImageData {
  String serverPath = "";
  String localFile = "";

  ImageData({this.serverPath = "", this.localFile = ""});

  Map<String, dynamic> toJson() => {
        'serverPath': serverPath,
        'localFile': localFile,
      };

  factory ImageData.fromJson(Map<String, dynamic> data) {
    return ImageData(
      serverPath: (data["serverPath"] != null) ? data["serverPath"] : "",
      localFile: (data["localFile"] != null) ? data["localFile"] : "",
    );
  }

  factory ImageData.createEmpty() {
    return ImageData();
  }
}
