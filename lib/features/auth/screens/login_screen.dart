import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Chatty_ui/common/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../colors.dart';
import '../../../common/utils/utils.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  void sendPhoneNumber(){
    String phoneNumber = phoneController.text.trim();
    if(country!=null && phoneNumber.isNotEmpty){
      ref.read(authControllerProvider).
      signInWithPhone(context, "+${country!.phoneCode}$phoneNumber");
    }
    else{
      showSnackBar(context: context, content: 'Please select a country and enter a phone number');
    }
  }

  void pickCountry() {
    showCountryPicker(context: context, onSelect: (Country _country){
      setState(() {
        country = _country;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        //backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Chatty will need to verify your phone number.'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => pickCountry(),
                child: const Text('Select country/region'),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  if(country!=null)
                    Text("+${country!.phoneCode}"),
                  //Text('+91'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width*0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height*0.6),
              SizedBox(
                width: 90,
                child: CustomButton(
                  text: 'NEXT',
                  onPressed: sendPhoneNumber,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
