import 'package:flutter/material.dart';
import 'package:Chatty_ui/colors.dart';
import 'package:Chatty_ui/common/widgets/custom_button.dart';
import 'package:Chatty_ui/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text("Welcome To Chatty",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
              SizedBox(height: size.height/9),
              Image.asset("assets/bg.png", height: 340, width: 340, color: Theme.of(context).colorScheme.primary,),
              SizedBox(height: size.height/9),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Read our Privacy Policy Tap, 'Agree and continue' to accept the Terms of Service",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: greyColor)
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: size.width*0.75,
                  child: CustomButton(
                      text: 'AGREE AND CONTINUE',
                      onPressed: () => navigateToLoginScreen(context)
                  )
              )
            ],
          ),
        )
      )
    );
  }
}
