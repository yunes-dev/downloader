// ignore_for_file: must_be_immutable

import 'package:download_every_thing/another/tabsWebVewPop/providerTabPop.dart';
import 'package:download_every_thing/another/webviewSearch/webViewSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../download/providerDownload.dart';

class SearchInList extends StatelessWidget {
  SearchInList({super.key, required this.getUrl});
  Function(String url, String work) getUrl;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    final providerOfPop = Provider.of<ProviderTabPop>(context, listen: false);
    return Column(
      children: [
        // MyWidget(itemSearch: localSearch),
        GestureDetector(
          onTap: () {
            provider.itemSearch.forEach((element) {
              provider.deleteData(
                  element.id_search, 'search', 'id_search', 'select');
            });
            provider.itemSearch.clear();
          },
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.clear_rounded),
                Text('مسح سجل البحث'),
              ],
            ),
          ),
        ),
        Consumer<ProviderDownload>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(provider.itemSearch.length, (index) {
                    var search = provider.itemSearch[index];
                    return Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          children: [
                            Container(
                              child: Card(
                                child: ListTile(
                                  onTap: () async {
                                    getUrl(search.search_search, "show");
                                    final idtab =
                                        await providerOfPop.getIdTab();
                                    // ignore: use_build_context_synchronously
                                    provider.elementeWidget.pushed(
                                        WebViewSearch(
                                            url: search.search_search,
                                            idTabs: idtab),
                                        context);
                                  },
                                  title: Text(search.nameUrl),
                                  subtitle: Text(
                                    search.search_search,
                                    softWrap:
                                        true, // Allow text to wrap to the next line
                                    maxLines:
                                        1, // Specify the maximum number of lines
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                          onPressed: () {
                                            getUrl(
                                                search.search_search, "down");
                                          },
                                          icon: Icon(
                                            Icons.download,
                                            color: Colors.lightBlue,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: search.search_search));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text('تم نسخ الرابط'),
                                            ));
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: const Color.fromARGB(
                                                255, 187, 186, 186),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ));
                  })),
            );
          },
        )
      ],
    );
  }
}
