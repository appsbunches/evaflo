class VoucherModel {

  VoucherModel.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    status = json['status'];
    order = json['order'];
    serialNumber = json['serial_number'];
    key = json['key'];
    pinCode = json['pin_code'];
    expiresAt = json['expires_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }
  String? id;
  String? productId;
  String? status;
  int? order;
  String? serialNumber;
  String? key;
  String? pinCode;
  String? expiresAt;
  String? updatedAt;
  String? createdAt;

}