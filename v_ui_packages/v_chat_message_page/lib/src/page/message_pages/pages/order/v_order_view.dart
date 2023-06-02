// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/order/v_order_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_message_page.dart';
import '../../../../v_chat/v_search_app_bare.dart';
import '../../../../widgets/app_bare/v_message_app_bare.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/input_widget_state.dart';
import '../../widget_states/message_body_state_widget.dart';
import 'order_app_bar_controller.dart';

class VOrderView extends StatefulWidget {
  const VOrderView({
    Key? key,
    required this.vRoom,
    required this.vMessageConfig,
  }) : super(key: key);
  final VRoom vRoom;
  final VMessageConfig vMessageConfig;

  @override
  State<VOrderView> createState() => _VOrderViewState();
}

class _VOrderViewState extends State<VOrderView> {
  late final VOrderController controller;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = VOrderController(
      vRoom: widget.vRoom,
      vMessageConfig: widget.vMessageConfig,
      context: context,
      messageProvider: provider,
      scrollController: AutoScrollController(
        axis: Axis.vertical,
        suggestedRowHeight: 200,
      ),
      inputStateController: InputStateController(widget.vRoom),
      orderAppBarController: OrderAppBarController(
        vRoom: widget.vRoom,
        messageProvider: provider,
      ),
      itemController: VMessageItemController(
        messageProvider: provider,
        context: context,
        vMessageConfig: widget.vMessageConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<OrderAppBarStateModel>(
          valueListenable: controller.orderAppBarController,
          builder: (_, value, __) {
            if (value.isSearching) {
              return VSearchAppBare(
                onClose: controller.onCloseSearch,
                onSearch: controller.onSearch,
              );
            }
            return VMessageAppBare(
              isCallAllowed: widget.vMessageConfig.isCallsAllowed,
              onSearch: controller.onOpenSearch,
              room: widget.vRoom,
              inTypingText: value.typingText,
              lastSeenAt: value.lastSeenAt,
              onUpdateBlock: controller.onUpdateBlock,
              onCreateCall: controller.onCreateCall,
              onViewMedia: () => controller.onViewMedia(context, value.roomId),
              onTitlePress: controller.onTitlePress,
            );
          },
        ),
      ),
      body: Container(
        decoration: context.vMessageTheme.scaffoldDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.vMessageConfig.showDisconnectedWidget)
              const VSocketStatusWidget(
                delay: Duration.zero,
              ),
            MessageBodyStateWidget(
              controller: controller,
              roomType: widget.vRoom.roomType,
            ),
            const SizedBox(
              height: 5,
            ),
            InputWidgetState(
              controller: controller,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
