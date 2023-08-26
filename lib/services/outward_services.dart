import 'package:http/http.dart' as http;
import 'dart:convert';


class OutwardService {
  static Future<List?> fetchOutward() async {
    final uri = Uri.http('element-emotion.bnr.la:8001', 'api/outward-list/');
    //final uri = Uri.http('192.168.0.6:8000', 'api/outward-list/');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Token 90982aa4c7100b9f70dd2068f67d3808c4fd436c'
        //'Authorization': 'Token 65e57b9470b9eefbb9f577221c22f412cdf78bc4'
      }
    );
   
    if (response.statusCode == 200) {      
      final result = jsonDecode(response.body) as List;       
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> addOutward(Map body) async {
    final uri = Uri.http('element-emotion.bnr.la:8001', 'api/outward-create/');
    //final uri = Uri.http('192.168.0.6:8000', 'api/outward-create/');
    
    final response = await http.post(
      uri, 
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token 90982aa4c7100b9f70dd2068f67d3808c4fd436c'
        //'Authorization': 'Token 65e57b9470b9eefbb9f577221c22f412cdf78bc4'
      } 
    );
    
    return response.statusCode == 201 || response.statusCode == 200;
  }

  static Future<bool> deleteById(int id) async {
    String jsonId = id.toString();
    final uri = Uri.http('element-emotion.bnr.la:8001', 'api/outward-delete/$jsonId');
    //final uri = Uri.http('192.168.0.6:8000', 'api/outward-delete/$jsonId');
    
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Token 90982aa4c7100b9f70dd2068f67d3808c4fd436c'
        //'Authorization': 'Token 65e57b9470b9eefbb9f577221c22f412cdf78bc4'
      }
    );
    
    return response.statusCode == 200;  
  }

  static Future<bool> updateOutward(int id, Map body) async {
    String jsonId = id.toString();
    final uri = Uri.http('element-emotion.bnr.la:8001', 'api/outward-update/$jsonId');
    //final uri = Uri.http('192.168.0.6:8000', 'api/outward-update/$jsonId');
    
    final response = await http.put(
      uri, 
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token 90982aa4c7100b9f70dd2068f67d3808c4fd436c'
        //'Authorization': 'Token 65e57b9470b9eefbb9f577221c22f412cdf78bc4'
      }
    );

    return response.statusCode == 200;
  }

}