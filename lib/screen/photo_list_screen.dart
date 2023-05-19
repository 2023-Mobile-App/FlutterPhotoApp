import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_samplea_application/screen/photo_view_screen.dart';
import 'package:tutorial_samplea_application/screen/sign_in_screen.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

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
    // ログインしているユーザーの情報を取得
    final User user = FirebaseAuth.instance.currentUser!;

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
      body: StreamBuilder<QuerySnapshot>(
        // Cloud Firesstoreからデータを取得
        stream: FirebaseFirestore.instance
            .collection('users/${user.uid}/photos')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          // Cloud Firestoreからデータを取得中の場合
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Cloud Firestoreからデータを取得完了した場合
          final QuerySnapshot query = snapshot.data;
          // 画像のURL一覧を作成
          final List<String> imageList =
              query.docs.map((doc) => doc.get('imageURL') as String).toList();
          return PageView(
            controller: _controller,
            onPageChanged: (int index) => _onPageChanged(index),
            children: [
              //「全ての画像」を表示する部分
              PhotoGridView(
                // Cloud Firestoreから取得した画像のURL一覧を渡す
                imageList: imageList,
                onTap: (imageURL) => _onTapPhoto(imageURL, imageList),
              ),
              //「お気に入り登録した画像」を表示する部分
              PhotoGridView(
                // お気に入り登録した画像は、後ほど実装
                imageList: [],
                onTap: (imageURL) => _onTapPhoto(imageURL, imageList),
              ),
            ],
          );
        },
      ),

      // Photo Addtion Button
      // 画像追加用ボタン
      floatingActionButton: FloatingActionButton(
        // 画像追加用ボタンをタップしたときの処理
        onPressed: () => _onAddPhoto(),
        child: Icon(Icons.add),
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

  void _onTapPhoto(String imageURL, List<String> imageList) {
    // 画像詳細ページに遷移する
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoViewScreen(
          imageURL: imageURL,
          imageList: imageList,
        ),
      ),
    );
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

  Future<void> _onAddPhoto() async {
    // 画像ファイルを選択
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    // 画像ファイルが選択された場合
    if (result != null) {
      // ログイン中のユーザー情報を取得
      final User user = FirebaseAuth.instance.currentUser!;

      // フォルダとファイル名を指定し画像ファイルをアップロード
      final int timestamp = DateTime.now().microsecondsSinceEpoch;
      final File file = File(result.files.single.path!);
      final String name = file.path.split('/').last;
      final String path = '${timestamp}_$name';

      final TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/photos') // フォルダ名
          .child(path) // ファイル名
          .putFile(file); // 画像ファイル

      // アップロードした画像のURLを取得
      final String imageURL = await task.ref.getDownloadURL();
      // アップロードした画像の保存先を取得
      final String imagePath = task.ref.fullPath;
      // データ
      final data = {
        'imageURL': imageURL,
        'imagePath': imagePath,
        'isFavorite': false, // お気に入り登録
        'createdAt': Timestamp.now(), // 現在時刻
      };
      // データをCloud Firestoreに保存
      await FirebaseFirestore.instance
          .collection('users/${user.uid}/photos') // コレクション
          .doc() // ドキュメント（何も指定しない場合は自動的にIDが決まる）
          .set(data); // データ
    }
  }
}

class PhotoGridView extends StatelessWidget {
  const PhotoGridView({
    Key? key,
    required this.onTap,
    required this.imageList,
  }) : super(key: key);

  // コールバックからタップされた画像のURLを受け渡す
  final void Function(String imageURL) onTap;
  final List<String> imageList;

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
