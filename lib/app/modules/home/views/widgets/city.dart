import '../../city_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controllers/home_controller.dart';

class Kota extends GetView<HomeController> {
  const Kota({Key? key, required this.idProv, required this.tipe})
      : super(key: key);
  final String idProv;
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        searchBoxDecoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            hintText: "Cari Kota..."),
        showSearchBox: true,
        itemAsString: (item) => "${item.type} ${item.cityName!}",
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            margin: EdgeInsets.all(20),
            child: Text("${item.type} ${item.cityName}"),
          );
        },
        label: tipe == "asal" ? "Kota Asal" : "Kota Tujuan",
        onFind: (String filter) async {
          Uri url = Uri.parse(
              "https://api.rajaongkir.com/starter/city?province=${idProv}");
          var getApi = await http
              .get(url, headers: {"key": "fc1e89bef6252c743660d3ed28dee170"});

          var convertJson = json.decode(getApi.body) as Map<String, dynamic>;

          var listAllCity =
              convertJson["rajaongkir"]["results"] as List<dynamic>;

          var models = City.fromJsonList(listAllCity);
          return models;
        },
        onChanged: (value) {
          if (value != null) {
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = false;
              controller.idKotaAsal.value = int.parse(value.cityId!);
            } else {
              controller.hiddenKotaTujuan.value = false;
              controller.hiddenBerat.value = false;
              controller.idKotaTujuan.value = int.parse(value.cityId!);
            }
          } else {
            if (tipe == "asal") {
              print("Provinsi Tidak dipilih");
              controller.hiddenKotaAsal.value = true;
            } else {
              print("Provinsi Tidak dipilih");
              controller.hiddenKotaTujuan.value = true;
            }
          }
        },
      ),
    );
  }
}
