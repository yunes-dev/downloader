import 'package:download_every_thing/another/searchDirctly/searchDirctly.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:auto_size_text/auto_size_text.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class BodyHomsScreen extends StatefulWidget {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  BodyHomsScreen({super.key});
  @override
  State<BodyHomsScreen> createState() => _BodyHomsScreenState();
}

class _BodyHomsScreenState extends State<BodyHomsScreen> {
  final GlobalKey closeKey = GlobalKey();
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNodes = List<FocusNode>.generate(
      18,
      (int i) => FocusNode(debugLabel: 'Onboarding Focus Node $i'),
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
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
            titleText: ' التنزيلات',
            bodyText: 'اضغط هذ الرز للدخول الى التنزيلات',
            shape: const CircleBorder(),
            fullscreen: false,
            overlayColor: Colors.blue.withOpacity(0.9),
            overlayShape: const CircleBorder(),
            hasLabelBox: true,
            hasArrow: false,
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
            titleText: ' البحث',
            bodyText:
                'قم بأدخال رابط الفيديو او الملف للتحميل \n او قم بلصق الرابط للتصفح \n او قم بالحث ايضا للتصفح',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25), bottom: Radius.circular(25)),
            ),
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
          // OnboardingStep(
          //   focusNode: focusNodes[2],
          //   titleText: 'right fab',
          //   bodyText: 'Tap only here to increment',
          //   shape: const CircleBorder(),
          //   fullscreen: false,
          //   overlayColor: Colors.blue.withOpacity(0.9),
          //   overlayShape: const CircleBorder(),
          //   overlayBehavior: HitTestBehavior.deferToChild,
          //   showPulseAnimation: true,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[3],
          //   titleText: 'Easy to customize Easy to customize',
          //   titleTextColor: Colors.greenAccent,
          //   titleTextStyle: const TextStyle(
          //     fontSize: 46.0,
          //     fontStyle: FontStyle.italic,
          //     fontWeight: FontWeight.w900,
          //   ),
          //   bodyText:
          //       'Easy to customize Easy to customize Easy to customize Easy to customize',
          //   bodyTextColor: Colors.greenAccent,
          //   bodyTextStyle: const TextStyle(
          //     color: Colors.red,
          //     fontSize: 12.0,
          //     fontStyle: FontStyle.italic,
          //   ),
          //   overlayColor: Colors.red.withOpacity(0.9),
          //   labelBoxPadding: const EdgeInsets.all(16.0),
          //   labelBoxDecoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          //     color: const Color(0xFF1100FF),
          //     border: Border.all(
          //       color: const Color(0xFFE2FB05),
          //       width: 1.0,
          //       style: BorderStyle.solid,
          //     ),
          //   ),
          //   arrowPosition: ArrowPosition.autoVertical,
          //   hasArrow: true,
          //   hasLabelBox: true,
          //   textAlign: TextAlign.center,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[4],
          //   titleText: 'Menu',
          //   bodyText: 'You can open menu from here',
          //   overlayColor: Colors.green.withOpacity(0.9),
          //   shape: const CircleBorder(),
          //   overlayBehavior: HitTestBehavior.translucent,
          //   onTapCallback: (
          //     TapArea area,
          //     VoidCallback next,
          //     VoidCallback close,
          //   ) {
          //     log('tap callback $area');
          //     if (area == TapArea.hole) {
          //       next();
          //     }
          //   },
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[5],
          //   titleText: 'Close menu',
          //   bodyText: 'Click here to close the drawer',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: const CircleBorder(),
          //   labelBoxDecoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          //     color: const Color(0xFF1100FF),
          //     border: Border.all(
          //       color: const Color(0xFFE2FB05),
          //       width: 1.0,
          //       style: BorderStyle.solid,
          //     ),
          //   ),
          //   hasLabelBox: true,
          //   hasArrow: true,
          //   overlayBehavior: HitTestBehavior.translucent,
          //   margin: const EdgeInsets.all(0),
          //   onTapCallback: (
          //     TapArea area,
          //     VoidCallback next,
          //     VoidCallback close,
          //   ) {
          //     log('tap callback $area');
          //     if (area == TapArea.hole) {
          //       next();
          //     }
          //   },
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[6],
          //   titleText: 'Counter Value',
          //   bodyText: 'With automatic vertical positioning of the text',
          //   labelBoxPadding: const EdgeInsets.all(16.0),
          //   labelBoxDecoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          //     color: const Color(0xFF1100FF),
          //     border: Border.all(
          //       color: const Color(0xFFE2FB05),
          //       width: 1.0,
          //       style: BorderStyle.solid,
          //     ),
          //   ),
          //   arrowPosition: ArrowPosition.autoVertical,
          //   hasArrow: true,
          //   hasLabelBox: true,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[7],
          //   titleText: "Or no widget at all! You're all done!",
          //   textAlign: TextAlign.center,
          //   bodyText: "Or no widget at all! You're all done!",
          //   margin: EdgeInsets.zero,
          //   labelBoxPadding: const EdgeInsets.all(8.0),
          //   // shape: const CircleBorder(),
          //   // overlayShape: const CircleBorder(),
          //   fullscreen: true,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[8],
          //   titleText: 'Icon 1',
          //   shape: const CircleBorder(),
          //   bodyText: 'Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: const CircleBorder(),
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[9],
          //   titleText: 'Icon 2',
          //   shape: BeveledRectangleBorder(
          //     borderRadius: BorderRadius.circular(15.0),
          //   ),
          //   bodyText:
          //       'Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: const CircleBorder(),
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[10],
          //   titleText: 'Icon 3',
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(16.0),
          //   ),
          //   bodyText:
          //       'Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: const CircleBorder(),
          //   hasArrow: true,
          //   hasLabelBox: true,
          //   labelBoxDecoration: BoxDecoration(color: Colors.orange.shade900),
          //   arrowPosition: ArrowPosition.autoVertical,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[11],
          //   titleText: 'Icon 4',
          //   shape: ContinuousRectangleBorder(
          //     borderRadius: BorderRadius.circular(16.0),
          //   ),
          //   bodyText:
          //       'Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: const CircleBorder(),
          //   hasArrow: true,
          //   hasLabelBox: true,
          //   labelBoxDecoration: const BoxDecoration(color: Colors.green),
          //   arrowPosition: ArrowPosition.autoVertical,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[12],
          //   titleText: 'Icon 5',
          //   shape: const CircleBorder(),
          //   bodyText: 'Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: const CircleBorder(),
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[13],
          //   titleText: 'No icon',
          //   bodyText: 'No iconNo iconNo iconNo iconNo iconNo iconNo iconNo ',
          //   fullscreen: true,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   hasArrow: true,
          //   hasLabelBox: true,
          //   labelBoxDecoration: const BoxDecoration(color: Colors.purple),
          //   arrowPosition: ArrowPosition.autoVertical,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[14],
          //   titleText: 'Icon 7',
          //   shape: const CircleBorder(),
          //   bodyText: 'Icon 7Icon 7Icon 7Icon 7Icon ',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: const CircleBorder(),
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[15],
          //   titleText: 'Icon 8',
          //   shape: const CircleBorder(),
          //   bodyText: 'Icon 8Icon 8Icon 8Icon 8Icon 8Icon 8Icon ',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(28.0),
          //   ),
          //   hasArrow: true,
          //   hasLabelBox: true,
          //   labelBoxDecoration: BoxDecoration(color: Colors.cyan.shade900),
          //   arrowPosition: ArrowPosition.autoVertical,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[16],
          //   titleText: 'Icon 9',
          //   shape: const CircleBorder(),
          //   bodyText: 'Icon 9Icon 9Icon 9Icon 9Icon ',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: BeveledRectangleBorder(
          //     borderRadius: BorderRadius.circular(30.0),
          //   ),
          //   hasArrow: true,
          //   hasLabelBox: true,
          //   labelBoxDecoration: BoxDecoration(
          //     color: Colors.pink.shade900,
          //   ),
          //   arrowPosition: ArrowPosition.autoVertical,
          // ),
          // OnboardingStep(
          //   focusNode: focusNodes[17],
          //   titleText: 'Icon 10',
          //   shape: const CircleBorder(),
          //   bodyText: 'Icon 10Icon 10Icon 10Icon 10Icon 10Icon 10Icon',
          //   fullscreen: false,
          //   overlayColor: Colors.black.withOpacity(0.8),
          //   overlayShape: ContinuousRectangleBorder(
          //     borderRadius: BorderRadius.circular(30.0),
          //   ),
          // ),
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
        child: SafeArea(
          child: SearchDirctly(
            url: '',
            typeWork: 'share',
          ),
        ),
      ),
      //  SafeArea(
      //   child: Column(
      //     children: [
      //       Container(
      //         color: elementeWidget.darkColor,
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: GestureDetector(
      //                 onTap: () async {
      //                   // BackGroundWorker().checkClipboardForText();
      //                   elementeWidget.pushed(SearchInList(), context);
      //                 },
      //                 child: Container(
      //                   height: MediaQuery.of(context).size.height / 25,
      //                   decoration: const BoxDecoration(
      //                     color: Color.fromARGB(255, 203, 198, 198),
      //                     borderRadius: BorderRadius.vertical(
      //                         top: Radius.circular(20),
      //                         bottom: Radius.circular(20)),
      //                   ),
      //                   child: const Row(
      //                     children: [
      //                       SizedBox(
      //                         width: 10,
      //                       ),
      //                       Icon(Icons.search),
      //                       SizedBox(
      //                         width: 5,
      //                       ),
      //                       Text('البحث أو ادخال عنوان URL',
      //                           style: TextStyle(
      //                             fontSize: 15,
      //                           ))
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             // IconButton(
      //             //   color: Colors.white,
      //             //   icon: const Icon(Icons.folder),
      //             //   onPressed: () async {
      //             //     elementeWidget.pushed(FilesDownloadPath(), context);
      //             //   },
      //             // ),
      //             IconButton(
      //               color: Colors.white,
      //               icon: const Icon(Icons.download),
      //               onPressed: () async {
      //                 elementeWidget.pushed(ListTitleDownLOader(), context);
      //                 //elementeWidget.pushed(HomeWebView(), context);
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //       //  tabs[current].widget,
      //       Expanded(
      //         child: Center(
      //             child: SearchDirctly(
      //           url: '',
      //           typeWork: 'share',
      //         )),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
