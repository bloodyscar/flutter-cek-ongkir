import 'package:dropdown_search/dropdown_search.dart';

import 'widgets/city.dart';
import 'widgets/province.dart';
import 'widgets/berat.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cek Ongkir Indonesia'),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(50),
          child: ListView(
            children: [
              Provinsi(
                tipe: "asal",
              ),
              Obx(
                () => controller.hiddenKotaAsal.isTrue
                    ? SizedBox()
                    : Kota(
                        idProv: (controller.idKotaAsal.value).toString(),
                        tipe: "asal",
                      ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 2,
                color: Colors.grey,
              ),
              Provinsi(
                tipe: "tujuan",
              ),
              Obx(
                () => controller.hiddenKotaTujuan.isTrue
                    ? SizedBox()
                    : Kota(
                        idProv: (controller.idKotaTujuan.value).toString(),
                        tipe: "tujuan",
                      ),
              ),
              BeratBarang(),
              SizedBox(height: 15),
              Obx(
                () => controller.hiddenKurir.isTrue
                    ? SizedBox()
                    : DropdownSearch<Map<String, dynamic>>(
                        itemAsString: (item) => "${item['name']}",
                        popupItemBuilder: (context, item, isSelected) =>
                            Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "${item['name']}",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        items: [
                          {'code': 'jne', 'name': 'JNE'},
                          {'code': 'tiki', 'name': 'TIKI'},
                          {'code': 'pos', 'name': 'POS Indonesia'},
                        ],
                        showClearButton: true,
                        mode: Mode.DIALOG,
                        // showSelectedItem: true,
                        label: "Pilih Kurir",
                        hint: "country in menu mode",
                        onChanged: (value) {
                          if (value != null) {
                            if (controller.idKotaAsal != 0 &&
                                controller.idKotaTujuan != 0 &&
                                controller.berat > 0) {
                              controller.kurir.value = value['code'];

                              controller.hiddenCekOngkir.value = false;
                            } else {
                              controller.hiddenCekOngkir.value = true;
                              controller.kurir.value = "";
                            }
                          } else {
                            controller.hiddenCekOngkir.value = true;
                          }
                        },
                      ),
              ),
              SizedBox(
                height: 15,
              ),
              Obx(
                () => controller.hiddenCekOngkir.isTrue
                    ? SizedBox()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        onPressed: () {
                          controller.ongkosKirim();
                        },
                        child: Text("CEK ONGKIR")),
              )
            ],
          ),
        ));
  }
}
