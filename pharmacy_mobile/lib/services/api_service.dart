import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "http://10.0.2.2:8010";

  static Future getMedicines() async {

    var res = await http.get(
      Uri.parse("$baseUrl/medicines")
    );

    return jsonDecode(res.body);

  }

}