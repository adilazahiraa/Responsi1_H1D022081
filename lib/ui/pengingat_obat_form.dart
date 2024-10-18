import 'package:flutter/material.dart';
import '../bloc/pengingat_obat_bloc.dart'; // Ganti dengan path yang sesuai
import '../model/pengingat_obat.dart';
import '../ui/pengingat_obat_page.dart';
import '../widget/warning_dialog.dart'; // Jika perlu menggunakan dialog peringatan

// ignore: must_be_immutable
class PengingatObatForm extends StatefulWidget {
  PengingatObat? pengingatObat;
  PengingatObatForm({Key? key, this.pengingatObat}) : super(key: key);

  @override
  _PengingatObatFormState createState() => _PengingatObatFormState();
}

class _PengingatObatFormState extends State<PengingatObatForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PENGINGAT OBAT";
  String tombolSubmit = "SIMPAN";

  final _medicineNameController = TextEditingController();
  final _dosageMgController = TextEditingController();
  final _timesPerDayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.pengingatObat != null) {
      setState(() {
        judul = "UBAH PENGINGAT OBAT";
        tombolSubmit = "UBAH";

        // Mengisi field dengan data dari objek pengingatObat
        _medicineNameController.text = widget.pengingatObat!.medicine_name ?? '';
        _dosageMgController.text = widget.pengingatObat!.dosage_mg.toString();
        _timesPerDayController.text = widget.pengingatObat!.times_per_day.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.redAccent,
              Colors.pinkAccent,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _logo(),
                  const SizedBox(height: 40),
                  _medicineNameTextField(),
                  const SizedBox(height: 16),
                  _dosageMgTextField(),
                  const SizedBox(height: 16),
                  _timesPerDayTextField(),
                  const SizedBox(height: 32),
                  _buttonSubmit(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Column(
      children: const [
        Icon(Icons.medication, size: 80, color: Colors.red),
        SizedBox(height: 8),
        Text(
          "Pengingat Obat",
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _medicineNameTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Obat"),
      controller: _medicineNameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nama Obat harus diisi";
        }
        return null;
      },
    );
  }

  Widget _dosageMgTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Dosis Obat (Mg)"),
      controller: _dosageMgController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Dosis Obat (Mg) harus diisi";
        }
        if (int.tryParse(value) == null) {
          return "Dosis harus berupa angka";
        }
        return null;
      },
    );
  }

  Widget _timesPerDayTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Waktu Per Hari"),
      controller: _timesPerDayController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Waktu Per Hari harus diisi";
        }
        if (int.tryParse(value) == null) {
          return "Waktu harus berupa angka";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity, // Tombol sepanjang layar
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(fontFamily: 'Arial', fontSize: 18),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              )
            : Text(tombolSubmit, style: const TextStyle(color: Colors.white)), // Ubah warna teks menjadi putih
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (!_isLoading) {
              if (widget.pengingatObat != null) {
                // Kondisi update pengingat obat
                ubah();
              } else {
                // Kondisi tambah pengingat obat
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });

    // Membuat objek PengingatObat untuk disimpan
    PengingatObat createPengingatObat = PengingatObat(
      id: null, // ID null untuk tambah
      medicine_name: _medicineNameController.text,
      dosage_mg: int.parse(_dosageMgController.text),
      times_per_day: int.parse(_timesPerDayController.text),
    );

    // Simulasi proses simpan (ganti dengan pemanggilan API)
    PengingatObatBloc.addPengingatObat(pengingatObat: createPengingatObat).then((value) {
      // Navigasi langsung ke PengingatObatPage setelah berhasil disimpan
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const PengingatObatPage()),
      );
    }).catchError((error) {
      // Jika simpan gagal, tampilkan dialog peringatan
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });

    // Membuat objek PengingatObat untuk diupdate
    PengingatObat updatePengingatObat = PengingatObat(
      id: widget.pengingatObat!.id,
      medicine_name: _medicineNameController.text,
      dosage_mg: int.parse(_dosageMgController.text),
      times_per_day: int.parse(_timesPerDayController.text),
    );

    // Simulasi proses update (ganti dengan pemanggilan API)
    PengingatObatBloc.updatePengingatObat(pengingatObat: updatePengingatObat).then((value) {
      // Navigasi langsung ke PengingatObatPage setelah berhasil diubah
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const PengingatObatPage()),
      );
    }).catchError((error) {
      // Jika ubah gagal, tampilkan dialog peringatan
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
