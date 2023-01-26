import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../controller/post_controller.dart';
import '../widgets/comment_card.dart';

class CommentsSScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsSScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentsSScreenState();
}

class _CommentsSScreenState extends ConsumerState<CommentsSScreen> {
  final TextEditingController commentCtrl = TextEditingController();

  @override
  void dispose() {
    commentCtrl.dispose();
    super.dispose();
  }

  void addComment(String postId) {
    ref
        .read(postControllerProvider.notifier)
        .addComment(context: context, text: commentCtrl.text, postId: postId);
    setState(() {
      commentCtrl.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return Column(
                children: [
                  PostCard(post: post),
                  // if (!isGuest)
                  TextField(
                    onSubmitted: (val) => addComment(post.id),
                    // => addComment(data),
                    controller: commentCtrl,
                    decoration: const InputDecoration(
                      hintText: 'What are your thoughts?',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),

                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final comment = data[index];
                                return CommentCard(comment: comment);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorText(
                            error: error.toString(),
                          );
                        },
                        loading: () => const Loader(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
