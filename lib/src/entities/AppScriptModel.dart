class AppScriptModel {

  AppScriptModel.fromJson(dynamic json) {
    scriptId = json['script_id'];
    url = json['url'];
    status = json['status'];
    appName = json['app_name'];
    version = json['version'];
    storeUuid = json['store_uuid'];
    storeUrl = json['store_url'];
  }
  int? scriptId;
  String? url;
  int? status;
  String? appName;
  String? version;
  String? storeUuid;
  String? storeUrl;

}