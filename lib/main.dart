import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_checker.dart';
import 'src/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //* initalize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //   ),
  // );
  // await _configEmulatorFirebase();

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

Future _configEmulatorFirebase() async {
  var myIp = '192.168.0.104';
  // auth
  await FirebaseAuth.instance.useAuthEmulator(myIp, 9099);
  debugPrint('use emulator firebaseAuth');

  await FirebaseStorage.instance.useStorageEmulator(myIp, 9199);
  debugPrint('use emulator firebaseStorage');

  // firestore
  FirebaseFirestore.instance.settings = Settings(
    host: "$myIp:8080",
    sslEnabled: false,
    persistenceEnabled: false,
  );
  debugPrint('use emulator firebaseFirestore');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      title: 'TopTop App',
      theme: AppTheme.customThemeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthChecker(),
      },
    );
  }
}
