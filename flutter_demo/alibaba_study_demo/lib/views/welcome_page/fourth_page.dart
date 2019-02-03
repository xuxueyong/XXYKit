import 'dart:async';
import '../fourth_page/pages.dart';
import 'package:flutter/material.dart';
import '../fourth_page/page_reveal.dart';
import '../fourth_page/page_dragger.dart';
import '../fourth_page/page_indicator.dart';

class FourthPage extends StatefulWidget {
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  int nextPageIndex = 0;
  double slidePercent = 0.0;

  _FourthPageState() {
    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event){
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          print("滑动方向$slideDirection");
          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = AnimatedPageDragger(slideDirection: slideDirection,
                  slidePercent: slidePercent,
                  transitionGoal: TransitionGoal.open,
                  slideUpdateStream: slideUpdateStream,
                  vsync: this);
          } else {
            animatedPageDragger = AnimatedPageDragger(slideDirection: slideDirection,
                  slidePercent: slidePercent,
                  transitionGoal: TransitionGoal.close,
                  slideUpdateStream: slideUpdateStream,
                  vsync: this);

            nextPageIndex = activeIndex;
          }
         
          animatedPageDragger.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.slidePercent;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;
          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
          
          animatedPageDragger.dispose();
        }
      });
    });
  }

  @override
  void dispose() {
    slideUpdateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
         children: <Widget>[
           Page(viewModel: pages[activeIndex], percentVisible: 1.0),

          PageReveal(revealPercent: slidePercent,
            child: Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent,
            ), 
          ),

          PageIndicatorView(
           new PageIndicatorViewModel(
            pages,
            activeIndex,
            slideDirection, 
            slidePercent
            )
          ),

          PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
            slideUpdateStream: this.slideUpdateStream,
            )
         ],
    );
  }
}