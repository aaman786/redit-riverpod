import 'package:flutter/material.dart';
import 'package:reddit/feature/auth/screens/login_screen.dart';
import 'package:reddit/feature/community/sceens/add_mod_screen.dart';
import 'package:reddit/feature/community/sceens/community_screen.dart';
import 'package:reddit/feature/community/sceens/create_community_screen.dart';
import 'package:reddit/feature/community/sceens/edit_community_screen.dart';
import 'package:reddit/feature/community/sceens/mod_tools_screen.dart';
import 'package:reddit/feature/home/screen/home_screen.dart';
import 'package:reddit/feature/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit/feature/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
            child: CommunityScreen(
          name: route.pathParameters['name']!,
        )),
    '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModToolsScreen(name: routeData.pathParameters['name']!)),
    '/edit-community/:name': (routeData) => MaterialPage(
        child: EditCommunityScreen(name: routeData.pathParameters['name']!)),
    '/add-mod/:name': (routeData) => MaterialPage(
        child: AddModScreen(name: routeData.pathParameters['name']!)),
    '/u/:uid': (routeData) => MaterialPage(
        child: UserProfileScreen(uid: routeData.pathParameters['uid']!)),
    '/edit-profile/:uid': (routeData) => MaterialPage(
        child: EditProfileScren(uid: routeData.pathParameters['uid']!)),
  },
);
