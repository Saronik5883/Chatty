import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Chatty_ui/colors.dart';
import 'package:Chatty_ui/common/utils/utils.dart';

import '../controller/group_controller.dart';
import '../widgets/select_contacts_group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup(){
    if(groupNameController.text.trim().isNotEmpty && image != null){
      // create group
      ref.read(groupControllerProvider)
          .createGroup(
          context,
          groupNameController.text.trim(),
          image!,
          ref.read(selectedGroupContacts)
      );
      ref.read(selectedGroupContacts.state).update((state) => []);
      Navigator.pop(context);
    }
    else{
      showSnackBar(context: context, content: 'Please enter group name and select image');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    groupNameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Stack(
              children: [
                image == null ? const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg',
                  ),
                  radius: 70,
                ) : CircleAvatar(
                  backgroundImage: FileImage(image!),
                  radius: 70,
                ),
                Positioned(
                  bottom: -10,
                  left: 100,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter group name',
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text('Select Contacts', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
            ),
            const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        shape: const CircleBorder(),
        child: const Icon(Icons.done),
        backgroundColor: tabColor,
      ),
    );
  }
}
