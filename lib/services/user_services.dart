import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class UserService {
  static Future<bool> verifyUser(Map body, context) async {
    final uri = Uri.http('element-emotion.bnr.la:8001', 'api/login/');
    //final uri = Uri.http('192.168.0.6:8000', 'api/login/');
    final response = await http.post(
      uri,
      body: jsonEncode(body), 
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token 90982aa4c7100b9f70dd2068f67d3808c4fd436c'     // server
      //'Authorization': 'Token 65e57b9470b9eefbb9f577221c22f412cdf78bc4'   // PC 
      }
    );
    //return response.statusCode == 201;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      prefs.setString('username', body['username']);
      prefs.setString('group', jsonResponse['group']);
      return true;
    } else {
      return false;
    }
  }  
}