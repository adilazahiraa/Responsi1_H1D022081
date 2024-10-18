import 'package:flutter/material.dart';
import '../bloc/pengingat_obat_bloc.dart'; // Assuming you have a bloc for managing PengingatObat
import '../widget/warning_dialog.dart';
import '/model/pengingat_obat.dart';
import '/ui/pengingat_obat_form.dart';
import 'pengingat_obat_page.dart'; // Make sure this is the correct path

// ignore: must_be_immutable
class PengingatObatDetail extends StatefulWidget {
  PengingatObat? pengingatObat;

  PengingatObatDetail({Key? key, this.pengingatObat}) : super(key: key);

  @override
  _PengingatObatDetailState createState() => _PengingatObatDetailState();
}

class _PengingatObatDetailState extends State<PengingatObatDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengingat Obat'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.redAccent,
              Colors.pinkAccent,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailCard(),
                const SizedBox(height: 32),
                _tombolHapusEdit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailCard() {
    return Card(
      color: Colors.white.withOpacity(0.9), // Slightly transparent background
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Nama Obat : ${widget.pengingatObat!.medicine_name}",
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Dosis Obat (Mg) : ${widget.pengingatObat!.dosage_mg}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16),
            Text(
              "Waktu Per Hari : ${widget.pengingatObat!.times_per_day}",
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Tombol Edit
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PengingatObatForm(
                  pengingatObat: widget.pengingatObat!,
                ),
              ),
            );
          },
        ),
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        // Tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            // Replace this with your delete logic
            PengingatObatBloc.deletePengingatObat(id: widget.pengingatObat!.id!).then(
              (value) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PengingatObatPage(),
                  ),
                );
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            );
          },
        ),
        // Tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
