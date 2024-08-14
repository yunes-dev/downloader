import 'package:download_every_thing/another/classes/components/classStaticLists.dart';
import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:download_every_thing/another/classes/components/listCard.dart';
import 'package:download_every_thing/another/classes/models/aboutUsModel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    List<AboutUsModel> data = ClassStaticLists.listAbuotUs;
    return Scaffold(
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
        title: const Text('اتصل بنا',
            style: TextStyle(
              fontFamily: 'Air',
            )),
        centerTitle: true,
      ),
      body: Container(
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
          ),
          padding: const EdgeInsets.all(7),
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final model = data[index];
                        return ListCard(
                            aboutUsModel: model,
                            onTap: () async {
                              try {
                                await launch(model.url);
                              } catch (e) {
                                print(e);
                              }
                            });
                      })),
            ],
          )),
    );
  }
}
