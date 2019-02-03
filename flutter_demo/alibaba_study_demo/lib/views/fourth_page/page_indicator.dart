import 'dart:ui';
import 'pages.dart';
import 'package:flutter/material.dart';

class PageIndicatorView extends StatelessWidget {
  final PageIndicatorViewModel viewModel;

  PageIndicatorView(
    this.viewModel
  );

  @override
  Widget build(BuildContext context) {
    final List<PageBubbleView> bubbles = [];

    for(int i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];

      var activePercent;
      if (i == viewModel.activeIndex) {
        activePercent = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftToRight) {
        activePercent = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft) {
        activePercent = viewModel.slidePercent;
      } else {
        activePercent = 0.0;
      }

      bool isHollow = i > viewModel.slidePercent || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftToRight);
      bubbles.add(
        new PageBubbleView(
          new PageBubbleViewModel(
            page.iconAssetPaht, 
            page.color, 
            isHollow, 
            activePercent
            )
        ),
      );
    }

    // 动画
    final bubbleWidth = 55.0 ;
    final baseTranslation = ((viewModel.pages.length * bubbleWidth) / 2) - (bubbleWidth / 2) ;
    var translation = baseTranslation - (viewModel.activeIndex * bubbleWidth);

    if (viewModel.slideDirection == SlideDirection.leftToRight){
        translation = bubbleWidth * viewModel.slidePercent + translation;
    }else if (viewModel.slideDirection == SlideDirection.rightToLeft){
        translation = bubbleWidth * viewModel.slidePercent - translation;
    }

    return Column(
      children: <Widget>[
        Expanded(child: Container(),),
        Transform(
          transform: Matrix4.translationValues(0, 0, 0),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bubbles,
        ),
        ),
      ],
    );
  }
}

class PageBubbleView extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubbleView(
    this.viewModel,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 65.0,
      child: Center(
        child: Container(
          width: lerpDouble(20.0, 45.0, viewModel.activePercent),
          height: lerpDouble(20.0, 45.0, viewModel.activePercent),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow
                ? const Color(0x88FFFFFF).withAlpha(0x88 * viewModel.activePercent.round())
                : const Color(0x88FFFFFF),
            border: new Border.all(
              color: viewModel.isHollow
                  ? const Color(0x88FFFFFF).withAlpha((0x88 * (1.0 - viewModel.activePercent)).round())
                  : Colors.transparent,
              width: 3.0,
          ),
        ),
        child: Opacity(
          opacity: viewModel.activePercent,
          child: Image.asset(
            viewModel.iconAssetPath,
            color: viewModel.color,
          ),
        ),
      ),
      ),
    );
  }
}

class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final activePercent;

  PageBubbleViewModel(
    this.iconAssetPath,
    this.color,
    this.isHollow,
    this.activePercent,
  );
}

class PageIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PageIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  );
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}