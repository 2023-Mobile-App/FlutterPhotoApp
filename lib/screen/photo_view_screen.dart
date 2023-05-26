import 'package:flutter/material.dart';
import 'package:tutorial_samplea_application/domain/photo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_samplea_application/screen/providers.dart';
import 'package:share/share.dart';

class PhotoViewScreen extends StatefulWidget {
  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      // Riverpodから初期値を受け取り設定
      initialPage: context.read(photoViewInitialIndexProvider),
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
            Consumer(builder: (context, watch, child) {
              final asyncPhotoList = watch(photoListProvider);

              return asyncPhotoList.when(
                data: (photoList) {
                  return PageView(
                    controller: _controller,
                    onPageChanged: (int index) => {},
                    children: photoList.map((Photo photo) {
                      return Image.network(
                        photo.imageURL,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  );
                },
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                error: (e, stackTrace) {
                  return Center(
                    child: Text(e.toString()),
                  );
                },
              );
            }),
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
                          onPressed: () => _onTapShare(),
                          color: Colors.white,
                          icon: Icon(Icons.share),
                        ),
                        IconButton(
                          onPressed: () => {},
                          color: Colors.white,
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    )))
          ],
        ));
  }

  Future<void> _onTapShare() async {
    final photoList = context.read(photoListProvider).data!.value;
    final photo = photoList[_controller.page!.toInt()];

    // 画像URLを共有
    await Share.share(photo.imageURL);
  }
}
