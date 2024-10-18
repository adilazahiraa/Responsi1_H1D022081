import 'package:flutter/material.dart';
import 'package:manajemenkesehatan/ui/registrasi_page.dart';
import 'package:manajemenkesehatan/bloc/logout_bloc.dart';
import 'package:manajemenkesehatan/ui/login_page.dart';
import 'package:manajemenkesehatan/bloc/pengingat_obat_bloc.dart';
import 'package:manajemenkesehatan/model/pengingat_obat.dart';
import 'package:manajemenkesehatan/ui/pengingat_obat_detail.dart';
import 'package:manajemenkesehatan/ui/pengingat_obat_form.dart';

class PengingatObatPage extends StatefulWidget {
  const PengingatObatPage({Key? key}) : super(key: key);

  @override
  _PengingatObatPageState createState() => _PengingatObatPageState();
}

class _PengingatObatPageState extends State<PengingatObatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pengingat Obat'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PengingatObatForm()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  )
                });
              },
            )
          ],
        ),
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
        child: FutureBuilder<List>(
          future: PengingatObatBloc.getPengingatObats(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListPengingatObat(
                    list: snapshot.data,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class ListPengingatObat extends StatelessWidget {
  final List? list;

  const ListPengingatObat({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemPengingatObat(
          pengingatObat: list![i],
        );
      },
    );
  }
}

class ItemPengingatObat extends StatelessWidget {
  final PengingatObat pengingatObat;

  const ItemPengingatObat({Key? key, required this.pengingatObat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PengingatObatDetail(
              pengingatObat: pengingatObat,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Text(
            pengingatObat.medicine_name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Dosis: ${pengingatObat.dosage_mg} mg',
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            '${pengingatObat.times_per_day}x/hari',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
