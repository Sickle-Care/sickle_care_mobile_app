import 'package:flutter/material.dart';
import 'package:sickle_cell_app/models/blog.dart';

class BlogViewScreen extends StatelessWidget {
  const BlogViewScreen({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  blog.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (var tag in blog.tags)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                            ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                blog.abstract,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              for (var section in blog.sections) SubItem(section: section),
            ],
          ),
        ),
      ),
    );
  }
}

class SubItem extends StatelessWidget {
  const SubItem({
    super.key,
    required this.section,
  });

  final BlogSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.subtitle,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 10),
        Text(
          section.content,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
