import 'package:firebase_core/firebase_core.dart';
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

  // final video = Video(
  //   id: DateTime.now().millisecondsSinceEpoch.toString(),
  //   songName: 'Em yêu',
  //   thumbnailUrl: '',
  //   userId: '',
  //   userAvatarUrl:
  //       'https://www.greenqueen.com.hk/wp-content/uploads/2021/06/WEF-Investments-In-Nature-Based-Solutions-Have-To-Triple-By-2030-To-Address-Climate-Change-Biodiversity-Loss.jpg',
  //   userIdLiked: [],
  //   username: 'Tôi đây bạn',
  //   videoUrl:
  //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  // );
  // VideoService.instance.add(video);

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //   ),
  // );

  runApp(
    const ProviderScope(child: MyApp()),
  );
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
