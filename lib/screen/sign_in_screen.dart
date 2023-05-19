import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_samplea_application/screen/photo_list_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Form の key を指定する場合は、<FormState> として、 GlobalKey<FormState> を指定する
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // メールアドレス用のTextEditingController
  final TextEditingController _emailController = TextEditingController();
  // パスワード用のTextEditingController
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
                    return 'パスワードを入力してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // ログインボタンをタップしたときの処理
                  onPressed: () => _onSignIn(),
                  child: const Text('log in'),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                //Button
                child: ElevatedButton(
                  // 新規登録ボタンをタップしたときの処理
                  onPressed: () => _onSignUp(),
                  child: const Text('Sign up'),
                ),
              ),
            ],
          )),
    ));
  }

  Future<void> _onSignIn() async {
    try {} catch (e) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('ログインに失敗しました'),
              content: Text(e.toString()),
            );
          });
    }
    // Form の内容をチェックする
    if (_formKey.currentState?.validate() != true) {
      // エラーメッセージがあるため処理を中断する
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
  }

  // 内部で非同期処理(Future)を扱っているのでasyncを付ける
  //   この関数自体も非同期処理となるので返り値もFutureとする
  Future<void> _onSignUp() async {
    try {
      // Form の内容をチェックする
      if (_formKey.currentState?.validate() != true) {
        // エラーメッセージがあるため処理を中断する
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
