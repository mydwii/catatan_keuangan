import 'package:flutter/material.dart';
import 'package:catatan_keuangan/database/DatabaseHelper.dart';
import 'package:catatan_keuangan/decoration/format_rupiah.dart';
import 'package:catatan_keuangan/model/model_database.dart';
import 'package:catatan_keuangan/pengeluaran/page_input_pengeluaran.dart';

class PagePengeluaran extends StatefulWidget {
  const PagePengeluaran({Key? key}) : super(key: key);

  @override
  State<PagePengeluaran> createState() => _PagePengeluaranState();
}

class _PagePengeluaranState extends State<PagePengeluaran> {
  List<ModelDatabase> listPengeluaran = [];
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
    await getTotalPengeluaran();
    await getAllData();
    await hitungSisaUang();
  }

  //cek database ada data atau tidak
  Future<void> getDatabase() async {
    var checkDB = await databaseHelper.cekDataPengeluaran();
    setState(() {
      strCheckDatabase = checkDB!;
    });
  }

  //cek jumlah total pengeluaran
  Future<void> getTotalPengeluaran() async {
    var checkTotalPengeluaran = await databaseHelper.getJmlPengeluaran();
    setState(() {
      strJmlUang = checkTotalPengeluaran;
    });
  }

  // Fungsi untuk menghitung sisa uang
  Future<void> hitungSisaUang() async {
    var totalPemasukan = await databaseHelper.getJmlPemasukan();
    setState(() {
      strSisaUang = totalPemasukan - strJmlUang;
    });
  }

  //get data untuk menampilkan ke listview
  Future<void> getAllData() async {
    var listData = await databaseHelper.getDataPengeluaran();
    setState(() {
      listPengeluaran.clear();
      listData!.forEach((kontak) {
        listPengeluaran.add(ModelDatabase.fromMap(kontak));
      });
    });
  }

  //untuk hapus data berdasarkan Id
  Future<void> deleteData(ModelDatabase modelDatabase, int position) async {
    await databaseHelper.deleteDataPengeluaran(modelDatabase.id!);
    await refreshData(); // Panggil refreshData untuk menyegarkan semua data setelah penghapusan
  }

  //untuk insert data baru
  Future<void> openFormCreate() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PageInputPengeluaran()));
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
                PageInputPengeluaran(modelDatabase: modelDatabase)));
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
                title: Text('Total Pengeluaran Bulan Ini',
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
                        'Ups, belum ada pengeluaran.\nYuk catat pengeluaran Kamu!',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)))
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listPengeluaran.length,
                    itemBuilder: (context, index) {
                      ModelDatabase modeldatabase = listPengeluaran[index];
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
          'Tambah Pengeluaran',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
