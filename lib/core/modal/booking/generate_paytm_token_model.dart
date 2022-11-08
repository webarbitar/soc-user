class GeneratePaytmTokenModel {
  Head head;
  Body body;
  String orderId;

  GeneratePaytmTokenModel.fromJson(Map<String, dynamic> json)
      : head = Head.fromJson(json['head']),
        body = Body.fromJson(json['body']),
        orderId = json['order_id'];
}

class Head {
  String responseTimestamp;
  String version;
  String signature;

  Head.fromJson(Map<String, dynamic> json)
      : responseTimestamp = json['responseTimestamp'],
        version = json['version'],
        signature = json['signature'];
}

class Body {
  ResultInfo resultInfo;
  String txnToken;
  bool isPromoCodeValid;
  bool authenticated;

  Body.fromJson(Map<String, dynamic> json)
      : resultInfo = ResultInfo.fromJson(json['resultInfo']),
        txnToken = json['txnToken'],
        isPromoCodeValid = json['isPromoCodeValid'],
        authenticated = json['authenticated'];
}

class ResultInfo {
  String resultStatus;
  String resultCode;
  String resultMsg;

  ResultInfo.fromJson(Map<String, dynamic> json)
      : resultStatus = json['resultStatus'],
        resultCode = json['resultCode'],
        resultMsg = json['resultMsg'];
}
