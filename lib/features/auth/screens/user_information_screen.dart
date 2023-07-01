import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Chatty_ui/features/auth/controller/auth_controller.dart';
import 'dart:io';
import '../../../common/utils/utils.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
   image = await pickImageFromGallery(context);
   setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if(name.isNotEmpty){
      // store user data
      ref.read(authControllerProvider).saveUserDataToFirebase(
          context, name, image
      );
    }
    else{
      showSnackBar(context: context, content: 'Please enter your name');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
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
              Row(
                children: [
                  Container(
                    width: size.width*0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                      )
                      ),
                    ),
                  IconButton(
                      onPressed: storeUserData,
                      icon: Icon(Icons.done)
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}
