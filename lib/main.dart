import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_samplea_application/screen/photo_list_screen.dart';
import 'package:tutorial_samplea_application/screen/providers.dart';
import 'package:tutorial_samplea_application/screen/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    // Providerで定義したデータを渡せるようにする
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Consumerを使うことでもデータを受け取れる
      home: Consumer(builder: (context, watch, child) {
        // ユーザー情報を取得
        final asyncUser = watch(userProvider);

        return asyncUser.when(
          data: (User? data) {
            return data == null ? SignInScreen() : PhotoListScreen();
          },
          loading: () {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          error: (e, stackTrace) {
            return Scaffold(
              body: Center(
                child: Text(e.toString()),
              ),
            );
          },
        );
      }),
    );
  }
}
