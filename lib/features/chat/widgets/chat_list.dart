import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:Chatty_ui/common/provider/message_reply_provider.dart';
import 'package:Chatty_ui/common/widgets/loader.dart';
import 'package:Chatty_ui/features/chat/controller/chat_controller.dart';
import 'package:Chatty_ui/features/chat/widgets/my_message_card.dart';
import 'package:Chatty_ui/features/chat/widgets/sender_message_card.dart';

import '../../../common/enums/message_enum.dart';
import '../../../models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const ChatList({
    required this.receiverUserId,
    required this.isGroupChat,
    Key? key}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.read(messageReplyProvider.state).update((state) => MessageReply(message, isMe, messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:widget.isGroupChat ? ref.read(chatControllerProvider).groupChatStream(widget.receiverUserId) :
          ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat('hh:mm a').format(messageData.timeSent);

              if(!messageData.isSeen && messageData.receiverid == FirebaseAuth.instance.currentUser!.uid){
                ref.read(chatControllerProvider).setChatMessageSeen(context, widget.receiverUserId, messageData.messageId);
              }
              if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  onLeftSwipe: () => onMessageSwipe(
                      messageData.text, true, messageData.type
                  ),
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  isSeen: messageData.isSeen,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                onRightSwipe: () => onMessageSwipe(
                    messageData.text, false, messageData.type
                ),
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
              );
            },
          );
        }
    );
  }
}

