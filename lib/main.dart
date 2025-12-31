import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/pick_trash_location.dart';
import 'Pages/OnAppStart/welcome_page.dart';
import './Theme/theme_provider.dart';
import './Pages/BottomNavBar/bottom_nav_bar.dart';
import 'Pages/OnAppStart/check_permissions.dart';
import 'Pages/OnAppStart/sign_in_page.dart';

bool allPermissions = false;
final user = FirebaseAuth.instance.currentUser;
String accountType;

Future<void> geAccountType() async {
  print("----------------------- CHECK ACCOUNT TYPE -----------------------");
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .get()
      .then((value) {
    accountType = value.data()["accountType"];
    print("----------------------- $accountType -----------------------");
  });
}

_checkPermissionStatus() async {
  print("----------------------- CHECK PERMISSION STATUS CALLED!");

  var locationPermissionStatus = await Permission.location.status;
  var cameraPermissionStatus = await Permission.camera.status;
  var storagePermissionStatus = await Permission.storage.status;

  if (locationPermissionStatus.isUndetermined &&
      cameraPermissionStatus.isUndetermined &&
      storagePermissionStatus.isUndetermined) {
    print("ALL (LOCATION, CAMERA, STORAGE) PERMISSION DIDN'T ASK YET");
  } else if (locationPermissionStatus.isGranted &&
      cameraPermissionStatus.isGranted &&
      storagePermissionStatus.isGranted) {
    print("ALL (LOCATION, CAMERA, STORAGE) PERMISSION IS GRANTED!");
    allPermissions = true;
  } else if (locationPermissionStatus.isDenied) {
    print("LOCATION PERMISSION DENIED!");
  } else if (cameraPermissionStatus.isDenied) {
    print("CAMERA PERMISSION DENIED!");
  } else if (storagePermissionStatus.isDenied) {
    print("STORAGE PERMISSION DENIED!");
  } else if (locationPermissionStatus.isRestricted) {
    print("LOCATION PERMISSION RESTRICTED!");
  } else if (cameraPermissionStatus.isRestricted) {
    print("CAMERA PERMISSION RESTRICTED!");
  } else if (storagePermissionStatus.isRestricted) {
    print("STORAGE PERMISSION RESTRICTED!");
  } else if (!locationPermissionStatus.isGranted) {
    print("LOCATION PERMISSION IS NOT GRANTED!");
  } else if (!cameraPermissionStatus.isGranted) {
    print("CAMERA PERMISSION IS NOT GRANTED!");
  } else if (!storagePermissionStatus.isGranted) {
    print("STORAGE PERMISSION IS NOT GRANTED!");
  } else {
    allPermissions = false;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("----------------------- MAIN METHOD RUN -----------------------");
  await _checkPermissionStatus();
  await Firebase.initializeApp();
  if (user != null) {
    await geAccountType();
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      //systemNavigationBarColor: Colors.blue,
      statusBarColor: Colors.green.shade900,
      //statusBarIconBrightness: Brightness.light
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String title = 'TrashPick';

  _mainPage() {
    print(
        "------------------ All Permissions: $allPermissions ------------------");
    print("----------------------- USER: $user ------------------");
    if (allPermissions == true) {
      if (user == null) {
        print("----------------------- SWITCH: WelcomePage ------------------");
        //return TestTheme(title: title);
        //return BottomNavBar(title: title);
        return WelcomePage();
      } else {
        print("----------------------- SWITCH: BottomBar ------------------");
        return BottomNavBar(accountType);
        //return PickTrashLocation();
      }
    } else {
      print(
          "----------------------- SWITCH: CheckAppPermissions ------------------");
      return CheckAppPermissions();
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: title,
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppThemeData.lightTheme,
            darkTheme: AppThemeData.darkTheme,
            home:
                /*AnimatedSplashScreen(
              splash: Image.asset(
                'assets/images/trashpick_logo_2.png',
              ),
              animationDuration: Duration(seconds: 2),
              nextScreen: HomePage(title: title),
              splashTransition: SplashTransition.fadeTransition,
            ),*/
                _mainPage(),
          );
        },
      );
}
