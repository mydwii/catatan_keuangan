import 'package:flutter/material.dart';
import 'package:catatan_keuangan/database/DatabaseHelper.dart';
import 'package:catatan_keuangan/decoration/format_rupiah.dart';
import 'package:catatan_keuangan/model/model_database.dart';
import 'package:catatan_keuangan/pemasukan/page_input_pemasukan.dart';

class PagePemasukan extends StatefulWidget {
  const PagePemasukan({Key? key}) : super(key: key);

  @override
  State<PagePemasukan> createState() => _PagePemasukanState();
}

class _PagePemasukanState extends State<PagePemasukan> {
  List<ModelDatabase> listPemasukan = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  int strJmlUang = 0;
  int strCheckDatabase = 0;
  int strSisaUang = 0;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  // Fungsi untuk menyegarkan semua data
  Future<void> refreshData() async {
    await getDatabase();
    await getTotalPemasukan();
    await getAllData();
    await hitungSisaUang();
  }

  //cek database ada data atau tidak
  Future<void> getDatabase() async {
    var checkDB = await databaseHelper.cekDataPemasukan();
    setState(() {
      strCheckDatabase = checkDB!;
    });
  }

  //cek jumlah total pemasukan
  Future<void> getTotalPemasukan() async {
    var checkTotalPemasukan = await databaseHelper.getJmlPemasukan();
    setState(() {
      strJmlUang = checkTotalPemasukan;
    });
  }

  // Fungsi untuk menghitung sisa uang
  Future<void> hitungSisaUang() async {
    var totalPengeluaran = await databaseHelper.getJmlPengeluaran();
    setState(() {
      strSisaUang = strJmlUang - totalPengeluaran;
    });
  }

  //get data untuk menampilkan ke listview
  Future<void> getAllData() async {
    var listData = await databaseHelper.getDataPemasukan();
    setState(() {
      listPemasukan.clear();
      listData!.forEach((kontak) {
        listPemasukan.add(ModelDatabase.fromMap(kontak));
      });
    });
  }

  //untuk hapus data berdasarkan Id
  Future<void> deleteData(ModelDatabase modelDatabase, int position) async {
    await databaseHelper.deletePemasukan(modelDatabase.id!);
    await refreshData(); // Panggil refreshData untuk menyegarkan semua data setelah penghapusan
  }

  //untuk insert data baru
  Future<void> openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PageInputPemasukan()));
    if (result == 'save') {
      await refreshData(); // Panggil refreshData setelah penyimpanan data
    }
  }

  //untuk edit data
  Future<void> openFormEdit(ModelDatabase modelDatabase) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PageInputPemasukan(modelDatabase: modelDatabase)));
    if (result == 'update') {
      await refreshData(); // Panggil refreshData setelah pengeditan data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: ListTile(
                title: Text('Total Pemasukan Bulan Ini',
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(CurrencyFormat.convertToIdr(strJmlUang),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
            ),
            // Tambahkan Card untuk menampilkan sisa uang di sini
            Card(
              margin: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: ListTile(
                title: Text('Sisa Uang Bulan Ini',
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(CurrencyFormat.convertToIdr(strSisaUang),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
            ),
            strCheckDatabase == 0
                ? Container(
                    padding: EdgeInsets.only(top: 200),
                    child: Text(
                        'Ups, belum ada pemasukan.\nYuk catat pemasukan Kamu!',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)))
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listPemasukan.length,
                    itemBuilder: (context, index) {
                      ModelDatabase modeldatabase = listPemasukan[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white,
                        child: ListTile(
                          title: Text('${modeldatabase.keterangan}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: Text(
                                    'Jumlah Uang: ' +
                                        CurrencyFormat.convertToIdr(int.parse(
                                            modeldatabase.jml_uang.toString())),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Text('Tanggal: ${modeldatabase.tanggal}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black)),
                              ),
                            ],
                          ),
                          trailing: FittedBox(
                            fit: BoxFit.fill,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      openFormEdit(modeldatabase);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    )),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    AlertDialog hapus = AlertDialog(
                                      title: Text('Hapus Data',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black)),
                                      content: Container(
                                        height: 20,
                                        child: Column(
                                          children: [
                                            Text(
                                                'Yakin ingin menghapus data ini?',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              deleteData(modeldatabase, index);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Ya',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black))),
                                        TextButton(
                                          child: Text('Tidak',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(
                                        context: context,
                                        builder: (context) => hapus);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          openFormCreate();
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Tambah Pemasukan',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
