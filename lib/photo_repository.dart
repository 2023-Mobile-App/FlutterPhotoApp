class PhotoRepository {
  Future<void> deletePhoto(Photo photo) async {
    // Cloud Firestoreのデータを削除
    await FirebaseFirestore.instance
        .collection('users/${user.uid}/photos')
        .doc(photo.id)
        .delete();
    // Storageの画像ファイルを削除
    await FirebaseStorage.instance.ref().child(photo.imagePath).delete();
  }
}
