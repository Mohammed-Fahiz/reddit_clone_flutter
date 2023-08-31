import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/global%20variables/global_variables.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/commuity_model.dart';
import '../../../Theme/pallette.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileImageFile;

  Future<void> pickBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  Future<void> pickProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileImageFile = File(res.files.first.path!);
      });
    }
  }

  void saveEdits(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
        community: community,
        context: context,
        bannerFile: bannerFile,
        profileFile: profileImageFile);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return isLoading != true
        ? ref.watch(getCommunityByNameProvider(widget.name)).when(
              data: (community) => Scaffold(
                backgroundColor:
                    Pallete.darkModeAppTheme.appBarTheme.backgroundColor,
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("Edit community"),
                  actions: [
                    TextButton(
                      onPressed: () => saveEdits(community),
                      child: const Text("Save"),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: (200 / deviceHeight) * deviceHeight,
                          ),
                          GestureDetector(
                            onTap: pickBannerImage,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.square,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              color: Pallete
                                  .darkModeAppTheme.textTheme.bodySmall!.color!,
                              child: SizedBox(
                                width: deviceWidth,
                                height: (150 / deviceHeight) * deviceHeight,
                                child: bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : community.banner ==
                                                Constants.bannerDefault ||
                                            community.banner.isEmpty
                                        ? const Center(
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 40,
                                            ),
                                          )
                                        : Image.network(community.banner),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: pickProfileImage,
                              child: profileImageFile == null
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(community.avatar),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          FileImage(profileImageFile!),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stackTrace) =>
                  ErrorText(errorMessage: error.toString()),
              loading: () => const Loader(),
            )
        : const Loader();
  }
}
