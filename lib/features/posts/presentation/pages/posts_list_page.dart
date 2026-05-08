import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/posts_provider.dart';
import 'post_detail_page.dart';

class PostsListPage extends ConsumerStatefulWidget {
  const PostsListPage({super.key});
  @override
  ConsumerState<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends ConsumerState<PostsListPage> {
  bool isSearchMode = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);
    final searchAsync = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: !isSearchMode
            ? const Text("Clean API Posts")
            : TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: "Search posts...", border: InputBorder.none),
          onChanged: (val) => ref.read(searchProvider.notifier).search(val),
        ),
        actions: [
          IconButton(
            icon: Icon(isSearchMode ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => isSearchMode = !isSearchMode);
              if (!isSearchMode) {
                _controller.clear();
                ref.invalidate(searchProvider);
              }
            },
          ),
        ],
      ),
      body: (isSearchMode ? searchAsync : postsAsync).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(posts[index].title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(posts[index].body, maxLines: 1),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailPage(postId: posts[index].id))),
          ),
        ),
      ),
    );
  }
}