import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Chatty_ui/colors.dart';
import 'package:Chatty_ui/common/provider/message_reply_provider.dart';
import 'package:Chatty_ui/features/chat/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({
    Key? key,
  }) : super(key: key);

  void cancelReply(WidgetRef ref) {
    //set it to the previous state of the application
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )
      ),
      width: 350,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Expanded(
                  child: Text(
                    messageReply!.isMe ? 'You' : 'Sender',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ),
                GestureDetector(
                  child: const Icon(Icons.close, size: 16,),
                  onTap: () => cancelReply(ref),
                )
              ]
          ),
          const SizedBox(height: 8,),
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8)
            ),
              child: DisplayTextImageGIF(
                  message: messageReply.message, type: messageReply.messageEnum
              )
          ),
        ],
      ),
    );
  }
}