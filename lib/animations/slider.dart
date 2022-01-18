import 'package:flutter/material.dart';

class WidgetSlider extends StatelessWidget {
  final Widget firstWidget;
  final Widget secondWidget;
  // final Widget thirdWidget;
  final AnimationController sliderController;
  // final AnimationController sliderController1;

    const WidgetSlider(
      {Key? key, required this.firstWidget,
        required this.secondWidget,
        required this.sliderController,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: Tween(
            begin: const Offset(0, 0),
            end: const Offset(-1.2, 0),
          ).animate(
            CurvedAnimation(parent: sliderController, curve: Curves.easeInBack),
          ),
          child: firstWidget,
        ),
        SlideTransition(
          position: Tween(
            begin: const Offset(1.2, 0),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(parent: sliderController, curve: Curves.easeInBack),
          ),
          child: secondWidget,
        ),
        // SlideTransition(
        //   position: Tween(
        //     begin: Offset(2.2, 0),
        //     end: Offset(0, 0),
        //   ).animate(
        //     CurvedAnimation(parent: sliderController1, curve: Curves.easeInBack),
        //   ),
        //   child: thirdWidget,
        // ),
      ],
    );
  }
}