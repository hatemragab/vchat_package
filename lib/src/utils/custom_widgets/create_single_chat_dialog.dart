import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';

class CreateSingleChatDialog extends StatelessWidget {
  final String? titleTxt;
  final String? createBtnTxt;

  String txt = "";

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Material(
        child: CupertinoAlertDialog(
          title: titleTxt != null
              ? titleTxt!.text
              : VChatAppService.to.getTrans().sayHello().text,
          content: TextField(
            onChanged: (value) {
              txt = value;
            },
          ),
          actions: [
            TextButton(onPressed: ()=>Navigator.pop(context), child: VChatAppService.to.getTrans().cancel().text.color(Colors.red)),
            TextButton(
              onPressed: () async {
                if (txt.isNotEmpty) {
                  Navigator.pop(context, txt);
                }
              },
              child: createBtnTxt != null
                  ? createBtnTxt!.text
                  : VChatAppService.to.getTrans().create().text,
            ),

          ],
        ),
      );
    } else {}
    return AlertDialog(
      title: titleTxt != null
          ? titleTxt!.text
          : VChatAppService.to.getTrans().sayHello().text,
      content: TextField(
        onChanged: (value) {
          txt = value;
        },
      ),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(context), child: VChatAppService.to.getTrans().cancel().text.color(Colors.red)),
        TextButton(
          onPressed: () async {
            if (txt.isNotEmpty) {
              Navigator.pop(context, txt);
            }
          },
          child: createBtnTxt != null
              ? createBtnTxt!.text
              : VChatAppService.to.getTrans().create().text,
        ),

      ],
    );
  }

  CreateSingleChatDialog({
    this.titleTxt,
    this.createBtnTxt,
  });
}