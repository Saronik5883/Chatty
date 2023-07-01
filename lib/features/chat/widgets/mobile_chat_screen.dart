import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Chatty_ui/features/auth/controller/auth_controller.dart';
import 'package:Chatty_ui/models/user_model.dart';
import 'package:Chatty_ui/features/chat/widgets/chat_list.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/group.dart';
import '../controller/chat_controller.dart';
import 'bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen({Key? key, required this.profilePic, required this.name, required this.uid, required this.isGroupChat}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 30,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: isGroupChat ?
          StreamBuilder<List<Group>>(
              stream: ref.watch(chatControllerProvider).chatGroups(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Loader();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(snapshot.data!.first.groupPic),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Text(name,)),
                      ],
                    ),
                  ],
                );
              }
          )
              : StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDatabyId(uid),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Loader();
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(snapshot.data!.profilePic),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(alignment: Alignment.centerLeft,child: Text(name,)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data!.isOnline ? '' : 'online',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                receiverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      );
  }
}

