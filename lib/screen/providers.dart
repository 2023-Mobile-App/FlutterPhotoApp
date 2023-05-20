import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_samplea_application/domain/photo.dart';
import 'package:tutorial_samplea_application/repository/photo_repository.dart';

final userProvider = StreamProvider.autoDispose((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ProviderからPhotoRepositoryを渡す
final photoRepositoryProvider = Provider.autoDispose((ref) {
  final user = ref.watch(userProvider).data?.value;
  return user == null ? null : PhotoRepository(user);
});

// 他ProviderからPhotoRepositoryを受け取る
final photoListProvider = StreamProvider.autoDispose((ref) {
  final photoRepository = ref.watch(photoRepositoryProvider);
  return photoRepository == null
      ? Stream.value(<Photo>[])
      : photoRepository.getPhotoList();
});

final photoListIndexProvider = StateProvider.autoDispose((ref) {
  return 0;
});

final photoViewInitialIndexProvider = ScopedProvider<int>(null);

final favoritePhotoListProvider = Provider.autoDispose((ref) {
  return ref.watch(photoListProvider).whenData((List<Photo> data) {
    return data.where((photo) => photo.isFavorite).toList();
  });
});
