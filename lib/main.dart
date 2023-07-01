import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Chatty_ui/colors.dart';
import 'package:Chatty_ui/common/widgets/error.dart';
import 'package:Chatty_ui/features/auth/controller/auth_controller.dart';
import 'package:Chatty_ui/features/landing/screens/landing_screen.dart';
import 'package:Chatty_ui/firebase_options.dart';
import 'package:Chatty_ui/router.dart';
import 'package:Chatty_ui/screens/mobile_layout_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'common/widgets/loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      const ProviderScope(
          child: MyApp(),
      )
  );
}

Color brandColor = Color(0xFF4166f5);

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? dark){
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          final brightness = MediaQuery.of(context).platformBrightness;

          if(lightDynamic != null && dark !=null){
            lightColorScheme = lightDynamic.harmonized()..copyWith();
            lightColorScheme = lightColorScheme.copyWith(secondary: brandColor);
            darkColorScheme = dark.harmonized()..copyWith();
            darkColorScheme = dark.copyWith(secondary: brandColor);
          } else {
            lightColorScheme = ColorScheme.fromSeed(
                seedColor: brandColor, brightness: Brightness.light);
            darkColorScheme = ColorScheme.fromSeed(
                seedColor: brandColor, brightness: Brightness.dark);
          }

          final colorScheme = brightness == Brightness.dark
              ? darkColorScheme
              : lightColorScheme;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chatty UI',
            theme: ThemeData(
              useMaterial3: true,
              brightness: brightness,
              colorScheme: colorScheme,
            ),
            // theme: ThemeData.dark().copyWith(
            //   useMaterial3: true,
            //   scaffoldBackgroundColor: backgroundColor,
            //   appBarTheme: const AppBarTheme(
            //     color: appBarColor,
            //   )
            // ),
            // home: const ResponsiveLayout(
            //   mobileScreenLayout: MobileLayoutScreen(),
            //   webScreenLayout: WebLayoutScreen(),
            // ),
            onGenerateRoute: (settings) => generateRoute(settings),
            home:ref.watch(userDataAuthProvider).when(
              data: (user ) {
                if(user == null) {
                  return const LandingScreen();
                }
                return const MobileLayoutScreen();
              },
              error: (err, trace){
                return ErrorScreen(error: err.toString());
              },
              loading: () => const Loader(),
            ),
          );
        }
    );
  }
}
