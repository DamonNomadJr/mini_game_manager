import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ItchIo {
  static String itchIoAuthUrl =
      "https://itch.io/user/oauth?client_id=e2e7c96c802041d26685546533f4607b&scope=profile%3Ame&response_type=token&redirect_uri=https%3A%2F%2Fhtmlpreview.github.io%2F%3Fhttps%3A%2F%2Fgithub.com%2FDamonNomadJr%2Fmini_game_manager%2Fblob%2Fmain%2F.docs%2Fitch_io_response.html";
  static late String? itchIoAuth = null;

  static late SharedPreferences _sharedPrefs;

  static init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    ItchIo.itchIoAuth = loadAuthToken();
  }

  static Future<String?> getUserDetail() async {
    var responseData = await http.get(
      Uri.https(
        "itch.io",
        "/api/1/$itchIoAuth/me",
      ),
    );
    print(json.decode(responseData.body));
    return json.decode(responseData.body)["user"]["username"];
  }

  static setAuthToken(String token) {
    itchIoAuth = token;
    saveAuthToken(token);
  }

  static String? getAuthToken() {
    return itchIoAuth;
  }

  static String? loadAuthToken() {
    return ItchIo._sharedPrefs.getString("ItchIoAuthToken");
  }

  static Future<void> saveAuthToken(String token) async {
    await ItchIo._sharedPrefs.setString("ItchIoAuthToken", token);
  }
}
