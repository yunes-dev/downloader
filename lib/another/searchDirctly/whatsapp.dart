import 'package:download_every_thing/another/searchDirctly/searchDirctly.dart';
import 'package:download_every_thing/another/webviewSearch/webViewSearch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/components/components.dart';
import '../classes/components/processData.dart';
import '../download/providerDownload.dart';
import '../tabsWebVewPop/providerTabPop.dart';

class OtherWhatsAPP extends StatefulWidget {
  const OtherWhatsAPP({super.key});

  @override
  State<OtherWhatsAPP> createState() => _OtherWhatsAPPState();
}

class _OtherWhatsAPPState extends State<OtherWhatsAPP> {
  Components elementeWidget = Components();

  ProcessData processData = ProcessData();
  List<Whatsapp> urlWhatsapp = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataWhatsApp(
        'https://media4.appsfire.co/file/bt3-whatsapp-apk/',
        'البطريق',
        "https://meta-code-ye.com/images/btWhatsapp/bt1.webp",
        'bt3-whatsapp-apk');
    getDataWhatsApp(
        'https://media4.appsfire.co/file/bt-whatsapp-apk/',
        'البطريق',
        "https://meta-code-ye.com/images/btWhatsapp/bt4.webp",
        'bt-whatsapp-apk');
    getDataWhatsApp(
        'https://media4.appsfire.co/file/bt4-whatsapp-apk/',
        'البطريق',
        "https://meta-code-ye.com/images/btWhatsapp/bt3.webp",
        'bt4-whatsapp-apk');
    getDataWhatsApp(
        'https://media4.appsfire.co/file/bt2-whatsapp-apk/',
        'البطريق',
        "https://meta-code-ye.com/images/btWhatsapp/bt2.webp",
        'bt2-whatsapp-apk');

    getDataWhatsApp('https://watsabadam.com/download-page/', 'ادام',
        "https://meta-code-ye.com/images/adam/adam1.png", 'AdamWhatsApp_Black');
    getDataWhatsApp(
        'https://watsabadam.com/download-page/',
        'ادام',
        "https://meta-code-ye.com/images/adam/adam2.png",
        'Adam2WhatsApp_Brown');

    getDataWhatsApp(
        'https://file.alaqel2ahmed.xyz/file/whatsapp-red/',
        'بلس الاحمر',
        "https://meta-code-ye.com/images/colorsWhatsapp/red.webp",
        'file.alaqel2ahmed.xyz/file/whatsapp-red');
    getDataWhatsApp(
        'https://file.alaqel2ahmed.xyz/file/kb-whatsapp/',
        'الكاسر',
        "https://meta-code-ye.com/images/kbWhatsapp/kb1.webp",
        'file.alaqel2ahmed.xyz/file/kb-whatsapp');

    getDataWhatsApp(
        'https://file.alaqel2ahmed.xyz/file/kb2-whatsapp/',
        'الكاسر',
        "https://meta-code-ye.com/images/kbWhatsapp/kb3.webp",
        'file.alaqel2ahmed.xyz/file/kb2-whatsapp');

    getDataWhatsApp(
        'https://file.alaqel2ahmed.xyz/file/whatsapp-gold/',
        'الكاسر',
        "https://meta-code-ye.com/images/kbWhatsapp/kb4.webp",
        'file.alaqel2ahmed.xyz/file/whatsapp-gold');

    getDataWhatsApp(
        'https://file.alaqel2ahmed.xyz/file/kb3-whatsapp/',
        'الكاسر',
        "https://meta-code-ye.com/images/kbWhatsapp/kb2.webp",
        'file.alaqel2ahmed.xyz/file/kb3-whatsapp');

    getDataWhatsApp(
        'https://media4.appsfire.co/file/download-wa2-abo3rab-apk/',
        'ابو العرب',
        "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg4Fa_EimnmdJ8uGeMGqk36bGYrr3CpvRaoSq_zUfTMSjHp8jaek0HJ89vuj9N9VDMmuAK_3LhGk-GEPHdtfALAV03lv9ShqGwaXHi33QFus1DR0APtO-qXElYf3Ac8xYA/s800-rw-e360-l50/icon.png",
        'download-wa2-abo3rab-apk');

    getDataWhatsApp(
        'https://media4.appsfire.co/file/download-wa3-abo3rab-apk/',
        'ابو العرب',
        "https://1.bp.blogspot.com/-cIVmMTXchCQ/X3YwybEPrBI/AAAAAAAAFwY/6DAeF5rD8rsN626nOCOW2kpc8Yk4azS7wCLcBGAsYHQ/w640-h400/%25D8%25AA%25D8%25AD%25D9%2585%25D9%258A%25D9%2584%2B%25D9%2588%25D8%25AA%25D9%2586%25D8%25B2%25D9%258A%25D9%2584%2B%25D9%2588%25D8%25A7%25D8%25AA%25D8%25B3%25D8%25A7%25D8%25A8%2B%25D8%25A7%25D9%2584%25D8%25A7%25D8%25AD%25D9%2585%25D8%25B1%2B%25D8%25A7%25D8%25A8%25D9%2588%2B%25D8%25B9%25D8%25B1%25D8%25A8.jpg",
        'download-wa3-abo3rab-apk');

    getDataWhatsApp(
        'https://media4.appsfire.co/file/download-wa4-abo3rab-apk/',
        'ابو العرب',
        "https://1.bp.blogspot.com/-cpRfRDl8sAU/X3YuyXQhGbI/AAAAAAAAFwM/Df58UV68Org1MlLQLT7r_QFW0B0yp0i7ACLcBGAsYHQ/w640-h400/%25D8%25AA%25D8%25AD%25D9%2585%25D9%258A%25D9%2584%2B%25D9%2588%25D8%25AA%25D9%2586%25D8%25B2%25D9%258A%25D9%2584%2B%25D9%2588%25D8%25A7%25D8%25AA%25D8%25B3%25D8%25A7%25D8%25A8%2B%25D8%25A7%25D9%2584%25D8%25A7%25D8%25B2%25D8%25B1%25D9%2582%2B%25D8%25A7%25D8%25A8%25D9%2588%2B%25D8%25B9%25D8%25B1%25D8%25A8.jpg",
        'download-wa4-abo3rab-apk');

    getDataWhatsApp(
        'https://media4.appsfire.co/file/download-wa-abo3rab-apk/',
        'ابو العرب',
        "https://1.bp.blogspot.com/-l1FkUouiojk/X3YxoRGePFI/AAAAAAAAFwg/8EpPAWjqu_IEGA7UJMtaqVYjNhuBtzo_wCLcBGAsYHQ/w640-h400/%25D8%25AA%25D8%25AD%25D9%2585%25D9%258A%25D9%2584%2B%25D9%2588%25D8%25AA%25D9%2586%25D8%25B2%25D9%258A%25D9%2584%2B%25D9%2588%25D8%25A7%25D8%25AA%25D8%25B3%25D8%25A7%25D8%25A8%2B%25D8%25A8%25D9%2584%25D8%25B3%2B%25D8%25A7%25D9%2584%25D8%25A7%25D8%25AE%25D8%25B6%25D8%25B1%2B%25D8%25A7%25D8%25A8%25D9%2588%2B%25D8%25B9%25D8%25B1%25D8%25A8.jpg",
        'download-wa-abo3rab-apk');

    getDataWhatsApp(
        'https://www.mediafire.com/file_premium/1dvgle5pyqhmzu6/WA%252B1-v34.00_Developed_by_Abu_Saddam.apk/file',
        'صدام الرفاعي1',
        "https://appplayr.com/wp-content/uploads/2023/03/%D8%AA%D9%86%D8%B2%D9%8A%D9%84-34-150x150.jpeg",
        'WA%252B1-v34.00_Developed_by_Abu_Saddam.apk');
    getDataWhatsApp(
        'https://www.mediafire.com/file_premium/v3q825e00hftmj5/WA%252B2-v34.00_Developed_by_Abu_Saddam.apk/file',
        '2صدام الرفاعي',
        "https://3.bp.blogspot.com/-FKrAcVQWFmE/Wdo01oJdJGI/AAAAAAAAYJA/Nd8sn1YxuXkAkV9kgOsBzeV6RSrjR-AvgCLcBGAs/s1600/whatsapp-red-400x400.png",
        'WA%252B2-v34.00_Developed_by_Abu_Saddam.apk');
    getDataWhatsApp(
        'https://www.mediafire.com/file_premium/nnwyr0iv5sr357r/WA%252B3-v34.00_Developed_by_Abu_Saddam.apk/file',
        '3صدام الرفاعي',
        "https://bramj4plus.com/wp-content/uploads/2015/01/whatsapp-plus-abo2sadam.jpg",
        'WA%252B3-v34.00_Developed_by_Abu_Saddam.apk');
    getDataWhatsApp(
        'https://www.mediafire.com/file_premium/v23zct3okxo7u55/WA%252B4-v34.00_Developed_by_Abu_Saddam.apk/file',
        '4صدام الرفاعي',
        "https://watsplusapk.com/wp-content/uploads/2023/05/whatsappviolet.png",
        'WA%252B4-v34.00_Developed_by_Abu_Saddam.apk');

    // getDataWhatsApp('', '', "", '');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    final providerOfPop = Provider.of<ProviderTabPop>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("نسخ الواتساب"),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: elementeWidget.gradient,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 88, 86, 86).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        )),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                    bottom: 15, top: 7, left: 7, right: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 88, 86, 86).withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    gradient: elementeWidget.gradient),
                child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(urlWhatsapp.length, (index) {
                      Whatsapp whatsapp = urlWhatsapp[index];
                      return GestureDetector(
                          onTap: () async {
                            print(whatsapp.url);
                            final idtab = await providerOfPop.getIdTab();
                            provider.elementeWidget.pushed(
                                WebViewSearch(url: whatsapp.url, idTabs: idtab),
                                context);

                            // await processData.twitter2Down(
                            //     "https://twitter.com/Brazzers/status/1704740093259374889?t=b5AAAAHy4IGyrPfBBaWfbA&s=19");
                          },
                          child: Container(
                              child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(100.0)),
                                      child: elementeWidget
                                          .circulCatchImageNetwork(
                                              whatsapp.urlImg))),
                              Text(
                                "${whatsapp.name.length > 10 ? whatsapp.name.substring(0, 10) + '..' : whatsapp.name}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )));
                    })),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getDataWhatsApp(
      String url, String name, String urlImg, String contion) async {
    try {
      final model =
          await processData.getDataWhatsApp(url, name, urlImg, contion);
      if (model != null) {
        setState(() {
          urlWhatsapp.add(model);
        });
      }
    } catch (e) {}
  }
}
