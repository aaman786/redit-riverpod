import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/feature/auth/controller/auth_controller.dart';
import 'package:reddit/feature/home/delegates/search_community_delegates.dart';
import 'package:reddit/feature/home/drawers/community_list_drawer.dart';
import 'package:reddit/feature/home/drawers/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Home"),
          centerTitle: false,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchCommunityDelegate(ref));
              },
              icon: const Icon(Icons.search),
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              );
            })
          ]),
      body: Center(child: Text(user.uid)),
      drawer: const CommuityListDrawer(),
      endDrawer: const ProfileDrawer(),
    );
  }
}
