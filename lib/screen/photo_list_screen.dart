import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_samplea_application/domain/photo.dart';
import 'package:tutorial_samplea_application/repository/photo_repository.dart';
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
      body: StreamBuilder<List<Photo>>(
        // リポジトリ経由でデータを取得する
        stream: PhotoRepository(user).getPhotoList(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // URL一覧ではなくモデル一覧が取得できる
          final List<Photo> photoList = snapshot.data!;
          return PageView(
            controller: _controller,
            onPageChanged: (int index) => _onPageChanged(index),
            children: [
              //「全ての画像」を表示する部分
              PhotoGridView(
                // 処理を行う際はモデルを受け渡す
                photoList: photoList,
                onTap: (photo) => _onTapPhoto(photo, photoList),
              ),
              //「お気に入り登録した画像」を表示する部分
              PhotoGridView(
                photoList: photoList,
                onTap: (photo) => _onTapPhoto(photo, photoList),
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

  void _onTapPhoto(Photo photo, List<Photo> photoList) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // 処理を行う際はモデルを受け渡す
        builder: (_) => PhotoViewScreen(
          photo: photo,
          photoList: photoList,
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
      // リポジトリ経由でデータを保存する
      final User user = FirebaseAuth.instance.currentUser!;
      final PhotoRepository repository = PhotoRepository(user);
      final File file = File(result.files.single.path!);
      await repository.addPhoto(file);
    }
  }
}

class PhotoGridView extends StatelessWidget {
  const PhotoGridView({
    Key? key,
    required this.photoList,
    required this.onTap,
  }) : super(key: key);

  // コールバックからタップされた画像のURLを受け渡す
  final List<Photo> photoList;
  final Function(Photo photo) onTap;

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
      children: photoList.map((Photo photo) {
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: InkWell(
                onTap: () => onTap(photo),
                child: Image.network(
                  photo.imageURL,
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
