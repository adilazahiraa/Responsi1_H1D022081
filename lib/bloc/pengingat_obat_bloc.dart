import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import 'package:manajemenkesehatan/model/pengingat_obat.dart';

class PengingatObatBloc {
  // Mendapatkan daftar PengingatObat dari API
  static Future<List<PengingatObat>> getPengingatObats() async {
    String apiUrl = ApiUrl.listPengingatObat;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    List<dynamic> listData = (jsonObj as Map<String, dynamic>)['data'];
    List<PengingatObat> pengingatObats = listData
        .map((data) => PengingatObat.fromJson(data))
        .toList();

    return pengingatObats;
  }

  // Menambahkan PengingatObat baru
  static Future<String> addPengingatObat({required PengingatObat pengingatObat}) async {
    String apiUrl = ApiUrl.createPengingatObat;

    var body = {
      "medicine_name": pengingatObat.medicine_name,
      "dosage_mg": pengingatObat.dosage_mg.toString(),
      "times_per_day": pengingatObat.times_per_day.toString()
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Memperbarui PengingatObat
  static Future<String> updatePengingatObat({required PengingatObat pengingatObat}) async {
    String apiUrl = ApiUrl.updatePengingatObat(pengingatObat.id!);
    print(apiUrl);

    var body = {
      "medicine_name": pengingatObat.medicine_name,
      "dosage_mg": pengingatObat.dosage_mg,
      "times_per_day": pengingatObat.times_per_day
    };

    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Menghapus PengingatObat berdasarkan ID
  static Future<bool> deletePengingatObat({required int id}) async {
    String apiUrl = ApiUrl.deletePengingatObat(id);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
