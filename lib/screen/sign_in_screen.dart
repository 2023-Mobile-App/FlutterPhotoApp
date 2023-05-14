import 'package:flutter/material.dart';
import 'package:tutorial_samplea_application/screen/photo_list_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Form の key を指定する場合は、<FormState> として、 GlobalKey<FormState> を指定する
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  void _onSignIn() {
    // Form の内容をチェックする
    if (_formKey.currentState?.validate() != true) {
      // エラーメッセージがあるため処理を中断する
      return;
    }

    //画像一覧画面に遷移する
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PhotoListScreen(),
      ),
    );
  }

  void _onSignUp() {
    // Form の内容をチェックする
    if (_formKey.currentState?.validate() != true) {
      // エラーメッセージがあるため処理を中断する
      return;
    }

    //画像一覧画面に遷移する
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PhotoListScreen(),
      ),
    );
  }
}
