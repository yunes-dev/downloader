import 'dart:typed_data';
import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:download_every_thing/another/tabsWebVewPop/providerTabPop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tabsWebVewPop/popTabWeb.dart';

class TabsPopList extends StatelessWidget {
  const TabsPopList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderTabPop>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          flexibleSpace: Container(
              //padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
            gradient: Components().gradient,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 88, 86, 86).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          )),
          title: Text('النوافذ'),
          leading: IconButton(
              onPressed: () async {
                provider.addTabWeb(
                  'https://www.youtube.com/',
                  'google',
                  Uint8List.fromList([]),
                );
                await provider.upDateAllList();
                final mod = provider.obListWeb?.listWeb.last;
                await provider.setNewIdTab(mod!.id_tab);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.add)),
          actions: [
            IconButton(
                onPressed: () async {
                  provider.closeAllTabWeb();
                  provider.addTabWeb(
                    'https://www.youtube.com/',
                    'google',
                    Uint8List.fromList([]),
                  );
                  await provider.upDateAllList();
                  final mod = provider.obListWeb?.listWeb.last;
                  await provider.setNewIdTab(mod!.id_tab);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.clear_all_sharp)),
          ],
          centerTitle: true,
        ),
        body: Container(
            child: provider.obListWeb?.listWeb.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: provider.obListWeb?.listWeb.length,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 300,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final tabs = provider.obListWeb?.listWeb[index];
                          return PopTabWeb(
                            id_tab: tabs!.id_tab,
                            name_tab: tabs.name_tab,
                            url_tab: tabs.url_tab,
                            img: tabs.img,
                          );
                        }),
                  )),
      );
    });
  }
}
