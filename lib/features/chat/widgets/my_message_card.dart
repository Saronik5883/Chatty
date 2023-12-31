import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:Chatty_ui/colors.dart';
import 'package:Chatty_ui/features/chat/widgets/display_text_image_gif.dart';
import '../../../common/enums/message_enum.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
            minWidth: MediaQuery.of(context).size.width/3,
          ),
          child: Container(
            //color: Theme.of(context).colorScheme.secondaryContainer,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(10).copyWith(
                topRight: const Radius.circular(0),
              )
            ),

            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text ? const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ) : const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 5,
                    bottom: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(isReplying)...[
                        Container(
                          padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 3,),
                                DisplayTextImageGIF(
                                    message: repliedText, type: repliedMessageType
                                ),
                              ],
                            )
                        ),
                        const SizedBox(height: 8,),
                      ],
                      DisplayTextImageGIF(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSeen? Icons.done_all : Icons.done,
                        size: 20,
                        color: isSeen? Colors.blue : Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
