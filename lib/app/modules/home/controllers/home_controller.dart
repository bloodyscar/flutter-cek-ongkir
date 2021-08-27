import 'dart:convert';

import 'package:cekongkir/app/modules/home/courier_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var hiddenKotaAsal = true.obs;
  var idProvAsal = 0.obs;
  var idKotaAsal = 1.obs;

  var hiddenKotaTujuan = true.obs;
  var idProvTujuan = 0.obs;
  var idKotaTujuan = 0.obs;

  var hiddenCekOngkir = true.obs;
  var hiddenKurir = true.obs;
  var hiddenBerat = true.obs;

  var kurir = "".obs;

  double berat = 0.0;
  String satuan = 'Gram';

  late TextEditingController beratC;

  void ongkosKirim() async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");

    try {
      final responseApi = await http.post(url, headers: {
        "key": "fc1e89bef6252c743660d3ed28dee170",
        "content-type": "application/x-www-form-urlencoded"
      }, body: {
        "origin": "$idKotaAsal",
        "destination": "$idKotaTujuan",
        "weight": "$berat",
        "courier": "$kurir",
      });

      final responseJson =
          json.decode(responseApi.body) as Map<String, dynamic>;

      var results = responseJson['rajaongkir']['results'] as List<dynamic>;

      var listAllCourier = Courier.fromJsonList(results);
      var courier = listAllCourier[0];

      Get.defaultDialog(
          title: courier.name!,
          content: Column(
            children: courier.costs!
                .map((e) => ListTile(
                      title: Text("${e.service}"),
                      subtitle: Text("${e.cost![0].value}"),
                      trailing: Text(courier.code == "pos"
                          ? "${e.cost![0].etd}"
                          : "${e.cost![0].etd} HARI"),
                    ))
                .toList(),
          ));
    } catch (e) {
      print(e);
      Get.defaultDialog(title: 'Terjadi Kesalahan', middleText: e.toString());
    }
  }

  void ubahBerat(String value) {
    berat = double.tryParse(value) ?? 0.00;
    String cekSatuan = satuan;
    switch (cekSatuan) {
      case "Kilogram":
        berat = berat * 1000;
        break;
      case "Gram":
        berat = berat;
        break;
      default:
        berat = berat;
    }
    print("${berat} gram");
  }

  void ubahSatuan(value) {
    berat = double.tryParse(beratC.text) ?? 0.00;
    switch (value) {
      case "Kilogram":
        berat = berat * 1000;
        break;
      case "Gram":
        berat = berat;
        break;
      default:
        berat = berat;
    }

    satuan = value;
    print("${berat} gram");
  }

  @override
  void onInit() {
    beratC = TextEditingController(text: "${berat}");
    super.onInit();
  }

  @override
  void dispose() {
    beratC.dispose();
    super.dispose();
  }
}
