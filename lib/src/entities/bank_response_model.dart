class BankResponseModel {
  int? id;
  String? accountNumber;
  String? iban;
  String? beneficiaryName;
  int? isVisible;
  Bank? bank;

  BankResponseModel(
      {this.id,
        this.accountNumber,
        this.iban,
        this.beneficiaryName,
        this.isVisible,
        this.bank});

  BankResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountNumber = json['account_number'];
    iban = json['iban'];
    beneficiaryName = json['beneficiary_name'];
    isVisible = json['is_visible'];
    bank = json['bank'] != null ? Bank.fromJson(json['bank']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['account_number'] = accountNumber;
    data['iban'] = iban;
    data['beneficiary_name'] = beneficiaryName;
    data['is_visible'] = isVisible;
    if (bank != null) {
      data['bank'] = bank!.toJson();
    }
    return data;
  }
}

class Bank {
  int? id;
  String? name;
  String? logo;

  Bank({this.id, this.name, this.logo});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    return data;
  }
}
