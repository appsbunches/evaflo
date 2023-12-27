import '../.env.dart';

import '../app_config.dart';

class PageModel {
  int? id;
  String? url;
  String? title;
  String? content;
  String? contentWithoutTags;
  String? sEOPageDescription;
  String? facebook;
  String? tiktok;
  String? twitter;
  String? instagram;
  String? snapchat;
  String? maroof;
  String? website;
  String? phone;
  String? email;
  bool? isSystemPage;
  bool? enabled;
  String? name;
  String? slug;

  PageModel(this.id,this.title, this.content);

  PageModel.  fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    content = json['content'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    tiktok = json['tiktok'];
    snapchat = json['snapchat'];
    maroof = json['maroof'];
    website = json['website'];
    phone = json['phone'];
    email = json['email'];
    isSystemPage = json['is_system_page'];
    enabled = json['enabled'];
    name = json['name'];
    slug = json['slug'];

    sEOPageDescription = json['SEO_page_description'];
    content = content?.replaceAll('style="padding-top: 130px; flex-grow: 1 !important;"', '');
    content = content?.replaceAll('<br><br></p><p', '<br></div> <p');
    content = content?.replaceAll('<br><br></div>', '<br></div> <p');
    content = content?.replaceAll('line-height:\\n115%;', '');
    content = content?.replaceAll('<br><br></p><p', '<br></div> <p');
    content = content?.replaceAll('<br><br></div>', '<br></div> <p');
    content = content?.replaceAll('Times New Roman', AppConfig.fontName);
    content = content?.replaceAll('span', 'p');
    content = content?.replaceAll('font-size: 0.8em', 'font-size: 18px; text-align: center;');
    content = content?.replaceAll('color: rgb(255, 255, 255); display: block;', 'font-size: 24px; font-weight: 100; text-align: center; color: rgb(255, 255, 255); display: block; ');
    content = content?.replaceAll('\"><font color=\"#ffffff', 'margin-bottom: 0px; font-family: Cairo, sans-serif; font-size: 24px; text-align: center; color: rgb(255, 255, 255); display: block; padding: 0.5em 1em; background-color: rgb(74, 144, 74); border-radius: 0.25em;');

    if(storeId == '26858'){
      content = content?.replaceAll('span', 'p');
      content = content?.replaceAll('font-size: 0.8em', 'font-size: 18px; text-align: center;');
      content = content?.replaceAll('color: rgb(255, 255, 255); display: block;', 'font-size: 24px; font-weight: 100; text-align: center; color: rgb(255, 255, 255); display: block; ');
      content = content?.replaceAll('color: rgb(255, 255, 255); max-width: 50%; display: block; padding: 0.5em 1em; background-color: rgb(225, 156, 61);', 'font-size: 24px; font-weight: 100; text-align: center; color: rgb(255, 255, 255); display: block; padding: 0.5em 1em; background-color: rgb(225, 156, 61); max-width: 50%; border-radius: 0.25em;');
      content = content?.replaceAll('\"><font color=\"#ffffff', 'margin-bottom: 0px; font-family: Cairo, sans-serif; font-size: 24px; text-align: center; color: rgb(255, 255, 255); display: block; padding: 0.5em 1em; background-color: rgb(74, 144, 74); border-radius: 0.25em;');
    }
    content = content?.replaceAll('dir=', '');
    content = content?.replaceAll('Arial', 'CairoArabic');
    content = content?.replaceAll('Tahoma', 'CairoArabic');
    content = content?.replaceAll('src="//www', 'src="https://www');

    sEOPageDescription = sEOPageDescription?.replaceAll('Times New Roman', AppConfig.fontName);
    sEOPageDescription = sEOPageDescription?.replaceAll('Arial', 'CairoArabic');
    sEOPageDescription = sEOPageDescription?.replaceAll('Tahoma', 'CairoArabic');
  }

  @override
  String toString() {
    return 'PageModel{id: $id, url: $url, title: $title, content: $content, contentWithoutTags: $contentWithoutTags, sEOPageDescription: $sEOPageDescription, facebook: $facebook, tiktok: $tiktok, twitter: $twitter, instagram: $instagram, snapchat: $snapchat, maroof: $maroof, website: $website, phone: $phone, email: $email, isSystemPage: $isSystemPage, enabled: $enabled, name: $name, slug: $slug}';
  }
}