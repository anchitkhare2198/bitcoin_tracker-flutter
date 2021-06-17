import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final Uri url;

  Future getData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      // print(data);
      return jsonDecode(data);
      // var data2 = jsonDecode(data);
      // var rate = data2['rate'];
      // print(rate);
    } else {
      print(response.statusCode);
    }
  }
}
