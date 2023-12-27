class ColorsModel {

  ColorsModel.fromJson(dynamic json) {
    logo = json['logo'];
    topbarSidebarIcon = json['topbar_sidebar_icon'];
    topbarSearchIcon = json['topbar_search_icon'];
    topbarBackgroundColor = json['topbar_background_color'];
    topbarIconColor = json['topbar_icon_color'];
    categoryTextColor = json['category_text_color'];
    categoryBackgroundColor = json['category_background_color'];
    applicationtapsBackgroundColor = json['applicationtaps_background_color'];
    selectedIconColor = json['selected_icon_color'];
    notSelectedIconColor = json['not_selected_icon_color'];
    buttonColor = json['button_color'];
    buttonTextColor = json['button_text_color'];
  }
  String? logo;
  int? topbarSidebarIcon;
  int? topbarSearchIcon;
  String? topbarBackgroundColor;
  String? topbarIconColor;
  String? categoryTextColor;
  String? categoryBackgroundColor;
  String? applicationtapsBackgroundColor;
  String? selectedIconColor;
  String? notSelectedIconColor;
  String? buttonColor;
  String? buttonTextColor;


}