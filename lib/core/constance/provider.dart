import 'package:flutter/material.dart';

import '../modal/imagedata.dart';
import '../modal/stringdata.dart';
import 'strings.dart';


List<ProviderData> provider = [
  ProviderData(
      id: "1",
      name: [StringData(code: "en", text: "Happy House")],
      address: "69 Hazelwood Avenue, Morden London, United Kingdom, SM4 5RS",
      descTitle: [StringData(code: "en", text: "About us")],
      desc: [
        StringData(
            code: "en",
            text:
                "The Happy House Cleaning Services offers professional cleaning services to make your home or apartment look its very best. From cleaning sinks, baths and tiles to polishing windows, our cleaners have the expertise to deal with every cleaning challenge.")
      ],
      phone: "020 7101 4326",
      workTime: [
        WorkTimeData(id: 0, weekend: false),
        WorkTimeData(id: 1, weekend: false),
        WorkTimeData(id: 2, weekend: false),
        WorkTimeData(id: 3, weekend: false),
        WorkTimeData(id: 4, weekend: false),
        WorkTimeData(id: 5, weekend: false),
        WorkTimeData(id: 6, weekend: true)
      ],
      www: "https://www.housejoy.in/mumbai/home-cleaning-services",
      instagram: "https://www.instagram.com/happy_house65/",
      login: "provider1@ondemand.com",
      logoServerPath:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Fdd5f0372-0ff1-45ac-ac69-84e5ede66e36.jpg?alt=media&token=ac5a08d3-7d4c-4668-b6ac-c011e65eb2ff",
      imageUpperServerPath:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Ff1cbca8f-69f7-4489-b0c1-1764bd4d9e2b.jpg?alt=media&token=c8cd7e43-48cb-46f7-837b-3c0c11d71093",
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Fe43999d9-ca18-485f-97d0-6363b7a25232.jpg?alt=media&token=dc79688b-9479-4520-906f-803a2def5604"),
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Fdb12f975-c0b5-476b-a50b-d305f0bbc433.jpg?alt=media&token=c55869b0-6cbd-48fd-ad00-c4d2c3a3e907"),
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2F5453d914-4320-47be-b168-fcc9bc3b1fa6.jpg?alt=media&token=cc739648-bfa1-4642-8992-4b01a16c7ce0"),
      ]),
  ProviderData(
      id: "2",
      name: [StringData(code: "en", text: "Cleaning Services London")],
      address: "Hello Services Ltd 119 Richmond Road Kingston Upon Thames KT2 5BX",
      descTitle: [StringData(code: "en", text: "About us")],
      desc: [
        StringData(
            code: "en",
            text:
                "Hello Services is a fully accredited company. We provide our customers with a vast range of high-quality Home services that meet their requirements.")
      ],
      phone: "02036334555",
      workTime: [
        WorkTimeData(id: 0, weekend: false),
        WorkTimeData(id: 1, weekend: false),
        WorkTimeData(id: 2, weekend: false),
        WorkTimeData(id: 3, weekend: false),
        WorkTimeData(id: 4, weekend: false),
        WorkTimeData(id: 5, weekend: true),
        WorkTimeData(id: 6, weekend: true)
      ],
      www: "https://www.housejoy.in/mumbai/home-cleaning-services",
      instagram: "https://www.instagram.com/happy_house65/",
      login: "provider2@ondemand.com",
      logoServerPath:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2F526eaff3-1d0c-478d-aa9b-5dcfcdb75034.jpg?alt=media&token=05e4efbb-a614-4144-b5c0-7e75bf235448",
      imageUpperServerPath:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Fcd53b232-e276-4cfc-abdc-dd9864dc3c95.jpg?alt=media&token=f3e131ed-870c-4e7c-bd4f-5822cfcb9104",
      unavailable: true,
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Fe43999d9-ca18-485f-97d0-6363b7a25232.jpg?alt=media&token=dc79688b-9479-4520-906f-803a2def5604"),
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Fdb12f975-c0b5-476b-a50b-d305f0bbc433.jpg?alt=media&token=c55869b0-6cbd-48fd-ad00-c4d2c3a3e907"),
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2F5453d914-4320-47be-b168-fcc9bc3b1fa6.jpg?alt=media&token=cc739648-bfa1-4642-8992-4b01a16c7ce0"),
      ]),
  ProviderData(
      id: "3",
      name: [StringData(code: "en", text: "Pindah Rumah")],
      address: "Hello Services Ltd 119 Richmond Road Kingston Upon Thames KT2 5BX",
      descTitle: [StringData(code: "en", text: "About us")],
      desc: [
        StringData(
            code: "en",
            text:
                "blow LTD is the UK’s leading on demand beauty business. We are a business designed by women, for women, so we know exactly how to make your lives a little bit easier with beauty services delivered at a time and place that suits you. All booked through our easy, award-winning app.")
      ],
      phone: "02036334555",
      workTime: [
        WorkTimeData(id: 0, weekend: false),
        WorkTimeData(id: 1, weekend: false),
        WorkTimeData(id: 2, weekend: false),
        WorkTimeData(id: 3, weekend: true),
        WorkTimeData(id: 4, weekend: false),
        WorkTimeData(id: 5, weekend: false),
        WorkTimeData(id: 6, weekend: false)
      ],
      www: "https://www.housejoy.in/mumbai/home-cleaning-services",
      instagram: "https://www.instagram.com/happy_house65/",
      login: "provider3@ondemand.com",
      logoServerPath:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2F027c27b1-92df-4831-804a-6043861e0ed1.jpg?alt=media&token=5243d878-dd36-4e79-af29-552337f90a0b",
      imageUpperServerPath:
          "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2F20e32907-2328-4078-81ec-0c62aa92dbda.jpg?alt=media&token=a75d168d-7a97-4178-a8ba-7960bafe6127",
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Fe43999d9-ca18-485f-97d0-6363b7a25232.jpg?alt=media&token=dc79688b-9479-4520-906f-803a2def5604"),
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2Fdb12f975-c0b5-476b-a50b-d305f0bbc433.jpg?alt=media&token=c55869b0-6cbd-48fd-ad00-c4d2c3a3e907"),
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/provider%2F5453d914-4320-47be-b168-fcc9bc3b1fa6.jpg?alt=media&token=cc739648-bfa1-4642-8992-4b01a16c7ce0"),
      ]),
];

class ProviderData {
  String id;
  List<StringData> name;
  String phone;
  String www;
  String instagram;
  String telegram;
  List<StringData> desc;
  List<StringData> descTitle;
  String address;
  //String avatar;
  bool visible;
  int unread = 0;
  int all = 0;
  String login;
  String lastMessage = "";
  DateTime lastMessageTime = DateTime.now();
  String chatId = "";

  String imageUpperServerPath = "";
  String imageUpperLocalFile = "";
  String logoServerPath = "";
  String logoLocalFile = "";
  List<ImageData> gallery = [];
  //
  List<WorkTimeData> workTime = [];
  List<String> category = [];
  //
  bool select = false;
  final dataKey = new GlobalKey();

  bool favorite = true;
  bool unavailable;
  var key = GlobalKey();

  ProviderData(
      {this.id = "",
      this.name = const [],
      this.visible = true,
      this.address = "",
      this.desc = const [],
      this.phone = "",
      this.www = "",
      this.instagram = "",
      this.telegram = "",
      this.descTitle = const [],
      this.imageUpperServerPath = "",
      this.imageUpperLocalFile = "",
      this.logoServerPath = "",
      this.logoLocalFile = "",
      this.gallery = const [],
      this.workTime = const [],
      this.category = const [], //this.avatar = ""
      this.login = "",
      this.unavailable = false});

  factory ProviderData.createEmpty() {
    return ProviderData(
      descTitle: [StringData(code: "en", text: strings.get(73))],
    ); // "Description",
  }

  Map<String, dynamic> toJson() => {
        'name': name.map((i) => i.toJson()).toList(),
        'phone': phone,
        'www': www,
        'instagram': instagram,
        'telegram': telegram,
        'desc': desc.map((i) => i.toJson()).toList(),
        'descTitle': descTitle.map((i) => i.toJson()).toList(),
        'address': address,
        'visible': visible,
        'imageUpperServerPath': imageUpperServerPath,
        'imageUpperLocalFile': imageUpperLocalFile,
        'logoServerPath': logoServerPath,
        'logoLocalFile': logoLocalFile,
        'gallery': gallery.map((i) => i.toJson()).toList(),
        'workTime': workTime.map((i) => i.toJson()).toList(),
        'category': category,
        "login": login
      };

  factory ProviderData.fromJson(String id, Map<String, dynamic> data) {
    List<String> _category = [];
    if (data['category'] != null)
      List.from(data['category']).forEach((element) {
        _category.add(element);
      });
    List<ImageData> _gallery = [];
    if (data['gallery'] != null)
      List.from(data['gallery']).forEach((element) {
        _gallery.add(ImageData(serverPath: element["serverPath"], localFile: element["localFile"]));
      });
    //
    List<WorkTimeData> _workTime = [];
    if (data['workTime'] != null)
      List.from(data['workTime']).forEach((element) {
        _workTime.add(WorkTimeData.fromJson(element));
      });
    //
    List<StringData> _name = [];
    if (data['name'] != null)
      List.from(data['name']).forEach((element) {
        _name.add(StringData.fromJson(element));
      });
    List<StringData> _desc = [];
    if (data['desc'] != null)
      List.from(data['desc']).forEach((element) {
        _desc.add(StringData.fromJson(element));
      });
    List<StringData> _descTitle = [];
    if (data['descTitle'] != null)
      List.from(data['descTitle']).forEach((element) {
        _descTitle.add(StringData.fromJson(element));
      });
    return ProviderData(
      id: id,
      name: _name,
      phone: (data["phone"] != null) ? data["phone"] : "",
      www: (data["www"] != null) ? data["www"] : "",
      instagram: (data["instagram"] != null) ? data["instagram"] : "",
      telegram: (data["telegram"] != null) ? data["telegram"] : "",
      desc: _desc,
      descTitle: _descTitle,
      address: (data["address"] != null) ? data["address"] : "",
      visible: (data["visible"] != null) ? data["visible"] : true,
      imageUpperServerPath:
          (data["imageUpperServerPath"] != null) ? data["imageUpperServerPath"] : "",
      imageUpperLocalFile: (data["imageUpperLocalFile"] != null) ? data["imageUpperLocalFile"] : "",
      logoServerPath: (data["logoServerPath"] != null) ? data["logoServerPath"] : "",
      logoLocalFile: (data["logoLocalFile"] != null) ? data["logoLocalFile"] : "",
      gallery: _gallery,
      workTime: _workTime,
      category: _category,
      //avatar: (data["avatar"] != null) ? data["avatar"] : "",
      login: (data["login"] != null) ? data["login"] : "",
    );
  }
}

/*
  id = 0 - Monday
       1 - Tuesday
       2 - Wednesday
       3 - Thursday
       4 - Friday
       5 - Saturday
       6 - Sunday
 */

class WorkTimeData {
  int id = 0;
  bool weekend = false;
  String openTime = "";
  String closeTime = "";

  WorkTimeData(
      {this.id = 0, this.openTime = "09:00", this.closeTime = "16:00", this.weekend = false});

  Map<String, dynamic> toJson() => {
        'index': id,
        'openTime': openTime,
        'closeTime': closeTime,
        'weekend': weekend,
      };

  factory WorkTimeData.fromJson(Map<String, dynamic> data) {
    return WorkTimeData(
      id: (data["index"] != null) ? data["index"] : 0,
      openTime: (data["openTime"] != null) ? data["openTime"] : "9:00",
      closeTime: (data["closeTime"] != null) ? data["closeTime"] : "16:00",
      weekend: (data["weekend"] != null) ? data["weekend"] : false,
    );
  }

  factory WorkTimeData.createEmpty() {
    return WorkTimeData();
  }
}
