// // // ignore_for_file: avoid_print

// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:isolate';
// // import 'dart:math';

// // import 'package:dio/dio.dart';
// // import 'package:download_every_thing/another/notification/notification_utils.dart';
// // import 'package:easy_isolate/easy_isolate.dart';
// // import 'package:flutter/material.dart';
// // import 'package:isolate_manager/isolate_manager.dart';

// // import 'another/classes/components/components.dart';

// // // @pragma('vm:entry-point')
// // // int countEven(int num) {
// // //   print('count');
// // //   int count = 0;
// // //   while (num > 0) {
// // //     if (num % 2 == 0) {
// // //       count++;
// // //     }
// // //     num--;
// // //   }
// // //   return count;
// // // }

// // /// This must be a static or top-level function
// // ///
// // /// This function is very expensive to calculate, so I can test for un-blocking UI feature
// // // @pragma('vm:entry-point')
// // // Future<int> fibonacciRescusiveFuture(int n) async {
// // //   if (n == 0) return 0;
// // //   if (n <= 2) return 1;

// // //   // Magic code: This is only for non-blocking UI on Web platform
// // //   await Future.delayed(Duration.zero);

// // //   return await fibonacciRescusiveFuture(n - 1) +
// // //       await fibonacciRescusiveFuture(n - 2);
// // // }

// // /// This must be a static or top-level function
// // // @pragma('vm:entry-point')
// // // Future<int> fibonacciFuture(int n) async {
// // //   if (n == 0) return 0;
// // //   if (n <= 2) return 1;

// // //   double n1 = 0, n2 = 1, n3 = 1;

// // //   for (int i = 2; i <= n; i++) {
// // //     n3 = n1 + n2;
// // //     n1 = n2;
// // //     n2 = n3;

// // //     // Magic code: This is only for non-blocking UI on Web platform
// // //     await Future.delayed(Duration.zero);
// // //   }

// // //   return n3.round();
// // // }

// // /// This must be a static or top-level function
// // // @pragma('vm:entry-point')
// // // int fibonacci(int n) {
// // //   if (n == 0) return 0;
// // //   if (n == 1 || n == 2) return 1;

// // //   int n1 = 0, n2 = 1, n3 = 1;

// // //   for (int i = 2; i <= n; i++) {
// // //     n3 = n1 + n2;
// // //     n1 = n2;
// // //     n2 = n3;
// // //   }

// // //   return n3.round();
// // // }

// // // @pragma('vm:entry-point')
// // // int error(int n) {
// // //   if (n == 0) throw StateError('n == 0');
// // //   return n;
// // // }

// // ///
// // // @pragma('vm:entry-point')
// // // void isolateFunction(dynamic params) {
// // //   final channel = IsolateManagerController(params);
// // //   channel.onIsolateMessage.listen((message) async {
// // //     // Do more stuff here

// // //     final result = await fibonacciFuture(message);

// // //     // Send the result to your [onMessage] stream
// // //     channel.sendResult(result);
// // //   });
// // // }

// // /// Send the progress value before sending the final result

// // @pragma('vm:entry-point')
// // void isolateProgressFunction(dynamic params) {
// //   final channel = IsolateManagerController<String, String>(params);
// //   channel.onIsolateMessage.listen((message) async {
// //     double i = double.parse(message);
// //     final progress = {'progress': i};
// //     await Future.delayed(const Duration(milliseconds: 100));
// //     channel.sendResult(jsonEncode(progress));
// //     final result = {'result': message};
// //     channel.sendResult(jsonEncode(result));
// //   });
// // }

// // class TestIsolate extends StatefulWidget {
// //   const TestIsolate({Key? key}) : super(key: key);

// //   @override
// //   State<TestIsolate> createState() => _TestIsolateState();
// // }

// // class _TestIsolateState extends State<TestIsolate> {
// //   final isolateProgress = IsolateManager<String, String>.createOwnIsolate(
// //     isolateProgressFunction,
// //     isDebug: true,
// //   );
// //   double progress = 0;

// //   @override
// //   void initState() {
// //     initial();
// //     NotificationUtils.initNotifications();
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     isolateProgress.stop();
// //     super.dispose();
// //   }

// //   Future<void> initial() async {
// //     await isolateProgress.start();
// //   }

// //   void callIsolateProgress(int prog) async {
// //     setState(() {
// //       progress = 0;
// //     });
// //     bool callback(String value) {
// //       final decoded = jsonDecode(value) as Map<String, dynamic>;
// //       if (decoded.containsKey('progress')) {
// //         double toDouble(dynamic value) {
// //           if (value is double) return value;
// //           return double.parse(value.toString());
// //         }

// //         setState(() {
// //           progress = toDouble(decoded['progress']);
// //         });
// //         NotificationUtils().showProgressNotification(
// //             taskId: 4545878, title: 'ali', progress: progress);
// //         print(value);

// //         // Mark this value is not the final result
// //         return false;
// //       }

// //       return true;
// //     }

// //     await isolateProgress.compute(prog.toString(), callback: callback);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Multi Isolate Fibonacci'),
// //           centerTitle: true,
// //         ),
// //         body: SingleChildScrollView(
// //           child: Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const SizedBox(height: 8),
// //                 // StreamBuilder(
// //                 //   stream: isolateManager1.stream,
// //                 //   builder: (context, snapshot) {
// //                 //     if (!snapshot.hasData) {
// //                 //       isolateManager1.sendMessage(value1);
// //                 //       return const Center(
// //                 //         child: CircularProgressIndicator(),
// //                 //       );
// //                 //     }
// //                 //     return Text(
// //                 //         'Isolate1: Fibonacci at F$value1 = ${snapshot.data}');
// //                 //   },
// //                 // ),
// //                 ListTile(
// //                   title: ElevatedButton(
// //                     onPressed: () {
// //                       for (var i = 0; i < 100; i++) {
// //                         callIsolateProgress(i);
// //                       }
// //                     },
// //                     child: StreamBuilder(
// //                       stream: isolateProgress.stream,
// //                       builder: (_, snapshot) {
// //                         if (!snapshot.hasData) {
// //                           return const Text('Isolate Progress');
// //                         }

// //                         return Text('Isolate Progress: ${snapshot.data}');
// //                       },
// //                     ),
// //                   ),
// //                   subtitle: LinearProgressIndicator(
// //                     value: progress / 100,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class WorkerTest extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: FileDownloaderScreen(),
// //     );
// //   }
// // }

// // class FileDownloaderScreen extends StatefulWidget {
// //   FileDownloaderScreen({Key? key}) : super(key: key);

// //   @override
// //   _FileDownloaderScreenState createState() => _FileDownloaderScreenState();
// // }

// // class _FileDownloaderScreenState extends State<FileDownloaderScreen> {
// //   final List<DownloadItem> items =
// //       List.generate(100, (index) => DownloadItem('Item ${index + 1}'));

// //   final Map<DownloadItem, double> itemsDownloadProgress = {};

// //   void notifyProgress(DownloadItemProgressEvent event) {
// //     final item = event.item;
// //     if (itemsDownloadProgress.containsKey(item)) {
// //       itemsDownloadProgress.update(
// //         item,
// //         (value) => event.progress,
// //       );
// //     } else {
// //       itemsDownloadProgress.addAll({item: event.progress});
// //     }
// //     setState(() {});
// //   }

// //   bool hasOngoingDownload(DownloadItem item) {
// //     return itemsDownloadProgress.containsKey(item);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //     return Scaffold(
// //       body: Column(
// //         children: [
// //           SizedBox(height: 20),
// //           Text('File downloader simulation', style: theme.textTheme.headline5),
// //           SizedBox(height: 20),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: items.length,
// //               itemBuilder: (context, index) {
// //                 final item = items[index];
// //                 return Card(
// //                   child: Padding(
// //                     padding: EdgeInsets.all(8),
// //                     child: Row(
// //                       children: [
// //                         Text(item.name),
// //                         Spacer(),
// //                         Text('${item.size}mb'),
// //                         SizedBox(width: 10),
// //                         if (hasOngoingDownload(item))
// //                           SizedBox(
// //                             height: 20,
// //                             width: 20,
// //                             child: CircularProgressIndicator(
// //                               value: itemsDownloadProgress[item],
// //                             ),
// //                           )
// //                         else ...[
// //                           IconButton(
// //                             icon: Icon(Icons.download),
// //                             onPressed: () => FileDownloaderWorker(
// //                               item: item,
// //                               onNotifyProgress: notifyProgress,
// //                             ).init(),
// //                           ),
// //                         ]
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class DownloadItem {
// //   DownloadItem(this.name) : size = Random().nextInt(50);

// //   final String name;
// //   final int size;

// //   @override
// //   bool operator ==(Object other) =>
// //       identical(this, other) ||
// //       (other is DownloadItem &&
// //           runtimeType == other.runtimeType &&
// //           name == other.name &&
// //           size == other.size);

// //   @override
// //   int get hashCode => name.hashCode ^ size.hashCode;
// // }

// // class FileDownloaderWorker {
// //   FileDownloaderWorker({required this.onNotifyProgress, required this.item});

// //   final Function(DownloadItemProgressEvent event) onNotifyProgress;
// //   final DownloadItem item;
// //   final worker = Worker();

// //   /// Initiate the worker (new thread) and start listen from messages between
// //   /// the threads
// //   Future<void> init() async {
// //     await worker.init(
// //       mainMessageHandler,
// //       isolateMessageHandler,
// //       errorHandler: print,
// //     );
// //     worker.sendMessage(DownloadItemEvent(item));
// //   }

// //   /// Handle the messages coming from the isolate
// //   void mainMessageHandler(dynamic data, SendPort isolateSendPort) {
// //     if (data is DownloadItemProgressEvent) {
// //       onNotifyProgress(data);
// //     }
// //   }

// //   /// Handle the messages coming from the main
// //   static isolateMessageHandler(
// //       dynamic data, SendPort mainSendPort, SendErrorFunction sendError) async {
// //     if (data is DownloadItemEvent) {
// //       final fragmentTime = 1 / data.item.size;
// //       double progress = 0;
// //       Timer.periodic(
// //         Duration(seconds: 1),
// //         (timer) {
// //           if (progress < 1) {
// //             progress += fragmentTime;
// //             mainSendPort.send(DownloadItemProgressEvent(data.item, progress));
// //           } else {
// //             timer.cancel();
// //           }
// //         },
// //       );
// //     }
// //   }
// // }

// // class DownloadItemEvent {
// //   DownloadItemEvent(this.item);

// //   final DownloadItem item;
// // }

// // class DownloadItemProgressEvent {
// //   DownloadItemProgressEvent(this.item, this.progress);

// //   final DownloadItem item;
// //   final double progress;
// // }

// // class IsolateTest {
// //   Future<void> start(String sta) async {
// //     print('start------------------');
// //     final worker = Worker();
// //     if (sta == 'start') {
// //       await worker.init(mainHandler, isolateHandler);
// //     } else {
// //       worker.dispose();
// //     }
// //     var path = await Components().getPath('');
// //     //CancelToken cancelToken = CancelToken();
// //     Map data = {'statue': "start", 'path': path};
// //     worker.sendMessage(data);
// //   }

// //   void mainHandler(dynamic data, SendPort isolateSendPort) {
// //     NotificationUtils()
// //         .showProgressNotification(taskId: 65656, title: 'ali', progress: 5.0);
// //     print(data);
// //     Map map = {'statue': "CANCELLING", 'path': ''};
// //     Future.delayed(Duration(seconds: 10), () {
// //       isolateSendPort.send(map);
// //     });
// //   }

// //   Future<void> isolateHandler(dynamic data, SendPort mainSendPort,
// //       SendErrorFunction onSendError) async {
// //     CancelToken cancelToken = CancelToken();
// //     Dio dio = Dio();
// //     var map = data as Map;
// //     if (data["statue"] == "CANCELLING") {
// //       cancelToken.cancel();
// //     }
// //     // cancelToken = map["CancelToken"] as CancelToken;
// //     if (!cancelToken.isCancelled) {
// //       if (map["statue"] == 'start') {
// //         var path = map["path"];
// //         var url =
// //             "https://rr1---sn-txhxooxu-n5il.googlevideo.com/videoplayback?expire=1695874281&ei=iagUZdqMDIbDx_AP5suciA4&ip=134.35.82.202&id=o-AN7cduC8FAGW2DgCnSD7DY8MDyeP3HT-QCdZ4fb6Tz9f&itag=247&aitags=133%2C134%2C135%2C136%2C137%2C160%2C242%2C243%2C244%2C247%2C248%2C278&source=youtube&requiressl=yes&mh=OD&mm=31%2C29&mn=sn-txhxooxu-n5il%2Csn-hju7en7r&ms=au%2Crdu&mv=m&mvi=1&pcm2cms=yes&pl=21&initcwndbps=67500&siu=1&spc=UWF9f1GpjWhLyQfthFO14FuFjMNYoyYc6K267BlcK5e4FtRgi-bdhPQ&vprv=1&svpuc=1&mime=video%2Fwebm&ns=sH-tyGO7frntrQN5l2vy_OwP&gir=yes&clen=29818367&dur=909.808&lmt=1652397882094004&mt=1695852307&fvip=2&keepalive=yes&fexp=24007246&beids=24350017&c=WEB&txp=5437434&n=YGdeqIhFVQoQyw&sparams=expire%2Cei%2Cip%2Cid%2Caitags%2Csource%2Crequiressl%2Csiu%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Cns%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIgfjsJpYJNlzPdBF3N6HJR_qQDDFSWB8NyHpatCJsZ3mUCIQCDYagpAPzSuVVzgg9GXAyTfxPt_RzbSr41EXHpP8tGhQ%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpcm2cms%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIhAKaqyA_11ftkUY05A2CEgYg3KwbDt6h7tbreWRuoSwTUAiB6s8kzt08hEZRrM3adQiTu5sZHsOkj4yn2ga3r28AE7g%3D%3D&alr=yes&cpn=W0qTZbZQSPL_XRRG&cver=2.20230925.02.00&rn=10&pot=Ml9KABOi8ma7M0o8k-zfCvoxh4yxeVSL2T6IapMlqu1C1-mYAfznMRsZNQVq-0MHLFH5P_kAJaJ8kpsmnDOHoN57lHrtOt0DH7YyWBfPShNgdPpIdUuETPByeWs520L6uQ==&srfvp=1";
// //         await dio.download(
// //           url,
// //           "$path/test.mp4",
// //           deleteOnError: false,
// //           cancelToken: cancelToken,
// //           onReceiveProgress: (count, total) {
// //             mainSendPort.send('{prog:${count / total * 100} }');
// //           },
// //         );
// //       }
// //     }
// //     //for (var i = 0; i < 100; i++) {
// //     //print(i);
// //     // mainSendPort.send('fine what about you?');
// //     print(map);
// //     //}
// //   }
// // }

// import 'dart:convert';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:html/dom.dart';
// import 'package:html/parser.dart';

// class Extractor1 {
//   ///Define timeout in second.
//   ///
//   ///[timeout], The more timeout you will give, more accurate results you will get.
//   ///Many websites take more time to load, so direct url extraction will also take time.
//   ///Minimum 6 seconds of timeout is recommended and default timeout is also set to 6 seconds
//   ///
//   static Future<VideoData1?> getDirectLink(
//       {String link = '', int timeout = 6}) async {
//     VideoData1? res;

//     HeadlessInAppWebView(
//       initialUrlRequest: URLRequest(
//           url: Uri.parse(
//               utf8.decode(base64.decode('aHR0cHM6Ly9lbi5zYXZlZnJvbS5uZXQv')))),
//       onLoadStop: (controller, url) async {
//         await controller.evaluateJavascript(source: '''
// document.querySelector('#sf_url').value = '$link'
// document.querySelector('#sf_submit').click()
// ''');
//         var data = await Future.delayed(const Duration(seconds: 3), () async {
//           var htm = await controller.getHtml();
//           print(htm);
//           var document = parse(htm);
//           print(document.outerHtml);
//           try {
//             String? thumbnail = document
//                 .querySelector(".media-result .clip img")
//                 ?.attributes['src'];

//             var info = document.querySelector(".info-box");
//             String? title = info?.querySelector(".title")?.text;
//             String? duration = info?.querySelector(".duration")?.text;
//             List<Element> linkGroup = [
//               ...info!.querySelectorAll(".link-group a")
//             ];

//             List<Link1> links = linkGroup.map((element) {
//               String? videoFormat = element.attributes['title'];
//               String? href = element.attributes['href'];
//               String? text = element.text;
//               return Link1(videoFormat: videoFormat, href: href, text: text);
//             }).toList();

//             if (links.isEmpty) {
//               Element? element = info.querySelector(".link-download");
//               String? videoFormat = "";
//               String? href = element?.attributes['href'];
//               String? text = element?.text.replaceAll("Download", "").trim();
//               links
//                   .add(Link1(videoFormat: videoFormat, href: href, text: text));
//             }

//             VideoData1 vData = VideoData1(
//                 status: true,
//                 message: 'Success',
//                 title: title,
//                 thumbnail: thumbnail,
//                 duration: duration,
//                 links: links);
//             return vData;
//           } catch (e) {
//             return VideoData1(status: false, message: 'Please try again');
//           }
//         });
//         res = data;
//       },
//     )
//       ..run()
//       ..dispose();
//     var result = Future.delayed(Duration(seconds: timeout), () {
//       return res;
//     });
//     return result;
//   }
// }

// class VideoData1 {
//   VideoData1({
//     this.status,
//     this.message,
//     this.title,
//     this.thumbnail,
//     this.duration,
//     this.links,
//   });

//   bool? status;
//   String? message;
//   String? title;
//   String? thumbnail;
//   String? duration;
//   List<Link1>? links;
// }

// class Link1 {
//   Link1({
//     this.videoFormat,
//     this.href,
//     this.text,
//   });

//   String? videoFormat;
//   String? href;
//   String? text;
// }

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class App extends StatefulWidget {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();

  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey closeKey = GlobalKey();
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    focusNodes = List<FocusNode>.generate(
      18,
      (int i) => FocusNode(debugLabel: 'Onboarding Focus Node $i'),
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            backgroundColor: Colors.white,
          ),
        ),
        home: Onboarding(
          key: widget.onboardingKey,
          autoSizeTexts: true,
          debugBoundaries: true,
          steps: <OnboardingStep>[
            OnboardingStep(
              focusNode: focusNodes[0],
              titleText: 'Tap anywhere to continue ',
              titleTextColor: Colors.black,
              bodyText: 'Tap anywhere to continue Tap anywhere to continue',
              labelBoxPadding: const EdgeInsets.all(16.0),
              labelBoxDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: const Color(0xFF00E1FF),
                border: Border.all(
                  color: const Color(0xFF1E05FB),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              arrowPosition: ArrowPosition.autoVerticalCenter,
              hasArrow: true,
              hasLabelBox: true,
              fullscreen: true,
              overlayBehavior: HitTestBehavior.translucent,
              onTapCallback: (
                TapArea area,
                VoidCallback next,
                VoidCallback close,
              ) {},
              stepBuilder: (
                BuildContext context,
                OnboardingStepRenderInfo renderInfo,
              ) {
                return SizedBox(
                  width: 200,
                  child: Material(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            renderInfo.titleText,
                            // style: renderInfo.titleStyle,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/demo.gif',
                                width: 50,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: AutoSizeText(
                                  renderInfo.bodyText,
                                  // style: renderInfo.bodyStyle,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: renderInfo.nextStep,
                                child: const Text('Next'),
                              ),
                              TextButton(
                                onPressed: renderInfo.close,
                                child: const Text('close'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            OnboardingStep(
              focusNode: focusNodes[1],
              titleText: 'left fab',
              bodyText: 'Tap to continue',
              shape: const CircleBorder(),
              fullscreen: false,
              overlayColor: Colors.blue.withOpacity(0.9),
              overlayShape: const CircleBorder(),
              hasLabelBox: true,
              labelBoxDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: const Color(0xFF1100FF),
                border: Border.all(
                  color: const Color(0xFFE2FB05),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            OnboardingStep(
              focusNode: focusNodes[2],
              titleText: 'right fab',
              bodyText: 'Tap only here to increment',
              shape: const CircleBorder(),
              fullscreen: false,
              overlayColor: Colors.blue.withOpacity(0.9),
              overlayShape: const CircleBorder(),
              overlayBehavior: HitTestBehavior.deferToChild,
              showPulseAnimation: true,
            ),
            OnboardingStep(
              focusNode: focusNodes[3],
              titleText: 'Easy to customize Easy to customize',
              titleTextColor: Colors.greenAccent,
              titleTextStyle: const TextStyle(
                fontSize: 46.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
              ),
              bodyText:
                  'Easy to customize Easy to customize Easy to customize Easy to customize',
              bodyTextColor: Colors.greenAccent,
              bodyTextStyle: const TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
              ),
              overlayColor: Colors.red.withOpacity(0.9),
              labelBoxPadding: const EdgeInsets.all(16.0),
              labelBoxDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: const Color(0xFF1100FF),
                border: Border.all(
                  color: const Color(0xFFE2FB05),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              arrowPosition: ArrowPosition.autoVertical,
              hasArrow: true,
              hasLabelBox: true,
              textAlign: TextAlign.center,
            ),
            OnboardingStep(
              focusNode: focusNodes[4],
              titleText: 'Menu',
              bodyText: 'You can open menu from here',
              overlayColor: Colors.green.withOpacity(0.9),
              shape: const CircleBorder(),
              overlayBehavior: HitTestBehavior.translucent,
              onTapCallback: (
                TapArea area,
                VoidCallback next,
                VoidCallback close,
              ) {
                log('tap callback $area');
                if (area == TapArea.hole) {
                  next();
                }
              },
            ),
            OnboardingStep(
              focusNode: focusNodes[5],
              titleText: 'Close menu',
              bodyText: 'Click here to close the drawer',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
              labelBoxDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: const Color(0xFF1100FF),
                border: Border.all(
                  color: const Color(0xFFE2FB05),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              hasLabelBox: true,
              hasArrow: true,
              overlayBehavior: HitTestBehavior.translucent,
              margin: const EdgeInsets.all(0),
              onTapCallback: (
                TapArea area,
                VoidCallback next,
                VoidCallback close,
              ) {
                log('tap callback $area');
                if (area == TapArea.hole) {
                  next();
                }
              },
            ),
            OnboardingStep(
              focusNode: focusNodes[6],
              titleText: 'Counter Value',
              bodyText: 'With automatic vertical positioning of the text',
              labelBoxPadding: const EdgeInsets.all(16.0),
              labelBoxDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: const Color(0xFF1100FF),
                border: Border.all(
                  color: const Color(0xFFE2FB05),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              arrowPosition: ArrowPosition.autoVertical,
              hasArrow: true,
              hasLabelBox: true,
            ),
            OnboardingStep(
              focusNode: focusNodes[7],
              titleText: "Or no widget at all! You're all done!",
              textAlign: TextAlign.center,
              bodyText: "Or no widget at all! You're all done!",
              margin: EdgeInsets.zero,
              labelBoxPadding: const EdgeInsets.all(8.0),
              // shape: const CircleBorder(),
              // overlayShape: const CircleBorder(),
              fullscreen: true,
            ),
            OnboardingStep(
              focusNode: focusNodes[8],
              titleText: 'Icon 1',
              shape: const CircleBorder(),
              bodyText: 'Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[9],
              titleText: 'Icon 2',
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              bodyText:
                  'Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[10],
              titleText: 'Icon 3',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              bodyText:
                  'Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: BoxDecoration(color: Colors.orange.shade900),
              arrowPosition: ArrowPosition.autoVertical,
            ),
            OnboardingStep(
              focusNode: focusNodes[11],
              titleText: 'Icon 4',
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              bodyText:
                  'Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: const BoxDecoration(color: Colors.green),
              arrowPosition: ArrowPosition.autoVertical,
            ),
            OnboardingStep(
              focusNode: focusNodes[12],
              titleText: 'Icon 5',
              shape: const CircleBorder(),
              bodyText:
                  'Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[13],
              titleText: 'No icon',
              bodyText: 'No iconNo iconNo iconNo iconNo iconNo iconNo iconNo ',
              fullscreen: true,
              overlayColor: Colors.black.withOpacity(0.8),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: const BoxDecoration(color: Colors.purple),
              arrowPosition: ArrowPosition.autoVertical,
            ),
            OnboardingStep(
              focusNode: focusNodes[14],
              titleText: 'Icon 7',
              shape: const CircleBorder(),
              bodyText: 'Icon 7Icon 7Icon 7Icon 7Icon ',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[15],
              titleText: 'Icon 8',
              shape: const CircleBorder(),
              bodyText: 'Icon 8Icon 8Icon 8Icon 8Icon 8Icon 8Icon ',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: BoxDecoration(color: Colors.cyan.shade900),
              arrowPosition: ArrowPosition.autoVertical,
            ),
            OnboardingStep(
              focusNode: focusNodes[16],
              titleText: 'Icon 9',
              shape: const CircleBorder(),
              bodyText: 'Icon 9Icon 9Icon 9Icon 9Icon ',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: BoxDecoration(
                color: Colors.pink.shade900,
              ),
              arrowPosition: ArrowPosition.autoVertical,
            ),
            OnboardingStep(
              focusNode: focusNodes[17],
              titleText: 'Icon 10',
              shape: const CircleBorder(),
              bodyText: 'Icon 10Icon 10Icon 10Icon 10Icon 10Icon 10Icon',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ],
          onChanged: (int index) {
            if (index == 4) {
              // close the drawer
              // if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
              //   scaffoldKey.currentState?.openEndDrawer();
              // }
              // interrupt onboarding on specific step
              // widget.onboardingKey.currentState.hide();
            }
            final int? currentIndex =
                widget.onboardingKey.currentState?.controller.currentIndex;

            print('currentIndex $currentIndex');
          },
          child: Home(
            focusNodes: focusNodes,
          ),
        ),
      );
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.focusNodes,
  }) : super(key: key);

  final List<FocusNode> focusNodes;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _increment(BuildContext context) {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          focusNode: widget.focusNodes[4],
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Focus(
          focusNode: widget.focusNodes[3],
          child: const Text('Super Long Title'),
        ),
        actions: [
          IconButton(
            // focusNode: widget.focusNodes[5],
            icon: const Icon(Icons.mic),
            onPressed: () {},
          ),
          IconButton(
            // focusNode: widget.focusNodes[5],
            icon: const Icon(Icons.subscript),
            onPressed: () {},
          ),
          IconButton(
            // focusNode: widget.focusNodes[5],
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              focusNode: widget.focusNodes[5],
              title: const Text('Close menu'),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return index == 5
              ? Focus(
                  focusNode: widget.focusNodes[13],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Focus(
                            focusNode: widget.focusNodes[0],
                            child: TextButton(
                              child: const Text(
                                  'You have pushed the button this many times:'),
                              onPressed: () {
                                print('do something');
                              },
                            ),
                          ),
                          Focus(
                            focusNode: widget.focusNodes[6],
                            child: Text(
                              '$_counter',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : ListTile(
                  leading: Focus(
                    child: const Icon(Icons.alarm),
                    focusNode: widget.focusNodes[index + 8],
                  ),
                  title: Text('Item ${index + 1}'),
                  trailing: Text('${index + 8}'),
                );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   focusNode: widget.focusNodes[1],
      //   onPressed: () {
      //     final OnboardingState? onboarding = Onboarding.of(context);
      //     if (onboarding != null) {
      //       onboarding.show();
      //     }
      //   },
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              focusNode: widget.focusNodes[1],
              onPressed: () {
                final OnboardingState? onboarding = Onboarding.of(context);
                if (onboarding != null) {
                  onboarding.show();
                }
              },
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              focusNode: widget.focusNodes[2],
              onPressed: () {
                _increment(context);
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
