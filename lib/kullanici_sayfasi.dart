import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class KullaniciSayfasi extends StatefulWidget {
  final String isim;
  const KullaniciSayfasi({Key? key, required this.isim}) : super(key: key);

  @override
  _KullaniciSayfasiState createState() => _KullaniciSayfasiState();
}

class _KullaniciSayfasiState extends State<KullaniciSayfasi> {
  void alacakEkle(para) {
    setState(() {
      var alacakBox = Hive.box("isimleralacak");
      int temp = alacakBox.get(widget.isim);
      temp += int.parse(para);
      alacakBox.put(widget.isim, temp);
      _controllerAlacak.clear();
    });
  }

  void alacakSil(para) {
    setState(() {
      var alacakBox = Hive.box("isimleralacak");
      int temp = alacakBox.get(widget.isim);
      temp -= int.parse(para);
      alacakBox.put(widget.isim, temp);
      _controllerAlacakSil.clear();
    });
  }

  void verecekEkle(para) {
    setState(() {
      var verecekBox = Hive.box("isimlerverecek");
      int temp = verecekBox.get(widget.isim);
      temp += int.parse(para);
      verecekBox.put(widget.isim, temp);
      _controllerVerecek.clear();
    });
  }

  void verecekSil(para) {
    setState(() {
      var verecekBox = Hive.box("isimlerverecek");
      int temp = verecekBox.get(widget.isim);
      temp -= int.parse(para);
      verecekBox.put(widget.isim, temp);
      _controllerVerecekSil.clear();
    });
  }

  String getAlacak(String isim) {
    var alacakBox = Hive.box("isimleralacak");
    return alacakBox.get(isim).toString();
  }

  String getVerecek(String isim) {
    var verecekBox = Hive.box("isimlerverecek");
    return verecekBox.get(isim).toString();
  }

  final TextEditingController _controllerAlacak = TextEditingController();
  final TextEditingController _controllerAlacakSil = TextEditingController();
  final TextEditingController _controllerVerecek = TextEditingController();
  final TextEditingController _controllerVerecekSil = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 25.0),
                child: Icon(FontAwesomeIcons.moneyBillWave),
              )
            ],
            elevation: 1,
            actionsIconTheme:
                const IconThemeData(color: Colors.green, size: 35),
            title: const Text("Alacak Verecek Gir"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${widget.isim.toUpperCase()} kullanıcısından alacağınız :${getAlacak(widget.isim.toString())}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "${widget.isim.toUpperCase()} kullanıcısına vereceğiniz :${getVerecek(widget.isim.toString())}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(widget.isim.toUpperCase()),
                const Divider(
                  thickness: 3,
                  color: Colors.black54,
                  height: 40,
                ),
                TextFormField(
                  controller: _controllerAlacak,
                  decoration: const InputDecoration(
                    icon: Icon(
                      FontAwesomeIcons.fill,
                      color: Colors.green,
                    ),
                    labelText: "Alacak Ekle",
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (para) {
                    alacakEkle(para);
                  },
                ),
                TextFormField(
                  controller: _controllerAlacakSil,
                  decoration: const InputDecoration(
                    icon: Icon(
                      FontAwesomeIcons.fill,
                      color: Colors.green,
                    ),
                    labelText: "Alacak Sil",
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (para) {
                    alacakSil(para);
                  },
                ),
                const Divider(
                  thickness: 4,
                  color: Colors.black54,
                  height: 70,
                ),
                TextFormField(
                  controller: _controllerVerecek,
                  decoration: const InputDecoration(
                    icon: Icon(
                      FontAwesomeIcons.fill,
                      color: Colors.red,
                    ),
                    labelText: "Verecek Ekle",
                    labelStyle: TextStyle(color: Colors.red),
                  ),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (para) {
                    verecekEkle(para);
                  },
                ),
                TextFormField(
                  controller: _controllerVerecekSil,
                  decoration: const InputDecoration(
                    icon: Icon(
                      FontAwesomeIcons.fill,
                      color: Colors.red,
                    ),
                    labelText: "Verecek Sil",
                    labelStyle: TextStyle(color: Colors.red),
                  ),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (para) {
                    verecekSil(para);
                  },
                ),
              ],
            ),
          )),
    );
  }
}
