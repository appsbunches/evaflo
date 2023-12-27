class GiftCardDetailsModel {
  GiftCardDetailsModel({
      this.mediaLink, 
      this.cardDesign, 
      this.senderName, 
      this.giftMessage, 
      this.receiverName,});

  GiftCardDetailsModel.fromJson(dynamic json) {
    mediaLink = json['media_link'];
    cardDesign = json['card_design'];
    senderName = json['sender_name'];
    giftMessage = json['gift_message'];
    receiverName = json['receiver_name'];
  }
  String? mediaLink;
  String? cardDesign;
  String? senderName;
  String? giftMessage;
  String? receiverName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['media_link'] = mediaLink;
    map['card_design'] = cardDesign;
    map['sender_name'] = senderName;
    map['gift_message'] = giftMessage;
    map['receiver_name'] = receiverName;
    return map;
  }

}