import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_samplea_application/screen/photo_list_screen.dart';

import 'package:logger/logger.dart';

// デフォルトでリリースビルドは出力しない、デバッグビルドはすべてログ出力する動作になっている
final logger = Logger();

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Form の key を指定する場合は、<FormState> として、 GlobalKey<FormState> を指定する
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // メールアドレス用のTextEditingController
  late TextEditingController _emailController = TextEditingController();
  // パスワード用のTextEditingController
  late TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 変数を初期化する
    //   - Widgetが作成された初回のみ動作させたい処理はinitState()に記述する
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey, // Formのkeyに指定する
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  // Columnを使い縦に並べる
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // テキストを表示
                      Text(
                        'Photo App',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        // TextEditingController,
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "メールアドレス"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value?.isEmpty == true) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('メールアドレスを入力してください'),
                              backgroundColor: Colors.red,
                            ));
                            logger.d('メールアドレスを入力してください');
                            return 'メールアドレスを入力してください';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        // TextEditingControllerを設定
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: "パスワード"),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (String? value) {
                          if (value?.isEmpty == true) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('パスワードを入力してください'),
                              backgroundColor: Colors.red,
                            ));
                            logger.d('パスワードを入力してください');
                            return 'パスワードを入力してください';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          // ログインボタンをタップしたときの処理
                          onPressed: () => _onSignIn(context),
                          child: const Text('ログイン'),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        //Button
                        child: ElevatedButton(
                          // 新規登録ボタンをタップしたときの処理
                          onPressed: () => _onSignUp(context),
                          child: const Text('新規登録'),
                        ),
                      ),
                    ],
                  )),
            )));
  }

  Future<void> _onSignIn(BuildContext context) async {
    try {
      // Form の内容をチェックする
      if (_formKey.currentState?.validate() != true) {
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('入力内容に足りない項目があります'),
          backgroundColor: Colors.red,
        ));
        logger.d(
            'onSign \n _formKey.currentState?.validate()  \n エラーメッセージがあるため処理を中断する');
        return;
      }

      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //画像一覧画面に遷移する
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PhotoListScreen(),
        ),
      );
    } catch (e) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('ログインに失敗しました'),
              content: Text(e.toString()),
            );
          });
    }
  }

  // 内部で非同期処理(Future)を扱っているのでasyncを付ける
  //   この関数自体も非同期処理となるので返り値もFutureとする
  Future<void> _onSignUp(BuildContext context) async {
    try {
      // Form の内容をチェックする
      if (_formKey.currentState?.validate() != true) {
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('入力内容に足りない項目があります'),
          backgroundColor: Colors.red,
        ));
        // エラーメッセージがあるため処理を中断する
        logger.d(
            'onSign \n formKey.currentState?.validate() \n エラーメッセージがあるため処理を中断する');
        return;
      }

      //メールアドレス・パスワードで新規登録
      //   TextEditingControllerから入力内容を取得
      //   Authenticationを使った複雑な処理はライブラリがやってくれる
      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //画像一覧画面に遷移する
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PhotoListScreen(),
        ),
      );
    } catch (e) {
      // エラーが発生した場合は、SnackBarでエラー内容を表示する
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('エラー'),
              content: Text(e.toString()),
            );
          });
    }
  }
}
