import 'package:data_statement/intro_screens/intro_page_1.dart';
import 'package:data_statement/intro_screens/intro_page_2.dart';
import 'package:data_statement/intro_screens/intro_page_3.dart';
import 'package:data_statement/provider/dope.dart';
import 'package:data_statement/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DopeAnimation extends ConsumerWidget {
  DopeAnimation({super.key});

  PageController _controller = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              // setState(() {
              //   onLastPage = (index == 2);
              // });
              ref.read(dopeProvider.notifier).update((state) => (index == 2));
            },
            children: [
              IntroPageOne(),
              IntroPageTwo(),
              IntroPageThree(),
            ],
          ),
          Container(
              alignment: Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text("skip"),
                  ),
                  SmoothPageIndicator(controller: _controller, count: 3),
                  ref.watch(dopeProvider)
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginOrRegister()));
                          },
                          child: Text("done"),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: Duration(microseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Text("next"),
                        )
                ],
              )),
        ],
      ),
    );
  }
}
