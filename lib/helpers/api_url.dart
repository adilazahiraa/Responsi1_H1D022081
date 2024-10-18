class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/';//sesuaikan dengan ip laptop / localhost teman teman / url server Codeigniter

  static const String registrasi = baseUrl + 'api/registrasi';
  static const String login = baseUrl + 'api/login';
  static const String listPengingatObat = baseUrl + 'api/kesehatan/pengingat_obat';
  static const String createPengingatObat = baseUrl + 'api/kesehatan/pengingat_obat';

  static String updatePengingatObat(int id) {
    return baseUrl + 'api/kesehatan/pengingat_obat/' + id.toString()+'/update';//sesuaikan dengan url API yang sudah dibuat
  }

  static String showPengingatObat(int id) {
    return baseUrl + 'api/kesehatan/pengingat_obat/' + id.toString();//sesuaikan dengan url API yang sudah dibuat
  }

  static String deletePengingatObat(int id) {
    return baseUrl + 'api/kesehatan/pengingat_obat/' + id.toString()+'/delete';//sesuaikan dengan url API yang sudah dibuat
  }
}
