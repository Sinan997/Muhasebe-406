import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryn/kullanici_sayfasi.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('isimleralacak');
  await Hive.openBox('isimlerverecek');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "406 Muhasebe",
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  int alacakHesapla() {
    var boxAlacak = Hive.box("isimleralacak");
    int alacak = 0;

    for (int toplam in boxAlacak.values.toList()) {
      alacak += toplam;
    }
    return alacak;
  }

  int verecekHesapla() {
    var boxVerecek = Hive.box("isimlerverecek");
    int verecek = 0;
    for (int toplam in boxVerecek.values.toList()) {
      verecek += toplam;
    }
    return verecek;
  }

  void boxaEkle() {
    setState(() {
      var box = Hive.box("isimleralacak");
      var box2 = Hive.box("isimlerverecek");
      // box.add(_controller.text);
      box.put(_controller.text, 0);
      box2.put(_controller.text, 0);
      _controller.clear();
      Navigator.pop(context, 'OK');
    });
  }

  void boxdanSil(isim) {
    {
      setState(
        () {
          var box = Hive.box("isimleralacak");
          var box2 = Hive.box("isimlerverecek");
          box.delete(isim);
          box2.delete(isim);
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("isimleralacak").keys.toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // titleSpacing: 20,
          // leadingWidth: 45,
          elevation: 0,
          leading: const Icon(
            FontAwesomeIcons.fileInvoice,
          ),
          actions: <Widget>[
            DropdownButtonHideUnderline(
              child: DropdownButton(
                elevation: 8,
                hint: const Text("Kullanıcılar "),
                // iconSize: 35,
                icon: const Icon(FontAwesomeIcons.users),
                items: box.map((isim) {
                  return DropdownMenuItem(
                    child: Dismissible(
                      direction: DismissDirection.startToEnd,
                      key: UniqueKey(),
                      onDismissed: (_) {
                        boxdanSil(isim);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(isim),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                boxdanSil(isim);
                              },
                            )
                          ]),
                    ),
                    value: isim,
                  );
                }).toList(),
                onChanged: (gelenIsim) {
                  setState(() {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KullaniciSayfasi(
                                    isim: gelenIsim.toString())))
                        .then((_) => setState(() {}));
                  });
                },
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            IconButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Kişi Ekleme'),
                  content: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: "İsim",
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(FontAwesomeIcons.user),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.blue, fontSize: 30)),
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      onSubmitted: (_) {
                        boxaEkle();
                      }),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text('Çık'),
                    ),
                    TextButton(
                      onPressed: boxaEkle,
                      child: const Text('Ekle'),
                    ),
                  ],
                ),
              ),
              icon: const Icon(FontAwesomeIcons.plus),
              // padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Alacak:${alacakHesapla()}",
                  style: const TextStyle(color: Colors.green, fontSize: 45),
                ),
                const Divider(
                  height: 40,
                ),
                Text(
                  "Verecek:${verecekHesapla()}",
                  style: const TextStyle(color: Colors.red, fontSize: 45),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
