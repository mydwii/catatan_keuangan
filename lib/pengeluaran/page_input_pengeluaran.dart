import 'package:flutter/material.dart';
import 'package:catatan_keuangan/database/DatabaseHelper.dart';
import 'package:catatan_keuangan/model/model_database.dart';
import 'package:intl/intl.dart';

class PageInputPengeluaran extends StatefulWidget {
  final ModelDatabase? modelDatabase;

  PageInputPengeluaran({this.modelDatabase});

  @override
  _PageInputPengeluaranState createState() => _PageInputPengeluaranState();
}

class _PageInputPengeluaranState extends State<PageInputPengeluaran> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController? keterangan;
  TextEditingController? tanggal;
  TextEditingController? jml_uang;

  @override
  void initState() {
    keterangan = TextEditingController(
        text: widget.modelDatabase == null
            ? ''
            : widget.modelDatabase!.keterangan);
    tanggal = TextEditingController(
        text:
            widget.modelDatabase == null ? '' : widget.modelDatabase!.tanggal);
    jml_uang = TextEditingController(
        text:
            widget.modelDatabase == null ? '' : widget.modelDatabase!.jml_uang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        title: Text(
          'Form Data Pengeluaran',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: keterangan,
            decoration: InputDecoration(
              labelText: 'Keterangan',
              labelStyle: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.datetime,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(9999),
                );
                if (pickedDate != null) {
                  setState(() {
                    tanggal!.text =
                        DateFormat('dd MMM yyyy').format(pickedDate);
                  });
                }
              },
              controller: tanggal,
              decoration: InputDecoration(
                labelText: 'Tanggal',
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              controller: jml_uang,
              decoration: InputDecoration(
                labelText: 'Jumlah Uang',
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (keterangan!.text.isEmpty ||
                          tanggal!.text.isEmpty ||
                          jml_uang!.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Ups, form tidak boleh ada yang kosong!"),
                          ),
                        );
                      } else {
                        upsertData();
                      }
                    },
                    child: Center(
                      child: (widget.modelDatabase == null)
                          ? Text(
                              'Tambah Data',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            )
                          : Text(
                              'Update Data',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> upsertData() async {
    if (widget.modelDatabase != null) {
      //update
      await databaseHelper.updateDataPengeluaran(
        ModelDatabase.fromMap({
          'id': widget.modelDatabase!.id,
          'tipe': 'pengeluaran',
          'keterangan': keterangan!.text,
          'jml_uang': jml_uang!.text,
          'tanggal': tanggal!.text
        }),
      );
      Navigator.pop(context, 'update');
    } else {
      //insert
      await databaseHelper.saveData(
        ModelDatabase(
          tipe: 'pengeluaran',
          keterangan: keterangan!.text,
          jml_uang: jml_uang!.text,
          tanggal: tanggal!.text,
        ),
      );
      Navigator.pop(context, 'save');
    }
  }
}
