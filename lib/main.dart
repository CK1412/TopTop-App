import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toptop_app/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_checker.dart';
import 'src/themes.dart';

bool useFirebaseEmulator = false;

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

  if (useFirebaseEmulator) {
    await _configFirebaseEmulator();
  }

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

Future _configFirebaseEmulator() async {
  var myIp = '192.168.0.103';
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

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      title: 'TopTop App',
      theme: AppTheme.customThemeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthChecker(),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: ref.watch(localeControllerProvider),
    );
  }
}
