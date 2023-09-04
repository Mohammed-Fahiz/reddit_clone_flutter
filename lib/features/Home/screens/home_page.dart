import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/Home/delegates/serach_community_delegates.dart';
import 'package:reddit_clone/features/Home/drawers/profile_drawer.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

import '../drawers/community_list_drawer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  displayCommunityDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  displayProfileDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              displayCommunityDrawer(context);
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchCommunityDelegate(ref: ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                displayProfileDrawer(context);
              },
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
            ),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
    );
  }
}
