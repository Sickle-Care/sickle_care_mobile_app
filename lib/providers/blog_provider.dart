import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/blog.dart';
import 'package:sickle_cell_app/services/blog_service.dart';

class BlogNotifier extends StateNotifier<AsyncValue<List<Blog>>> {
  BlogNotifier() : super(const AsyncValue.loading());

  Future<void> fetchBlogs() async {
    try {
      state = const AsyncValue.loading();
      BlogService blogService = BlogService();
      final blogs = await blogService.getAllBlogs();
      state = AsyncValue.data(blogs);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final blogProvider =
    StateNotifierProvider<BlogNotifier, AsyncValue<List<Blog>>>((ref) {
  return BlogNotifier();
});
