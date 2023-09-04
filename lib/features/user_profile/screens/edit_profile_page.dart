import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Theme/pallette.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import '../../../core/constants/constants.dart';
import '../../../core/global variables/global_variables.dart';
import '../../../models/userModel.dart';
import '../../auth/controller/auth_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? userBannerFile;
  File? userProfileFile;
  late TextEditingController _name;
  UserModel? _userModel;

  Future<void> pickUserBanner() async {
    final res = await pickImage();
    if (res != null) {
      userBannerFile = File(res.files.first.path!);
    }
  }

  pickUserProfile() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        userProfileFile = File(res.files.first.path!);
      });
    }
  }

  saveEdits() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
        context: context,
        bannerFile: userBannerFile,
        profileFile: userProfileFile,
        name: _userModel!.name == _name.text ? null : _name.text,
        user: _userModel!);
  }

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    return ref.watch(getUserProvider(widget.uid)).when(
          data: (user) {
            _userModel = user;
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("Edit profile"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        saveEdits();
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
                body: !isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                const SizedBox(
                                  height: 200,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    pickUserBanner();
                                  },
                                  child: DottedBorder(
                                    strokeCap: StrokeCap.square,
                                    dashPattern: const [10, 4],
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    color: Pallete.darkModeAppTheme.textTheme
                                        .bodySmall!.color!,
                                    child: SizedBox(
                                      width: deviceWidth,
                                      height:
                                          (150 / deviceHeight) * deviceHeight,
                                      child: userBannerFile != null
                                          ? Image.file(userBannerFile!)
                                          : user.banner ==
                                                      Constants.bannerDefault ||
                                                  user.banner.isEmpty
                                              ? const Center(
                                                  child: Icon(Icons
                                                      .camera_alt_outlined),
                                                )
                                              : Image.network(
                                                  user.banner,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: () => pickUserProfile(),
                                    child: userProfileFile != null
                                        ? CircleAvatar(
                                            radius: 35,
                                            backgroundImage:
                                                FileImage(userProfileFile!),
                                          )
                                        : CircleAvatar(
                                            radius: 35,
                                            backgroundImage:
                                                NetworkImage(user.profilePic),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              controller: _name,
                              decoration: InputDecoration(
                                hintText: "Name",
                                contentPadding: const EdgeInsets.all(20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Loader());
          },
          error: (err, stack) => ErrorText(errorMessage: err.toString()),
          loading: () => const Loader(),
        );
  }
}
