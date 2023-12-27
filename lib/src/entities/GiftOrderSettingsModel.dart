class GiftOrderSettingsModel {
  GiftOrderSettingsModel({
      this.isGiftOrderEnabled, 
      this.isGiftOrderCardSenderCustomMessageEnabled, 
      this.isGiftOrderCustomerMotivationEnabled, 
      this.isGiftOrderCardSenderCustomMediaLinkEnabled, 
      this.isGiftOrderCardCustomTemplateEnabled, 
      this.giftOrderCardCustomTemplateDesign, 
      this.giftOrderMessageWhenReady, 
      this.giftOrderMessageWhenCompleted,});

  GiftOrderSettingsModel.fromJson(dynamic json) {
    isGiftOrderEnabled = json['is_gift_order_enabled'];
    isGiftOrderCardSenderCustomMessageEnabled = json['is_gift_order_card_sender_custom_message_enabled'];
    isGiftOrderCustomerMotivationEnabled = json['is_gift_order_customer_motivation_enabled'];
    isGiftOrderCardSenderCustomMediaLinkEnabled = json['is_gift_order_card_sender_custom_media_link_enabled'];
    isGiftOrderCardCustomTemplateEnabled = json['is_gift_order_card_custom_template_enabled'];
    giftOrderCardCustomTemplateDesign = json['gift_order_card_custom_template_design'];
    giftOrderMessageWhenReady = json['gift_order_message_when_ready'];
    giftOrderMessageWhenCompleted = json['gift_order_message_when_completed'];
  }
  String? isGiftOrderEnabled;
  String? isGiftOrderCardSenderCustomMessageEnabled;
  String? isGiftOrderCustomerMotivationEnabled;
  String? isGiftOrderCardSenderCustomMediaLinkEnabled;
  String? isGiftOrderCardCustomTemplateEnabled;
  String? giftOrderCardCustomTemplateDesign;
  String? giftOrderMessageWhenReady;
  String? giftOrderMessageWhenCompleted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_gift_order_enabled'] = isGiftOrderEnabled;
    map['is_gift_order_card_sender_custom_message_enabled'] = isGiftOrderCardSenderCustomMessageEnabled;
    map['is_gift_order_customer_motivation_enabled'] = isGiftOrderCustomerMotivationEnabled;
    map['is_gift_order_card_sender_custom_media_link_enabled'] = isGiftOrderCardSenderCustomMediaLinkEnabled;
    map['is_gift_order_card_custom_template_enabled'] = isGiftOrderCardCustomTemplateEnabled;
    map['gift_order_card_custom_template_design'] = giftOrderCardCustomTemplateDesign;
    map['gift_order_message_when_ready'] = giftOrderMessageWhenReady;
    map['gift_order_message_when_completed'] = giftOrderMessageWhenCompleted;
    return map;
  }

}