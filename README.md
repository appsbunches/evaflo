# Zid Appsbunches App

## The steps to create Zid app:

* Download the latest code from Githab as a zip file.(appsbunches/entaj (github.com))
* Open the code and change the project name.
* In the .env file replace storeId + AUTHORIZATION_TOKEN + ACCESS_TOKEN.
* In the .env file replace appNameAr and appNameEn and storeUrl in 4 places.
* In the .env file replace appsBunchesUrl.
* In colors file replace primaryColor, you can get the color from the store.
* In the images file replace the paths of iconLogo + iconLogoText + iconLogoFull + iconLogoAppBarEnd
  + iconLogoAppBarCenter + imageSplash.
* Replace this text in all project com.appsbunches.evafloapp with unique applicationId.
* If the store is uploaded to the Turki apple account you should replace in all files the Apps Bunches team id (62KL86T2BC) with Turki team id (9TVD868UQF).
* Design the splash page.
* Open the android project and customize the app logo.
* Open the android project and customize the notification logo.
* Open https://appicon.co/ and create an iOS app logo.
* Replace ios/Runner/Assets.xcassets/AppIcon.appiconset with new file.
* Check whatsapp in store and update values in the AppConfig file.
* Check if the app uses lite version and update values in the AppConfig file.
* Customize the AppConfig file with the right values.
* Customize the colors file with the right values.
* Create a new project in firebase with android and iOS.
* Enable remote config and add WA_ACCOUNT + WA_ACCOUNT_ENABLE + WA_PRODUCT + ACCESS_TOKEN +
  AUTHORIZATION_TOKEN + SHOW_TIDIO + SHOW_BONAT + SHOW_LIVECHAT
* Open Xcode and replace the version number with 1.
* Create App ID for project by archive by Xcode and export
* Add app id and team id to firebase iOS app
* Create Dynamic link with app name and app logo
* In the .env file replace shareLink with firebase dynamic link.
* Create one signal project if it does not exist.
* In the .env file replace OneSignalAppId.
* Enable the android in one signal by firebase sender id and Server Key
* Go to app apple developer and request certificate then create the certificate by keychain app
* Enable the iOS in one signal by p.12 certificate
* Go to Zid back office and put the store url then fill all requirements fields.
* Create an android keystore then upload it on the drive.
* Create a repo from Github in Apps Bunches.
* Connect the app with Github.
* Create an app in code magic and fill all requirements fields.
  (Flutter 3.10.4 -xcode Latest(xx.x) - cocoapod default)
* Upload on GitHub.
* Invite QA team in apple account and add them on test flight.
* Create iOS public link
* Share app data in Apps Data sheet.
* Share firebase
  date [here](https://docs.google.com/spreadsheets/d/1FMQfVg5zN_mUpKB-lVdRgF6hxsNZYEu7jV4pxBKAmcI/edit#gid=0)
* Share keystore
  file [here](https://drive.google.com/drive/u/0/folders/15a6Hsu_Ou7GvnyOSr7imERlVY0bdLahp)

## Steps to update apps

* Open the project from version control if it didn't exist on the developer device or update the
  project if it exists on your developer device.
* Take a look at the lib/src/comments.dart file.
* Update pubspec.yaml file and do "Pug get".
* Update data, entities, localization, modules, services and utils folders and binding.dart file.
* Check the files you can't update in this store in the comment file and return them to the previous
  state.
* Fix the related trello tasks with this store.
* Go to the app store and check the latest live build.
* Open xcode and increase version one step if the current step on the device is live.and make the
  version “1”.
* Increase the build one step if you didn't increase the version.
* Go to google play store and check the latest live version number and version name.
* Open android/app/build.gradle and increase versionName one step if the current step on the device
  is live.
* Increase the versionCode one step always.
* Check the build versions of Flutter are (3.10.4), Xcode is Latest(xx.x) and Cocoapod is default.
* Check the app on code magic if enabled with google play or not and make sure to be enabled.
* Create a commit and push it then make sure the app on code magic starts uploading.

## Quick App Test Cases

* Add product to cart in the app and website at the same time.
* Finish an order.
* Compare home screen between app and website.
* Add product to cart from product details.
* Compare additional pages between app and website.
* Check Zid logo with apps bunches logo.
* Add the update on the Bonat widget.
* Enable Bonat to be in App Bar
* Check the color item options in product details, it should be Black.
* Check Menu v1 & v2 in the Bar and Side menu.
* Check if all product page are working.
