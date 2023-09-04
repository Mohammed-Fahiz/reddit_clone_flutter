import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/commuity_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/loader.dart';
import '../../auth/controller/auth_controller.dart';

class CommunityPage extends ConsumerWidget {
  final String name;
  const CommunityPage({super.key, required this.name});

  navigateToModTools(BuildContext context) {
    Routemaster.of(context).push("/mod-tools/$name");
  }

  joinOrLeaveCommunity(
      {required WidgetRef ref,
      required Community community,
      required BuildContext context}) {
    ref
        .read(communityControllerProvider.notifier)
        .joinOrLeaveCommunity(community: community, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            community.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                community.name,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              community.mods.contains(user.uid)
                                  ? OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                      onPressed: () {
                                        navigateToModTools(context);
                                      },
                                      child: const Text("Mod tools"),
                                    )
                                  : OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                      onPressed: () {
                                        joinOrLeaveCommunity(
                                            ref: ref,
                                            context: context,
                                            community: community);
                                      },
                                      child: Text(
                                          community.members.contains(user.uid)
                                              ? "Joined"
                                              : "Join"),
                                    ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("${community.members.length} members"),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Container()),
          error: (error, stackTrace) =>
              ErrorText(errorMessage: error.toString()),
          loading: () => const Loader()),
    );
  }
}
