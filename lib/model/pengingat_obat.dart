class PengingatObat {
  int? id;
  String? medicine_name;
  int? dosage_mg;
  int? times_per_day;
  PengingatObat({this.id, this.medicine_name, this.dosage_mg, this.times_per_day});
  factory PengingatObat.fromJson(Map<String, dynamic> obj) {
    return PengingatObat(
        id: obj['id'] is String ? int.tryParse(obj['id']) : obj['id'],
        medicine_name: obj['medicine_name'],
        dosage_mg: obj['dosage_mg'],
        times_per_day: obj['times_per_day']);
  }
}
