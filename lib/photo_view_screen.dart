import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoapp/photo.dart';
import 'package:photoapp/providers.dart';

class PhotoViewScreen extends StatefulWidget {
  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: Stack(
        children: [
          // ...
          Align(
            child: Container(
              // ...
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => {},
                    color: Colors.white,
                    icon: Icon(Icons.share),
                  ),
                  IconButton(
                    onPressed: () => _onTapDelete(),
                    color: Colors.white,
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapDelete() async {
    final photoRepository = context.read(photoRepositoryProvider);
    final photoList = context.read(photoListProvider).data!.value;
    final photo = photoList[_controller.page!.toInt()];

    if (photoList.length == 1) {
      Navigator.of(context).pop();
    } else if (photoList.last == photo) {
      await _controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    await photoRepository!.deletePhoto(photo);
  }
}
