// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class AppConstant {
  AppConstant._();
  static const String APP_NAME_KEY = "APP_NAME";
  static const String BASE_URL_KEY = "BASE_URL";
  static const String IMAGE_BASE_URL_KEY = "IMAGE_BASE_URL";

  static const String ENV_KEY = "ENV";
  static const String FONT_FAMILY = "Inter";

  static const String TITLE_BUTTON_NEXT = "NEXT";
  static const String CANCEL_BUTTON_NEXT = "CANCEL";
  static const String OK_BUTTON_NEXT = "OK";
  static const String YES_BUTTON_NEXT = "YES";
  static const String RETRY_BUTTON_NEXT = "Retry?";

  //ERRORS
  static String get ERROR_FILL_ALL_FIELDS => "Fill all fields";
  static const String ERROR_SOMETHING_WENT_WRONG = "Something Went Wrong";
  static String get ERROR_NO_ITEMS => "NO ITEMS FOUND";
}
