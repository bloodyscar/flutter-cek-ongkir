import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../province_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controllers/home_controller.dart';

class Provinsi extends GetView<HomeController> {
  const Provinsi({Key? key, required this.tipe}) : super(key: key);
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownSearch<Province>(
        showClearButton: true,
        searchBoxDecoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            hintText: "Cari Provinsi..."),
        showSearchBox: true,
        itemAsString: (item) => item.province!,
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            margin: EdgeInsets.all(20),
            child: Text(item.province.toString()),
          );
        },
        label: tipe == "asal" ? "Provinsi Asal" : "Provinsi Tujuan",
        onFind: (String filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");
          var getApi = await http
              .get(url, headers: {"key": "fc1e89bef6252c743660d3ed28dee170"});

          var convertJson = json.decode(getApi.body) as Map<String, dynamic>;

          var listAllProvince =
              convertJson["rajaongkir"]["results"] as List<dynamic>;

          var models = Province.fromJsonList(listAllProvince);
          return models;
        },
        onChanged: (value) {
          if (value != null) {
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = false;
              controller.idProvAsal.value = int.parse(value.provinceId!);
              controller.idKotaAsal.value = int.parse(value.provinceId!);
            } else {
              controller.hiddenKotaTujuan.value = false;
              controller.idProvTujuan.value = int.parse(value.provinceId!);
              controller.idKotaTujuan.value = int.parse(value.provinceId!);
            }
          } else {
            if (tipe == "asal") {
              print("Provinsi Tidak dipilih");
              controller.hiddenBerat.value = true;
              controller.hiddenKotaAsal.value = true;
              controller.hiddenKurir.value = true;
              controller.hiddenCekOngkir.value = true;
              controller.berat = 0;
            } else {
              print("Provinsi Tidak dipilih");
              controller.hiddenBerat.value = true;
              controller.hiddenKotaTujuan.value = true;
              controller.hiddenKurir.value = true;
              controller.hiddenCekOngkir.value = true;
              controller.berat = 0;
            }
          }
        },
      ),
    );
  }
}
