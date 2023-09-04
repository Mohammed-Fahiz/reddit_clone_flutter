import 'package:flutter/material.dart';
import 'package:reddit_clone/features/Home/screens/home_page.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screens/add_moderator_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_page.dart';
import 'package:reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tool_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/edit_profile_page.dart';
import 'package:routemaster/routemaster.dart';

import 'features/user_profile/screens/user_profile_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  "/": (route) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(
  routes: {
    "/": (route) => const MaterialPage(child: HomePage()),
    "/create-community": (route) =>
        const MaterialPage(child: CreateCommunityPage()),
    "/r/:name": (route) {
      return MaterialPage(
          child: CommunityPage(
        name: route.pathParameters["name"]!,
      ));
    },
    "/mod-tools/:name": (route) => MaterialPage(
          child: ModToolsScreen(
            name: route.pathParameters["name"]!,
          ),
        ),
    "/add-moderator/:name": (route) => MaterialPage(
          child: AddModeratorScreen(
            name: route.pathParameters["name"]!,
          ),
        ),
    "/edit-community/:name": (route) => MaterialPage(
          child: EditCommunityScreen(
            name: route.pathParameters["name"]!,
          ),
        ),
    "/user-profile/:uid": (route) => MaterialPage(
          child: UserProfilePage(uid: route.pathParameters["uid"]!),
        ),
    "/edit-profile/:uid": (route) => MaterialPage(
          child: EditProfileScreen(uid: route.pathParameters["uid"]!),
        ),
  },
);
