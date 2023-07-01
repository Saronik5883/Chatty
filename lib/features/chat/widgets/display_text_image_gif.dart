import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Chatty_ui/widgets/video_player_item.dart';

import '../../../common/enums/message_enum.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
      message,
      style: const TextStyle(
        fontSize: 16,
        //color: Colors.white,
      ),
    ) : type == MessageEnum.video ? VideoPlayerItem(videoUrl: message)
        : type==MessageEnum.gif ? CachedNetworkImage(imageUrl: message)
        : type == MessageEnum.audio ?
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                        ),
                        onPressed: () async{
                          if(isPlaying){
                            await audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          }else{
                            await audioPlayer.play(UrlSource(message));
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                        icon:Icon(isPlaying == true ? Icons.pause_circle : Icons.play_circle, size: 50),
                    );
                  }
                ),
                Expanded(
                  child: Slider(
                    onChanged: (val){},
                    value: 0,
                    min: 0,
                    max: 100,
                  ),
                ),
              ],
            )
        : ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 100,
        minWidth: MediaQuery.of(context).size.width/3,
        minHeight: MediaQuery.of(context).size.width/3,
        maxHeight: MediaQuery.of(context).size.width/1.4,
      ),
           child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: CachedNetworkImageProvider(message),
              fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
