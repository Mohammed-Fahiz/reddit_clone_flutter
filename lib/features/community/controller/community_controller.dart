import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/firebase_storage_providers.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/commuity_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/utils.dart';
import '../repository/commuinity_repository.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) {
    final communityRepository = ref.watch(communityRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    return CommunityController(
        communityRepository: communityRepository,
        ref: ref,
        storageRepository: storageRepository);
  },
);

final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunitiesProvider = StreamProvider.family((ref, String query) {
  return ref
      .watch(communityControllerProvider.notifier)
      .searchCommunities(query);
});

//TODO change to Notifier
class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Future<void> createCommunity(
      String communityName, BuildContext context) async {
    state = true;
    final userId = _ref.read(userProvider)?.uid ?? "";
    Community community = Community(
        id: communityName,
        name: communityName,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [userId],
        mods: [userId]);

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(message: l.message, context: context), (r) {
      showSnackBar(
          message: "Community created Successfully!", context: context);
      Routemaster.of(context).pop();
    });
  }

  Future<void> editCommunity(
      {required Community community,
      required BuildContext context,
      required File? bannerFile,
      required File? profileFile}) async {
    state = true;
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: "communities/banner", id: community.name, file: bannerFile);

      res.fold((l) => showSnackBar(message: l.message, context: context),
          (url) => community = community.copyWith(banner: url));
    }

    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: "communities/profile", id: community.name, file: profileFile);

      res.fold((l) => showSnackBar(context: context, message: l.message),
          (url) => community = community.copyWith(avatar: url));
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(message: l.message, context: context),
        (r) => Routemaster.of(context).pop());
  }

  joinOrLeaveCommunity(
      {required Community community, required BuildContext context}) async {
    state = true;
    final user = _ref.read(userProvider);
    List<String> membersList = List<String>.from(community.members);
    membersList.contains(user!.uid)
        ? membersList.remove(user.uid)
        : membersList.add(user.uid);
    final updateCommunity = community.copyWith(members: membersList);
    final res =
        await _communityRepository.joinOrLeaveCommunity(updateCommunity);
    state = false;
    res.fold(
      (l) => showSnackBar(message: l.message, context: context),
      (r) {
        if (community.members.contains(user.uid)) {
          showSnackBar(
              message: "Left community successfully", context: context);
        } else {
          showSnackBar(message: "Joined community", context: context);
        }
      },
    );
  }

  Stream<List<Community>> searchCommunities(String query) {
    return _communityRepository.searchCommunities(query);
  }

  Stream<List<Community>> getUserCommunities() {
    String uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Future<void> editModerators(
      {required Community community, required BuildContext context}) async {
    List<String> modsList = List<String>.from(community.mods);

    final updateCommunity = community.copyWith(mods: modsList);

    final res = await _communityRepository.editModerators(updateCommunity);

    res.fold((l) => showSnackBar(context: context, message: l.message),
        (r) => Routemaster.of(context).pop());
  }
}
