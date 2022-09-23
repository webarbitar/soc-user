// v2

List<BannerData> banners = [
  BannerData(
      serverImage:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/banner%2F04effd17-99b3-4fef-a968-02bcae847768.jpg?alt=media&token=769dd3e5-4fe2-4176-874a-55bd0693136b"),
  BannerData(
      serverImage:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/banner%2F5b870247-16fa-4b12-8a77-229843afa152.jpg?alt=media&token=adcdb50c-ad51-4707-b9d9-cd0f3f91ae8c"),
  BannerData(
      serverImage:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/banner%2F5d61b29b-3ee5-4ced-839c-ff610320ea1d.jpg?alt=media&token=5e1f1fa4-3a0d-4583-95a4-44bd9eba22d8"),
];

class BannerData {
  String id;
  String name;
  String type;
  String open;
  bool visible;
  String localImage;
  String serverImage;

  BannerData(
      {this.id = "",
      this.name = "",
      this.type = "service",
      this.open = "",
      this.visible = true,
      this.localImage = "",
      this.serverImage = ""});

  factory BannerData.createEmpty() {
    return BannerData();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'open': open,
        'visible': visible,
        'localImage': localImage,
        'serverImage': serverImage,
      };

  factory BannerData.fromJson(String id, Map<String, dynamic> data) {
    return BannerData(
      id: id,
      name: (data["name"] != null) ? data["name"] : "",
      type: (data["type"] != null) ? data["type"] : "",
      open: (data["open"] != null) ? data["open"] : "",
      visible: (data["visible"] != null) ? data["visible"] : true,
      localImage: (data["localImage"] != null) ? data["localImage"] : "",
      serverImage: (data["serverImage"] != null) ? data["serverImage"] : "",
    );
  }
}
