import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/blog.dart';
import 'package:sickle_cell_app/providers/blog_provider.dart';
import 'package:sickle_cell_app/resources/async_handler.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/resources/utils.dart';
import 'package:sickle_cell_app/screens/admin_screens/add_blog_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/blog_view_screen.dart';

class BlogListScreen extends ConsumerStatefulWidget {
  const BlogListScreen({super.key});

  @override
  ConsumerState<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends ConsumerState<BlogListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      _getBlogs();
    });
  }

  void _getBlogs() async {
    try {
      ref.read(blogProvider.notifier).fetchBlogs();
    } catch (e) {
      showErrorSnackbar("Failed to get blogs", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogs = ref.watch(blogProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("BLOG CORNER"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final response = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddBlogScreen(),
                ),
              );

              if (response == true) {
                _getBlogs();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.all(15),
          child: AsyncHandler<List<Blog>>(
            asyncValue: blogs,
            onData: (context, blogs) {
              if (blogs.isEmpty) {
                return Center(
                  child: Text(
                    "No blogs available",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...blogs.map(
                    (blog) => Column(
                      children: [
                        SingleBlogRow(
                          blog: blog,
                          onChanged: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlogViewScreen(
                                  blog: blog,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SingleBlogRow extends StatefulWidget {
  const SingleBlogRow({
    super.key,
    required this.blog,
    required this.onChanged,
  });

  final Blog blog;
  final Function() onChanged;

  @override
  State createState() => _SingleBlogRowState();
}

class _SingleBlogRowState extends State<SingleBlogRow> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onChanged,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.08, vertical: height * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.truncate(widget.blog.title, 35),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      Utils.truncate(widget.blog.abstract, 40),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.w100,
                          ),
                    ),
                    SizedBox(height: height * 0.01),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (var tag in widget.blog.tags)
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              tag,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
