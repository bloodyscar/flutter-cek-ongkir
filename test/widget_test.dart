import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");

  final responseApi = await http.post(url, headers: {
    "key": "fc1e89bef6252c743660d3ed28dee170",
    "content-type": "application/x-www-form-urlencoded"
  }, body: {
    "origin": "501",
    "destination": "114",
    "weight": "1700",
    "courier": "pos",
  });

  final responseJson = json.decode(responseApi.body);
  print(responseJson["rajaongkir"]["results"]);
}
