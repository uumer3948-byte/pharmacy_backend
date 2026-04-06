import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

// Change this from 10.0.2.2 or your local IP to the Render URL
static const String baseUrl = "https://pharmacy-backend-yjra.onrender.com";

  static Future getMedicines() async {

    var res = await http.get(
      Uri.parse("$baseUrl/medicines")
    );

    return jsonDecode(res.body);

  }

}