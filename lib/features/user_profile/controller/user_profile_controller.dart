import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/providers/firebase_storage_providers.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/models/userModel.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  editUserProfile(
      {required BuildContext context,
      required File? bannerFile,
      required File? profileFile,
      required String? name,
      required UserModel user}) async {
    state = true;
    bool? isNameChanged;
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: "users/banner", id: user.uid, file: bannerFile);
      res.fold(
        (l) => showSnackBar(message: l.message, context: context),
        (url) => user = user.copyWith(banner: url),
      );
    }

    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: "users/profile", id: user.uid, file: profileFile);
      res.fold((l) => showSnackBar(message: l.message, context: context),
          (url) => user = user.copyWith(profilePic: url));
    }
    if (name != null) {
      user = user.copyWith(name: name);
      isNameChanged = true;
    }
    final res =
        await _userProfileRepository.editUserProfile(user, isNameChanged);
    state = false;
    res.fold(
      (l) => showSnackBar(context: context, message: l.message),
      (r) {
        // _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }
}
