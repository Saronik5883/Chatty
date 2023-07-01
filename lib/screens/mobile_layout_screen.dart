import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:Chatty_ui/common/utils/utils.dart';
import 'package:Chatty_ui/features/auth/controller/auth_controller.dart';
import 'package:Chatty_ui/features/group/screens/create_group_screen.dart';
import 'package:Chatty_ui/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:Chatty_ui/features/chat/widgets/contacts_list.dart';
import 'package:Chatty_ui/features/status/screens/confirm_status_screen.dart';
import 'package:Chatty_ui/features/status/screens/status_contact_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin{

  late TabController tabBarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabBarController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          //backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'Chatty',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('New group'),
                  onTap: () =>
                    Future(() => Navigator.pushNamed(context, CreateGroupScreen.routeName)),
              ),
            ])
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: Theme.of(context).colorScheme.primaryContainer,
            indicatorWeight: 4,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: const [
            ContactsList(),
            StatusContactsScreen(),
          ],
           ),
        floatingActionButton: FloatingActionButton(
          //round circle shape
          shape: const CircleBorder(),
          onPressed: () async {
            if(tabBarController.index == 0){

            Navigator.pushNamed(context, SelectContactsScreen.routeName);
            }else{
              File? pickedImage = await pickImageFromGallery(context);
              if(pickedImage!=null){
                Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: pickedImage);
              }
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
