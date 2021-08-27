import 'package:cekongkir/app/modules/home/controllers/home_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeratBarang extends GetView<HomeController> {
  const BeratBarang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.hiddenBerat.isTrue
          ? SizedBox()
          : Row(
              children: [
                Expanded(
                    child: TextField(
                  onChanged: (value) {
                    if (value != null) {
                      if (controller.idKotaAsal != 0 &&
                          controller.idKotaTujuan != 0) {
                        controller.hiddenKurir.value = false;
                      } else {
                        controller.hiddenKurir.value = true;
                        controller.hiddenCekOngkir.value = true;
                      }
                    } else {
                      controller.hiddenKurir.value = true;
                      controller.hiddenCekOngkir.value = true;
                    }
                  },
                  
                  autocorrect: false,
                  controller: controller.beratC,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      labelText: "Berat Barang",
                      hintText: "Berat Barang",
                      border: OutlineInputBorder()),
                )),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 150,
                  child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      showSelectedItem: true,
                      items: ["Kilogram", "Gram"],
                      label: "Satuan Gram",
                      hint: "country in menu mode",
                      popupItemDisabled: (String s) => s.startsWith('I'),
                      onChanged: (value) {
                        controller.ubahSatuan(value);
                      },
                      selectedItem: "Gram"),
                )
              ],
            ),
    );
  }
}
