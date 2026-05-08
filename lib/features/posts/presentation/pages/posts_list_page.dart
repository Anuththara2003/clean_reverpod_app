import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/posts_provider.dart';

class PostsListPage extends ConsumerWidget {
  const PostsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("API Posts")),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(posts[index].title),
            subtitle: Text(posts[index].body, maxLines: 1),
          ),
        ),
      ),
    );
  }
}