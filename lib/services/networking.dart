import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper{
  final String url;

  const NetworkHelper(this.url);

  Future getData() async{
    String urlString = this.url;
    Uri url = Uri.parse(urlString);
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }
}