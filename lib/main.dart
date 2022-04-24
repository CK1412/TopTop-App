import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_checker.dart';
import 'src/custom_theme.dart';

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
  //   uid: '',
  //   userAvatarUrl:
  //       'https://photo-cms-kienthuc.zadn.vn/zoom/800/uploaded/nguyenanhson/2020_05_21/2/tha-thinh-sieu-ngot-hot-girl-2k3-so-huu-trang-ca-nhan-trieu-follow-hinh-7.jpg',
  //   userIdLiked: [],
  //   username: 'Tôi đây bạn',
  //   videoUrl:
  //       'https://v16-webapp.tiktok.com/04ad10cbb9913352b1dd6d1ebffb0e9f/62652e7f/video/tos/useast2a/tos-useast2a-pve-0037c001-aiso/0d8f254756d3495e98e0b30348bb0864/?a=1988&br=3734&bt=1867&cd=0%7C0%7C1%7C0&ch=0&cr=0&cs=0&cv=1&dr=0&ds=3&er=&ft=eXd.6Hk_Myq8Zp_n4we2NKchml7Gb&l=202204240501460102510042021A0D39D8&lr=tiktok&mime_type=video_mp4&net=0&pl=0&qs=0&rc=amc0a2c6Zm5qOzMzZjgzM0ApOzM8Omg2NDxoN2Y6O2Q1Z2ctNWJrcjRfbGFgLS1kL2NzczQvMDM2MV8uNF9hYV4yYGM6Yw%3D%3D&vl=&vr=',
  // );
  // VideoService.instance.addVideo(video);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

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
      title: 'TopTop App',
      theme: customThemeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthChecker(),
      },
    );
  }
}
