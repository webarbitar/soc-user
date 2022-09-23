import 'package:flutter/material.dart';
import '../../ui/shared/messenger/util.dart';
import 'imagedata.dart';
import 'stringdata.dart';

List<ServiceData> service1 = [
  ServiceData("1", [StringData(code: "en", text: "Happy House Home clean")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "Base price")], 20, 15, "hourly", ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2Ff6af3a69-9c94-479e-8c69-1b5b24726a5f.jpg?alt=media&token=0f11f05c-7c7a-41be-a2e6-4d2492ccbc94")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("3", [StringData(code: "en", text: "Metering Services")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "Metering Services")], 25, 0, "hourly", ImageData())
      ],
      unavailable: true,
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2Ff1dc74d1-7134-4a9f-9618-27b39072c4f6.jpg?alt=media&token=b84fe887-7107-4412-8cc2-650a821e777e")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("2", [StringData(code: "en", text: "WATER HEATER MAINTENANCE")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "WATER HEATER MAINTENANCE")], 25, 0, "hourly",
            ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F3879f5e8-d91b-472d-a46c-75d685c0a3d5.jpg?alt=media&token=aeddd4ad-268d-4713-b3e2-eda590d4f057")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("4", [StringData(code: "en", text: "WATER HEATER MAINTENANCE")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "WATER HEATER MAINTENANCE")], 25, 0, "hourly",
            ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F3879f5e8-d91b-472d-a46c-75d685c0a3d5.jpg?alt=media&token=aeddd4ad-268d-4713-b3e2-eda590d4f057")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("5", [StringData(code: "en", text: "Happy House Home clean")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "Base price")], 20, 15, "hourly", ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2Ff6af3a69-9c94-479e-8c69-1b5b24726a5f.jpg?alt=media&token=0f11f05c-7c7a-41be-a2e6-4d2492ccbc94")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
];

List<ServiceData> service2 = [
  ServiceData("6", [StringData(code: "en", text: "Tree Surgery")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "Small tree")], 20, 15, "hourly", ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F86a95b57-f13d-403d-b892-7ad91b0abd27.jpg?alt=media&token=4872d835-e7e9-4e9c-b649-740ec59f2c48")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("7", [StringData(code: "en", text: "Heavy Furniture & Specialty Moves")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "One mover")], 25, 0, "hourly", ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F9489e7a1-3cdf-4c25-a26d-136c725067fc.jpg?alt=media&token=c51f9ef1-4b63-4796-8097-191de64cef81")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("8", [StringData(code: "en", text: "KERASTASE UPDO + MAKEUP")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "MakeUp")], 25, 0, "hourly", ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F4d0d4e11-aa39-474f-9856-f2475a1f289f.jpg?alt=media&token=5a9767e9-622b-4332-b2ea-d5987bac2d9e")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("9", [StringData(code: "en", text: "Tree Surgery")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "Small tree")], 20, 15, "hourly", ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F86a95b57-f13d-403d-b892-7ad91b0abd27.jpg?alt=media&token=4872d835-e7e9-4e9c-b649-740ec59f2c48")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("10", [StringData(code: "en", text: "Heavy Furniture & Specialty Moves")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "One mover")], 25, 0, "hourly", ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F9489e7a1-3cdf-4c25-a26d-136c725067fc.jpg?alt=media&token=c51f9ef1-4b63-4796-8097-191de64cef81")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
];

List<ServiceData> service3 = [
  ServiceData("8", [StringData(code: "en", text: "KERASTASE UPDO + MAKEUP")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "MakeUp")], 25, 0, "hourly", ImageData())
      ],
      unavailable: true,
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F4d0d4e11-aa39-474f-9856-f2475a1f289f.jpg?alt=media&token=5a9767e9-622b-4332-b2ea-d5987bac2d9e")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("4", [StringData(code: "en", text: "WATER HEATER MAINTENANCE")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "WATER HEATER MAINTENANCE")], 25, 0, "hourly",
            ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2F3879f5e8-d91b-472d-a46c-75d685c0a3d5.jpg?alt=media&token=aeddd4ad-268d-4713-b3e2-eda590d4f057")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
  ServiceData("5", [StringData(code: "en", text: "Happy House Home clean")],
      desc: [StringData()],
      descTitle: [StringData()],
      tax: 10,
      taxAdmin: 0,
      visible: true,
      price: [
        PriceData([StringData(code: "en", text: "Base price")], 20, 15, "hourly", ImageData())
      ],
      gallery: [
        ImageData(
            serverPath:
                "https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/service%2Ff6af3a69-9c94-479e-8c69-1b5b24726a5f.jpg?alt=media&token=0f11f05c-7c7a-41be-a2e6-4d2492ccbc94")
      ],
      duration: const Duration(),
      category: [],
      providers: []),
];

class ServiceData {
  String id;
  List<StringData> name;
  List<StringData> descTitle;
  List<StringData> desc;
  double tax;
  double taxAdmin;
  bool visible;
  List<PriceData> price;
  List<ImageData> gallery;
  Duration duration = const Duration();
  List<String> category;
  List<String> providers; // Id
  //
  bool select = false;
  final dataKey = new GlobalKey();

  //
  int rating1;
  int rating2;
  int rating3;
  int rating4;
  int rating5;
  int count = 0;
  double rating = 0;

  //
  bool favorite = true;
  String sale;
  bool unavailable;

  //
  int needCount = 1;

  ServiceData(this.id, this.name,
      {this.visible = true,
      required this.desc,
      required this.gallery,
      required this.descTitle,
      required this.price,
      required this.duration,
      required this.category,
      required this.providers,
      this.tax = 0,
      this.rating1 = 0,
      this.rating2 = 0,
      this.rating3 = 0,
      this.rating4 = 0,
      this.rating5 = 0,
      this.count = 0,
      this.rating = 0,
      this.taxAdmin = 0,
      this.sale = "",
      this.unavailable = false});

  factory ServiceData.createEmpty() {
    return ServiceData("", [],
        gallery: [],
        price: [],
        desc: [],
        descTitle: [],
        duration: const Duration(),
        category: [],
        providers: []);
  }

  Map<String, dynamic> toJson() => {
        'name': name.map((i) => i.toJson()).toList(),
        'tax': tax,
        'descTitle': descTitle.map((i) => i.toJson()).toList(),
        'desc': desc.map((i) => i.toJson()).toList(),
        'visible': visible,
        'price': price.map((i) => i.toJson()).toList(),
        'gallery': gallery.map((i) => i.toJson()).toList(),
        'duration': duration.inMilliseconds,
        'category': category,
        'providers': providers,
        'rating1': rating1,
        'rating2': rating2,
        'rating3': rating3,
        'rating4': rating4,
        'rating5': rating5,
        'taxAdmin': taxAdmin,
      };

  factory ServiceData.fromJson(String id, Map<String, dynamic> data) {
    List<StringData> _name = [];
    if (data['name'] != null)
      List.from(data['name']).forEach((element) {
        _name.add(StringData.fromJson(element));
      });
    List<StringData> _descTitle = [];
    if (data['descTitle'] != null)
      List.from(data['descTitle']).forEach((element) {
        _descTitle.add(StringData.fromJson(element));
      });
    List<StringData> _desc = [];
    if (data['desc'] != null)
      List.from(data['desc']).forEach((element) {
        _desc.add(StringData.fromJson(element));
      });
    List<PriceData> _price = [];
    if (data['price'] != null)
      List.from(data['price']).forEach((element) {
        _price.add(PriceData.fromJson(element));
      });
    List<ImageData> _gallery = [];
    if (data['gallery'] != null)
      List.from(data['gallery']).forEach((element) {
        _gallery.add(ImageData.fromJson(element));
      });
    List<String> _category = [];
    if (data['category'] != null)
      List.from(data['category']).forEach((element) {
        _category.add(element);
      });
    List<String> _providers = [];
    if (data['providers'] != null)
      List.from(data['providers']).forEach((element) {
        _providers.add(element);
      });
    var rating1 = (data["rating1"] != null) ? toInt(data["rating1"].toString()) : 0;
    var rating2 = (data["rating2"] != null) ? toInt(data["rating2"].toString()) : 0;
    var rating3 = (data["rating3"] != null) ? toInt(data["rating3"].toString()) : 0;
    var rating4 = (data["rating4"] != null) ? toInt(data["rating4"].toString()) : 0;
    var rating5 = (data["rating5"] != null) ? toInt(data["rating5"].toString()) : 0;
    var _count = rating1 + rating2 + rating3 + rating4 + rating5;
    double _rating = 0;
    if (_count != 0)
      _rating = (rating1 * 1 + rating2 * 2 + rating3 * 3 + rating4 * 4 + rating5 * 5) / _count;
    return ServiceData(
      id,
      _name,
      tax: (data["tax"] != null) ? toDouble(data["tax"].toString()) : 0,
      descTitle: _descTitle,
      desc: _desc,
      visible: (data["visible"] != null) ? data["visible"] : true,
      price: _price,
      gallery: _gallery,
      duration:
          (data["duration"] != null) ? Duration(milliseconds: data["duration"]) : const Duration(),
      category: _category,
      providers: _providers,
      rating1: rating1,
      rating2: rating2,
      rating3: rating3,
      rating4: rating4,
      rating5: rating5,
      count: _count,
      rating: _rating,
      taxAdmin: (data["taxAdmin"] != null) ? toDouble(data["taxAdmin"].toString()) : 0,
    );
  }

  //
  //
  //
  double getMinPrice() {
    double _min = double.maxFinite;
    for (var item in price) {
      if (item.discPrice == 0) {
        if (_min > item.price) _min = item.price;
      } else {
        if (_min > item.discPrice) _min = item.discPrice;
      }
    }
    if (_min == double.maxFinite) return _min;
    return _min;
  }
}

class PriceData {
  List<StringData> name;
  double price;
  double discPrice;
  String priceUnit; // "hourly" or "fixed"
  ImageData image;
  bool selected;

  PriceData(this.name, this.price, this.discPrice, this.priceUnit, this.image,
      {this.selected = false});

  factory PriceData.createEmpty() {
    return PriceData([], 0, 0, "hourly", ImageData());
  }

  Map<String, dynamic> toJson() => {
        'name': name.map((i) => i.toJson()).toList(),
        'price': price,
        'discPrice': discPrice,
        'priceUnit': priceUnit,
        'image': image.toJson(),
      };

  factory PriceData.fromJson(Map<String, dynamic> data) {
    List<StringData> _name = [];
    if (data['name'] != null)
      List.from(data['name']).forEach((element) {
        _name.add(StringData.fromJson(element));
      });
    var _image = ImageData();
    if (data['image'] != null) _image = ImageData.fromJson(data['image']);
    return PriceData(
      _name,
      (data["price"] != null) ? toDouble(data["price"].toString()) : 0,
      (data["discPrice"] != null) ? toDouble(data["discPrice"].toString()) : 0,
      (data["priceUnit"] != null) ? data["priceUnit"] : "",
      _image,
    );
  }

  double getPrice() {
    return discPrice != 0 ? discPrice : price;
  }

// String getPriceString(BuildContext context){
//   return Provider.of<MainModal>(context,listen:false).localAppSettings.
//       getPriceString(getPrice());
// }
}

class Addon {
  List<StringData> name;
  double price;
  bool selected;
  int needCount;

  Addon(this.name, this.price, {this.selected = false, this.needCount = 1});

  factory Addon.createEmpty() {
    return Addon([], 0);
  }

  Map<String, dynamic> toJson() => {
        'name': name.map((i) => i.toJson()).toList(),
        'price': price,
        'select': selected,
        'needCount': needCount
      };

  factory Addon.fromJson(Map<String, dynamic> data) {
    List<StringData> _name = [];
    if (data['name'] != null)
      List.from(data['name']).forEach((element) {
        _name.add(StringData.fromJson(element));
      });
    return Addon(
      _name,
      (data["price"] != null) ? toDouble(data["price"].toString()) : 0,
      selected: (data["selected"] != null) ? data["selected"] : false,
      needCount: (data["needCount"] != null) ? toInt(data["needCount"].toString()) : 1,
    );
  }
}
