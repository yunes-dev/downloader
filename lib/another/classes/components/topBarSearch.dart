import 'package:download_every_thing/another/classes/components/classStaticLists.dart';
import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:download_every_thing/another/classes/models/search.dart';
import 'package:download_every_thing/another/tabsWebVewPop/providerTabPop.dart';
import 'package:download_every_thing/another/webviewSearch/webViewSearch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBarSearch extends StatelessWidget {
  const TopBarSearch({super.key});

  @override
  Widget build(BuildContext context) {
    Components components = Components();
    List<Search> localSearch = ClassStaticLists().localSearch;
    final providerOfPop = Provider.of<ProviderTabPop>(context, listen: false);
    return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(localSearch.length, (index) {
          Search search = localSearch[index];
          return GestureDetector(
              onTap: () async {
                final idtab = await providerOfPop.getIdTab();
                components.pushed(
                    WebViewSearch(url: search.search_search, idTabs: idtab),
                    context);
              },
              child: Container(
                  child: Chip(
                avatar: Image.asset(search.img),
                label: Text(
                  search.nameUrl.length > 14
                      ? search.nameUrl.substring(0, 14)
                      : search.nameUrl,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
              )));
        }));
  }
}
