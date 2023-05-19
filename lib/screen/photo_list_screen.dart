import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_samplea_application/screen/photo_view_screen.dart';
import 'package:tutorial_samplea_application/screen/sign_in_screen.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  late int _currentIndex;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    // PageViewで表示されているWidgetの番号を持っておく
    _currentIndex = 0;
    // PageViewの表示を切り替えるのに使う
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo App'),
        actions: [
          // log out Button
          IconButton(
            onPressed: () => _OnSignOut(),
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: PageView(
        controller: _controller,
        // ページ遷移した時の処理
        onPageChanged: (int index) => _onPageChanged(index),
        // PageViewで表示するWidget
        children: [
          // すべての写真を表示する画面
          PhotoGridView(
            // コールバックを設定して、タップした画像の URL を受け取る
            onTap: (String imageURL) => _onTapPhoto(imageURL),
          ),

          // お気に入りに登録した画像を表示する画面
          PhotoGridView(
            // コールバックを設定して、タップした画像の URL を受け取る
            onTap: (String imageURL) => _onTapPhoto(imageURL),
          ),
        ],
      ),

      // Photo Addtion Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, '/photo_add_screen');
        },
        child: const Icon(Icons.add),
      ),

      // 画面下部のボタン部分
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBarItemがタップされたときの処理
        //   0: フォト
        //   1: お気に入り
        onTap: (int index) => _onTapBottomNavigationItem(index),
        // 現在表示されているBottomNavigationBarItemの番号
        //   0: フォト
        //   1: お気に入り
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.photo),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }

  void _onTapPhoto(String imageURL) {
    // 画像詳細ページに遷移する
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PhotoViewScreen(imageURL: imageURL)));
  }

  void _onPageChanged(int index) {
    //PageView で表示されているWidgetの番号を持っておく
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTapBottomNavigationItem(int index) {
    // PageViewで表示するWidgetを切り替える
    _controller.animateToPage(
      // 表示するWidgetの番号
      //   0: 全ての画像
      //   1: お気に入り登録した画像
      index,
      // 表示を切り替える時にかかる時間（300ミリ秒）
      duration: Duration(milliseconds: 300),
      // アニメーションの動き方
      //   この値を変えることで、アニメーションの動きを変えることができる
      //   https://api.flutter.dev/flutter/animation/Curves-class.html
      curve: Curves.easeIn,
    );
    // PageViewで表示されているWidgetの番号を更新
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _OnSignOut() async {
    //log out
    await FirebaseAuth.instance.signOut();

    //ログイン画面に戻す

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SignInScreen(),
      ),
    );
  }
}

class PhotoGridView extends StatelessWidget {
  const PhotoGridView({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  // コールバックからタップされた画像のURLを受け渡す
  final void Function(String imageURL) onTap;

  @override
  Widget build(BuildContext context) {
    // ダミー画像一覧
    final List<String> imageList = [
      'https://placehold.jp/400x300.png?text=0',
      'https://placehold.jp/400x300.png?text=1',
      'https://placehold.jp/400x300.png?text=2',
      'https://placehold.jp/400x300.png?text=3',
      'https://placehold.jp/400x300.png?text=4',
      'https://placehold.jp/400x300.png?text=5',
    ];

    return GridView.count(
      //1行あたりの widget の数
      crossAxisCount: 2,

      // widget と widget の間隔
      mainAxisSpacing: 8,

      // widget と widget の間隔
      padding: const EdgeInsets.all(8),

      //list photo
      children: imageList.map((String imageURL) {
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: InkWell(
                onTap: () => onTap(imageURL),
                // URLを指定して画像を表示
                child: Image.network(
                  imageURL,
                  // 画像の表示の仕方を調整できる
                  //  比率は維持しつつ余白が出ないようにするので cover を指定
                  //  https://api.flutter.dev/flutter/painting/BoxFit-class.html
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 画像の上にお気に入りアイコンを重ねて表示
            //   Alignment.topRightを指定し右上部分にアイコンを表示
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                color: Colors.white,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
