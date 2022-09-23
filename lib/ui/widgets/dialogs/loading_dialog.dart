import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constance/style.dart';
import '../../shared/ui_helpers.dart';
import '../loader/loader_widget.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({Key? key}) : super(key: key) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              child: const SizedBox(
                height: 24,
                width: 24,
                child: LoaderWidget(
                  color: primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
