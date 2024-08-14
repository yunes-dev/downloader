// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:download_every_thing/another/tabsWebVewPop/providerTabPop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class PopTabWeb extends StatelessWidget {
  String id_tab;
  String name_tab;
  String url_tab;
  Uint8List img;
  PopTabWeb(
      {super.key,
      required this.id_tab,
      required this.name_tab,
      required this.url_tab,
      required this.img});

  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderTabPop>(context, listen: false);
    return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
            side: id_tab == provider.idTab
                ? const BorderSide(
                    // border color
                    color: Colors.black,
                    // border thickness
                    width: 2)
                : BorderSide.none,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            )),
        child: InkWell(
          onTap: () async {
            await provider.setNewIdTab(id_tab);
            Navigator.of(context).pop();
          },
          child: Column(
            children: [
              ListTile(
                tileColor: Colors.black12,
                selected: id_tab == provider.idTab,
                selectedColor: Colors.white,
                selectedTileColor: Colors.black,
                contentPadding: const EdgeInsets.only(left: 10),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: Row(mainAxisSize: MainAxisSize.max, children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.access_alarms_outlined),
                  ),
                  Expanded(
                      child: Text(
                    name_tab,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ))
                ]),
                trailing: IconButton(
                    onPressed: () async {
                      var idtab = await provider.getIdTab();
                      if (id_tab == idtab &&
                          provider.obListWeb!.listWeb.length <= 1) {
                        provider.closeTabWeb(id_tab);
                        provider.addTabWeb(
                          'https://www.youtube.com/',
                          'google',
                          Uint8List.fromList([]),
                        );
                        await provider.upDateAllList();
                        final mod = provider.obListWeb?.listWeb.last;
                        await provider.setNewIdTab(mod!.id_tab);
                        Navigator.of(context).pop();
                      } else if (id_tab == idtab &&
                          provider.obListWeb!.listWeb.length > 1) {
                        var index = provider.obListWeb?.listWeb
                            .indexWhere((element) => element.id_tab == id_tab);
                        if (index == 0) {
                          provider.closeTabWeb(id_tab);
                          int ind = index! + 1;
                          provider.idTab =
                              provider.obListWeb!.listWeb[ind].id_tab;
                          await provider.setNewIdTab(
                              provider.obListWeb!.listWeb[ind].id_tab);
                        } else {
                          provider.closeTabWeb(id_tab);
                          int ind = index! - 1;
                          provider.idTab =
                              provider.obListWeb!.listWeb[ind].id_tab;
                          await provider.setNewIdTab(
                              provider.obListWeb!.listWeb[ind].id_tab);
                        }
                      } else {
                        provider.closeTabWeb(id_tab);
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                    )),
              ),
              Expanded(
                  child: Ink(
                decoration: img.isNotEmpty
                    ? BoxDecoration(
                        image: DecorationImage(
                        image: MemoryImage(img),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ))
                    : null,
              ))
            ],
          ),
        ));
  }
}
