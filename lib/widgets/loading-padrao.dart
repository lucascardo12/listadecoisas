import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/global.dart';

class LoadPadrao extends GetView {
  final gb = Get.find<Global>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(height: 20),
          Text(
            '...Carregando 📑',
            style: Get.textTheme.headline5!.copyWith(color: gb.getSecondary()),
          )
        ],
      ),
    );
  }
}
