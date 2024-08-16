import 'dart:convert';

import 'package:http/http.dart' as http;

const String apiUrl = "https://uitmprintingservice.digital/api/";

class HttpAuth {
  static Future<http.Response> postApi({jsons, url}) async {
    try {
      final jsonBody = json.encode(jsons);

      http.Response response = await http.post(
        Uri.parse('$apiUrl$url'),
        body: jsonBody,
      );
      return response;
    } catch (e) {
      throw "Network Error";
    }
  }
}
