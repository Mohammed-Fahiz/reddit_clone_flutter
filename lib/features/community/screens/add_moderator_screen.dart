import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/commuity_model.dart';

class AddModeratorScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModeratorScreen({super.key, required this.name});

  @override
  ConsumerState createState() => _AddModeratorScreenState();
}

class _AddModeratorScreenState extends ConsumerState<AddModeratorScreen> {
  Community? community;

  void addModerator(String uid, Community community) {
    setState(() {
      community.mods.add(uid);
    });
  }

  void removeModerator(String uid, Community community) {
    setState(() {
      community.mods.remove(uid);
    });
  }

  void saveEdits(Community community) {
    ref.read(communityControllerProvider.notifier).editModerators(
          community: community,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add moderators"),
        actions: [
          IconButton(
            onPressed: () => saveEdits(community!),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (data) => ListView.builder(
                itemCount: data.members.length,
                itemBuilder: (context, index) {
                  community = data;
                  String memberUid = data.members[index];
                  return ref.watch(getUserProvider(memberUid)).when(
                      data: (user) {
                        return CheckboxListTile(
                          title: Text(user.name),
                          value: data.mods.contains(memberUid) ? true : false,
                          onChanged: (value) {
                            if (value!) {
                              addModerator(memberUid, community!);
                            } else {
                              removeModerator(memberUid, community!);
                            }
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(errorMessage: error.toString()),
                      loading: () => const Loader());
                },
              ),
          error: (error, stackTrace) =>
              ErrorText(errorMessage: error.toString()),
          loading: () => const Loader()),
    );
  }
}
