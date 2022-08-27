import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: CircleAvatar(
            radius: getProportionateHeight(170, constraints),
            backgroundColor: createMaterialColor(Theme.of(context).primaryColor)
                .shade100
                .withOpacity(constraints.maxWidth < 600 ? 0.9 : 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  "assets/loader.json",
                  height: getProportionateHeight(170, constraints),
                  width: getProportionateHeight(300, constraints),
                ),
                TextWidget(
                  "Please Wait Until We\nLoad Your Data...".toUpperCase(),
                  size: Theme.of(context).textTheme.titleSmall?.fontSize,
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}