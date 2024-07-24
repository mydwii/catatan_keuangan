import 'package:flutter/material.dart';
import 'package:catatan_keuangan/pemasukan/page_pemasukan.dart';
import 'package:catatan_keuangan/pengeluaran/page_pengeluaran.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.blue),
        cardTheme: const CardTheme(), // Hapus properti surfaceTintColor dari CardTheme
        dialogTheme: const DialogTheme(
          // Hapus properti surfaceTintColor dari DialogTheme
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Catatan Keuangan',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          bottom: setTabBar(),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            PagePemasukan(),
            PagePengeluaran(),
          ],
        ),
      ),
    );
  }

  TabBar setTabBar() {
    return TabBar(
      controller: tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black26,
      indicatorColor: Colors.white,
      tabs: const [
        Tab(
          text: 'Pemasukan',
          icon: Icon(Icons.archive_outlined),
        ),
        Tab(
          text: 'Pengeluaran',
          icon: Icon(Icons.unarchive_outlined),
        ),
      ],
    );
  }
}
