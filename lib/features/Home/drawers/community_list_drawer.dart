import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';
import '../../../models/commuity_model.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push("create-community");
  }

  navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push("/r/${community.name}");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO drwaer listview

    return Drawer(
      child: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("create a community"),
                onTap: () => navigateToCreateCommunity(context),
              ),
              ref.watch(userCommunitiesProvider).when(
                    data: (communities) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: communities.length,
                          itemBuilder: (context, index) {
                            final community = communities[index];
                            return ListTile(
                              onTap: () {
                                navigateToCommunity(context, community);
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                              title: Text("r/${community.name}"),
                            );
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) => ErrorText(
                      errorMessage: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
