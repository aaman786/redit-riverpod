import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/feature/auth/controller/auth_controller.dart';
import 'package:reddit/feature/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/responsive/responsive.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constant.dart';
import '../../../core/utils.dart';
import '../../../theme/pallete.dart';

class EditProfileScren extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScren({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScrenState();
}

class _EditProfileScrenState extends ConsumerState<EditProfileScren> {
  File? bannerFile;
  File? profileFile;

  late TextEditingController nameCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  Future<void> selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  Future<void> selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
        profileFile: profileFile,
        bannerFile: bannerFile,
        name: nameCtrl.text.trim(),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNoifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) {
          return Scaffold(
            backgroundColor: currentTheme.backgroundColor,
            // backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Profile'),
              centerTitle: false,
              actions: [TextButton(onPressed: save, child: const Text("Save"))],
            ),
            body: isLoading
                ? const Loader()
                : Responsive(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color:
                                      currentTheme.textTheme.bodyText2!.color!,
                                  // color: Colors.white,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:
                                        //  bannerWebFile != null
                                        //     ? Image.memory(bannerWebFile!)
                                        //     :
                                        bannerFile != null
                                            ? Image.file(bannerFile!)
                                            : user.banner.isEmpty ||
                                                    user.banner ==
                                                        Constant.bannerDefault
                                                ? const Center(
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 40,
                                                    ),
                                                  )
                                                : Image.network(user.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child:
                                      // profileWebFile != null
                                      //     ? CircleAvatar(
                                      //         backgroundImage: MemoryImage(profileWebFile!),
                                      //         radius: 32,
                                      //       )
                                      //     :
                                      profileFile != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  FileImage(profileFile!),
                                              radius: 32,
                                            )
                                          : CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(user.profilePic),
                                              radius: 32,
                                            ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(18),
                          ),
                        ),
                      ]),
                    ),
                  ),
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
