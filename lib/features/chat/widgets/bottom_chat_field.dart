import 'package:dynamic_color/dynamic_color.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Chatty_ui/common/utils/utils.dart';
import 'package:Chatty_ui/features/chat/controller/chat_controller.dart';
import 'package:Chatty_ui/features/chat/widgets/message_reply_preview.dart';
import '../../../colors.dart';
import 'dart:io';
import '../../../common/enums/message_enum.dart';
import '../../../common/provider/message_reply_provider.dart';


class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const BottomChatField({
    Key? key,
    required this.receiverUserId,
    required this.isGroupChat
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Microphone Permission not granted');
    }
    await _soundRecorder!.openRecorder();
  }


  void sendTextMessage() async {
    if(isShowSendButton){
      ref.read(chatControllerProvider).sendTextMessage(
          context,
          _messageController.text.trim(),
          widget.receiverUserId,
        widget.isGroupChat,
      );
      setState(() {
        _messageController.text = '';
      });
    }else{
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if(isRecorderInit){
        return ;
      }
      if(isRecording){
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      }else{
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
      File file,
      MessageEnum messageEnum
      ) {
    ref.read(chatControllerProvider).sendFileMessage(
        context,
        file,
        widget.receiverUserId,
        messageEnum,
      widget.isGroupChat,
    );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if(image != null){
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if(video != null){
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if(gif != null){
     ref.read(chatControllerProvider).sendGIFMessage(context, gif.url!, widget.receiverUserId, widget.isGroupChat,);
    }
  }

  void hideEmojiContainer(){
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer(){
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void showKeyboard(){
    focusNode.requestFocus();
  }

  void hideKeyboard(){
    focusNode.unfocus();
  }

  void toggleEmojiKeyboardConatiner() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    }else{
      hideKeyboard();
      showEmojiContainer();
    }
  }
  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            const SizedBox(width: 5,),
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val){
                  if(val.isNotEmpty){
                    setState(() {
                          isShowSendButton = true;
                      });
                    }else{
                      setState((){
                        isShowSendButton = false;
                      });
                    }
                  },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  prefixIcon: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.only(bottom: 6),
                              onPressed: toggleEmojiKeyboardConatiner,
                              constraints: const BoxConstraints.tightFor(width: 2, height: 21),
                              icon: const Icon(Icons.emoji_emotions, color: Colors.grey,),
                              style: IconButton.styleFrom(
                                fixedSize: const Size(2, 2),
                              ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.only(bottom: 0),
                            onPressed: selectGIF,
                            //constraints: const BoxConstraints.tightFor(width: 2, height: 21),
                            icon: const Icon(Icons.gif, color: Colors.grey,),
                            style: IconButton.styleFrom(
                              fixedSize: const Size(2, 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            padding: const EdgeInsets.only(bottom: 5),
                            onPressed: selectImage,
                            constraints: const BoxConstraints.tightFor(width: 2, height: 20),
                            icon: const Icon(Icons.camera_alt, color: Colors.grey,),
                            style: IconButton.styleFrom(
                              fixedSize: const Size(2, 2),
                            )
                        ),
                        IconButton(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            onPressed: selectVideo,
                            //constraints: BoxConstraints.tight(const Size(2, 20)),
                            icon: const Icon(Icons.attach_file, color: Colors.grey,),
                            style: IconButton.styleFrom(
                              fixedSize: const Size(2, 2),
                            )
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, right: 2, left: 2),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: InkWell(
                  onTap: sendTextMessage,
                  child: Icon(
                    isShowSendButton ? Icons.send : isRecording ? Icons.stop :
                    Icons.mic,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
              height: 310,
              child: EmojiPicker(
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  initCategory: Category.RECENT,
                  bgColor: Theme.of(context).colorScheme.background,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  iconColorSelected: Theme.of(context).colorScheme.primary,
                  recentsLimit: 28,
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                ),
              onEmojiSelected: (category, emoji) {
              setState(() {
                _messageController.text = _messageController.text + emoji.emoji;
              });
              if(!isShowSendButton){
                setState(() {
                  isShowSendButton = true;
                });
              }
            },
          ),
        ): const SizedBox.shrink(),
      ],
    );
  }
}