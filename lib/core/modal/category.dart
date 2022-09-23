import 'package:flutter/material.dart';

import '../../ui/shared/messenger/util.dart';
import 'stringdata.dart';

List<CategoryData> category = [
  CategoryData(
      id: "1",
      name: [StringData(code: "en", text: "Carpenter")],
      localFile: "",
      serverPath: "assets/carpenter.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
  CategoryData(
      id: "2",
      name: [StringData(code: "en", text: "Movers")],
      localFile: "",
      serverPath: "assets/movers.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
  CategoryData(
      id: "3",
      name: [StringData(code: "en", text: "Painter")],
      localFile: "",
      serverPath: "assets/painter.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
  CategoryData(
      id: "4",
      name: [StringData(code: "en", text: "Plumbers")],
      localFile: "",
      serverPath: "assets/plumbers.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
  CategoryData(
      id: "5",
      name: [StringData(code: "en", text: "Home sanitize")],
      localFile: "",
      serverPath: "assets/ster.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
  CategoryData(
      id: "6",
      name: [StringData(code: "en", text: "Gardening")],
      localFile: "",
      serverPath: "assets/gardening.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
  CategoryData(
      id: "7",
      name: [StringData(code: "en", text: "Electrician")],
      localFile: "",
      serverPath: "assets/electrician.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
  CategoryData(
      id: "8",
      name: [StringData(code: "en", text: "Hair & beauty")],
      localFile: "",
      serverPath: "assets/hair.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
  CategoryData(
      id: "9",
      name: [StringData(code: "en", text: "Home Clean")],
      localFile: "",
      serverPath: "assets/clean.jpg",
      color: Colors.black,
      parent: "",
      visible: true,
      visibleCategoryDetails: true,
      desc: []),
];

class CategoryData {
  String id;
  List<StringData> name;
  List<StringData> desc;
  bool visible;
  bool visibleCategoryDetails;

  String localFile = "";
  String serverPath = "";

  Color color;
  String parent;
  bool select = false;
  final dataKey = new GlobalKey();
  final dataKey2 = new GlobalKey();

  CategoryData(
      {required this.id,
      required this.name,
      required this.localFile,
      required this.serverPath,
      required this.color,
      required this.parent,
      required this.visible,
      required this.visibleCategoryDetails,
      required this.desc});

  factory CategoryData.createEmpty() {
    return CategoryData(
        id: "",
        name: [],
        localFile: "",
        serverPath: "",
        color: Colors.green,
        parent: "",
        visible: true,
        visibleCategoryDetails: true,
        desc: []);
  }

  Map<String, dynamic> toJson() => {
        'name': name.map((i) => i.toJson()).toList(),
        'desc': desc.map((i) => i.toJson()).toList(),
        'visible': visible,
        'visibleCategoryDetails': visibleCategoryDetails,
        'localFile': localFile,
        'serverPath': serverPath,
        'color': color.value.toString(),
        'parent': parent
      };

  factory CategoryData.fromJson(String id, Map<String, dynamic> data) {
    List<StringData> _name = [];
    if (data['name'] != null) {
      List.from(data['name']).forEach((element) {
        _name.add(StringData.fromJson(element));
      });
    }
    List<StringData> _desc = [];
    if (data['desc'] != null) {
      List.from(data['desc']).forEach((element) {
        _desc.add(StringData.fromJson(element));
      });
    }
    return CategoryData(
      id: id,
      name: _name,
      localFile: (data["localFile"] != null) ? data["localFile"] : "",
      serverPath: (data["serverPath"] != null) ? data["serverPath"] : "",
      color: (data["color"] != null) ? toColor(data["color"]) : Colors.red,
      parent: (data["parent"] != null) ? data["parent"] : "",
      visible: (data["visible"] != null) ? data["visible"] : true,
      visibleCategoryDetails:
          (data["visibleCategoryDetails"] != null) ? data["visibleCategoryDetails"] : true,
      desc: _desc,
    );
  }
}
