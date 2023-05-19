import 'package:flutter/material.dart';
import 'package:tutorial_samplea_application/domain/photo.dart';

class PhotoViewScreen extends StatefulWidget {
  const PhotoViewScreen({
    Key? key,
    // required を付けると必須パラメータという意味になる
    required this.photo,
    required this.photoList,
  }) : super(key: key);

  // StringではなくPhotoで受け取る
  final Photo photo;
  final List<Photo> photoList;

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late PageController _controller;

  // ダミー画像一覧
  final List<String> imageList = [
    'https://placehold.jp/400x300.png?text=0',
    'https://placehold.jp/400x300.png?text=1',
    'https://placehold.jp/400x300.png?text=2',
    'https://placehold.jp/400x300.png?text=3',
    'https://placehold.jp/400x300.png?text=4',
    'https://placehold.jp/400x300.png?text=5',
  ];

  @override
  void initState() {
    super.initState();

    // 受け取った画像一覧から、ページ番号を特定
    final int initialPage = widget.photoList.indexOf(widget.photo);

    _controller = PageController(
      initialPage: initialPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //AppBar の裏まで body の表示エリアを広げる
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            //image List
            PageView(
              controller: _controller,
              onPageChanged: (int index) => {},
              children: widget.photoList.map((Photo photo) {
                return Image.network(
                  photo.imageURL,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),

            //Icon ボタンを画像の手前に重ねる
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        stops: const [
                          0.0,
                          1.0,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //共有ボタン
                        IconButton(
                          onPressed: () {},
                          color: Colors.white,
                          icon: const Icon(Icons.share),
                        ),
                        //delete ボタン
                        IconButton(
                          onPressed: () {},
                          color: Colors.white,
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    )))
          ],
        ));
  }
}
