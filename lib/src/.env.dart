//appName need to change in 3 places
const appNameAr = 'Evaflo';
const appNameEn = 'Evaflo';
const storeUrl = 'https://evaflo.co';
//the following just need to change in this file
const storeId = '224947';
const AUTHORIZATION_TOKEN =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzMzYiLCJqdGkiOiJhY2JkOWI2NmU5MTEwOGIwNzFkMjNlOTc2NGRjY2FiM2Y3ZTcwYjBlMDBlYjI3ZmFlZWRjYzgwYzVmNzg5NjJkOWQxNTljOTI5MWIwMThiMiIsImlhdCI6MTY5OTM0NDk3Ny45ODU0MiwibmJmIjoxNjk5MzQ0OTc3Ljk4NTQyMiwiZXhwIjoxNzMwOTY3Mzc3Ljk0NTk3NSwic3ViIjoiMjQ2MDEwIiwic2NvcGVzIjpbInRoaXJkX2FjY291bnRfcmVhZCIsInRoaXJkX3ZhdF9yZWFkIiwidGhpcmRfY2F0ZWdvcmllc19yZWFkIiwidGhpcmRfY3VzdG9tZXJzX3JlYWQiLCJ0aGlyZF9vcmRlcl9yZWFkIiwidGhpcmRfY291cG9uc193cml0ZSIsInRoaXJkX2RlbGl2ZXJ5X29wdGlvbnNfcmVhZCIsInRoaXJkX2FiYW5kb25lZF9jYXJ0c19yZWFkIiwidGhpcmRfcGF5bWVudF9yZWFkIiwidGhpcmRfd2ViaG9va193cml0ZSIsInRoaXJkX3Byb2R1Y3RfcmVhZCIsInRoaXJkX2NvdW50cmllc19yZWFkIiwidGhpcmRfY2F0YWxvZ193cml0ZSIsInRoaXJkX3N1YnNjcmlwdGlvbl9yZWFkIiwidGhpcmRfaW52ZW50b3J5X3JlYWQiXX0.C28ssbHHyMKyeJTKnyK98CbUvic28pJepM1wDVmDbL8V7jbDPaVmc8VsPkDavYiwGxn5a13Wg22YODvr84CGokVK0Kp48ltLUjORcYUCC4YmbcqZhDVzqSSvZnWYJ8PnsIiPo8KGbgnoNDlCU_mwRGIEyqSFMaNX5Er6AwXSl1JM-IbpbHRc0WoWQLrX8pXi_QjVb_u43z61y2FPeSNaD9LynfyYl0ILFLmcGnMTRaH16xIYOuTEFtjeLUV3NECiXLoQbo0AhmBYGjZIGWaMVDJUtzrVcUUTQpDlMNDDj-AthLf_zqy8QybW2pFIJv0ONQkdtOagsXDYQfr2QkHjJY-1GE5cTFBh44GghiqEyN1KKISOWyjlNBrM6KFF3CWwOG4eez9tve8MhN7ARMRsqQBN-giOZbo8tyJe3878gZbSEDzlf9Qrj8eOsXXm7Viu7N9ueC-PitqKrGMrIsUMPbFbT-3a1Iyk_yqY4cAcAw_b1Z-K3AQM8I3ha8aYFb8YIeXgqTZKKIkZZMNWFovtw3agIEJlvJqiTwiYlnsYdieXk-nMD8RIklhfS8BNDQmd_C6TBl2mXsgVLXnhE3zN0no-QlSgNEYO3pYIrY6HfVKROtt8fg3H_EzfCZRs4u9N9pznurY0ycoOXQkV64KYAnzGKYa9ro8qu25MrMegIJw";
const ACCESS_TOKEN =
    'eyJpdiI6InNpWFRhN1BRakpWa0tsODlNczV3MEE9PSIsInZhbHVlIjoiUThYU1puOUFyZjVPOXdzRUR3QlZFbHYwRGcvMUVKbktnKysvYlhQTTNVM3FzbnBkNk9EeVBQL2RnbWZqeGlMaXd4TWczMWxoYWsyYkl0Z2lkRVFXL0JaSmFnejNNRTA0RDFZUWxEa1RsaFRHTmVJWTZyd01wQ0RIYnRlOVVxTUVKUFNZZ3gyZ1ROWkE0Mlg2TnpMNUxFUEtITHBzUWdnQVFBUG44UWk3M1l6Lzl6aDRsR3A4blRNY3BIV1NQc3JwQ0xCWmt5N2taRW9Ma2ttY1N4cTNKM05qd2NuV2xoYnZYVmRSbDl1Y2JCUT0iLCJtYWMiOiI3YmJkZTYzZjUzMGE2Y2I2YzEzMDE4NTRmNDQ2NWM5MjAyMGFjMzViNWM2ODQyMDM0Y2Q0NGVmZGU0NmZmM2MwIiwidGFnIjoiIn0=';
const OneSignalAppId = '9c10033b-b6fd-40b2-a86a-7fbd53a9ccdd';
const appsBunchesUrl = 'https://bit.ly/3PFmkO9';
// Share App link in stores
const shareLink = 'https://evafloapp.page.link/jofZ';

//static strings
const baseUrl = 'https://api.zid.sa/v2/';
const baseUrlV1 = 'https://api.zid.sa/v1/';
const baseUrlAppBuilder = 'http://app.appsbunches.com/builder/api/';
const catalogUrl = 'https://api.zid.sa/';
const accept = 'application/json';
const SECRET_ENCRYPT_KEY = '479cb4c8f5ac23e51fd3e1dee0ac14c6';

//themes ids
const softThemeId = 'f9f0914d-3c58-493b-bd83-260ed3cb4e82';
const eshraqThemeId = '8ba6ae26-32ea-4271-81b2-0d9d6804a473';
const ghassqThemeId = '20e10dd5-cf9d-4a6c-87d3-bfecd5a7b4d6';
const royalThemeId = 'a83992c5-1af5-4f54-a427-52be8d580fd0';
const duvetThemeId = '4a7b710a-5a1c-4953-a962-a9e68fd86795';
const naquaThemeId = 'bf8c2f47-a020-40c3-9cf5-11f5d0cfa33e';
const monkeyThemeId = '9d949f7a-271a-48d8-9b17-05317049bea4'; // not added at all
const foodyThemeId = '5ddcdb1e-d89e-4df6-b52e-7250c814e8c0';
const balsamThemeId = 'e7b7fed1-7ece-4140-8ba7-e21460ba3045';
const perfectThemeId = '483e7db3-f138-40aa-a9c4-06d33d60ae32';
String asayelThemeId = '3071d086-e7e1-4043-9ecb-5fe1d1c3405b';
const asayelStagingThemeId = '1807f432-a622-4ab3-9f10-da00c05fa27c';
const loaLoaThemeId = 'f951e4c7-fb2d-4a49-80e1-ec4e0d8b23aa'; // not handled just added for menus
const gloryThemeId = 'fbef5f5c-0a04-4fd3-8d1e-8cb9687f87a9'; // not handled just added for menus
const alphaThemeId = '8fbecb38-1d2a-4ca8-94e2-dc1a6fc0b740'; // not handled just added for menus
String zeyadaThemeId = 'f0f4165c-73c2-41d8-817b-60bd0804ee4c'; // not handled just added for menus
const customThemeId = ''; // it's for custom store theme

//remote config keys
const WA_ACCOUNT_KEY = 'WA_ACCOUNT';
const WA_ACCOUNT_ENABLE_KEY = 'WA_ACCOUNT_ENABLE';
const WA_PRODUCT_KEY = 'WA_PRODUCT';
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const AUTHORIZATION_TOKEN_KEY = 'AUTHORIZATION_TOKEN';
const TIDIO_KEY = 'SHOW_TIDIO';
const LIVECHAT_KEY = 'SHOW_LIVECHAT';
const BONAT_KEY = 'SHOW_BONAT';
const ABANDONED_CART_KEY = 'ABANDONED_CART_HOURS_COUNT';
const ABANDONED_CART_NOTIFICATION_TEXT_AR_KEY = 'ABANDONED_CART_NOTIFICATION_TEXT_AR';
const ABANDONED_CART_NOTIFICATION_TEXT_EN_KEY = 'ABANDONED_CART_NOTIFICATION_TEXT_EN';
const IS_MULTI_INVENTORY_ENABLE_KEY = 'IS_MULTI_INVENTORY_ENABLE';
const SHOW_WHATSAPP_KEY = 'SHOW_WHATSAPP_HOME';
const WA_HOME_KEY = 'WA_HOME_MASSAGE';
// remote config get button keys
const GB_All_App_KEY = 'SHOW_GB_ALL_APP';
const DISABLE_APPLE_PAY = 'DISABLE_APPLE_PAY';
const TRUST_PAYMENT_FORM_PRODUCT = 'SHOW_TrustPaymentFormProduct';
const HIDE_CART_GIFT_KEY = 'HIDE_CART_GIFT';