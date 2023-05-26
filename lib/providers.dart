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
