import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constant.dart';
import 'package:reddit/feature/auth/controller/auth_controller.dart';
import 'package:reddit/feature/home/delegates/search_community_delegates.dart';
import 'package:reddit/feature/home/drawers/community_list_drawer.dart';
import 'package:reddit/feature/home/drawers/profile_drawer.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void pageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  // FOR THE WEB VERSION
  void navigateToAddPost() {
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNoifierProvider);
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
            IconButton(
              onPressed: navigateToAddPost,
              icon: const Icon(Icons.add),
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
      body: Constant.tabWidgets[_page],
      drawer: const CommuityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      bottomNavigationBar: isGuest || kIsWeb
          ? null
          : CupertinoTabBar(
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.backgroundColor,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add), label: 'Add post'),
              ],
              onTap: pageChange,
              currentIndex: _page,
            ),
    );
  }
}
