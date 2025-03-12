import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sickle_cell_app/models/blog.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/services/blog_service.dart';
import 'package:sickle_cell_app/widgets/button.dart';

class AddBlogScreen extends ConsumerStatefulWidget {
  const AddBlogScreen({super.key});

  @override
  ConsumerState<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends ConsumerState<AddBlogScreen> {
  final _titleController = TextEditingController();
  final _abstractController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  final List<BlogSection> _sections = [];

  @override
  void dispose() {
    _titleController.dispose();
    _abstractController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty && _tags.length < 5) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _addSection() {
    final subtitleController = TextEditingController();
    final contentController = TextEditingController();

    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Add Sub Section"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Set width to 80% of screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: subtitleController,
                    keyboardType: TextInputType.text,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "Sub title",
                      fillColor: HexColor("#ffffff"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: contentController,
                    cursorColor: HexColor("#4f4f4f"),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Content",
                      fillColor: HexColor("#ffffff"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (subtitleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  setState(() {
                    _sections.add(BlogSection(
                      subtitle: subtitleController.text,
                      content: contentController.text,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: HexColor("#ffffff"),
            title: const Text("Add Section"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.8, // Set width to 80% of screen width
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: subtitleController,
                    keyboardType: TextInputType.text,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "Sub title",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: contentController,
                    cursorColor: HexColor("#4f4f4f"),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Content",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (subtitleController.text.isNotEmpty &&
                      contentController.text.isNotEmpty) {
                    setState(() {
                      _sections.add(BlogSection(
                        subtitle: subtitleController.text,
                        content: contentController.text,
                      ));
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      );
    }
  }

  void _saveBlog() async {
    if (_titleController.text.isEmpty || _abstractController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and Abstract are required")),
      );
      return;
    }

    try {
      final blog = Blog(
        blogId: "",
        title: _titleController.text,
        tags: _tags,
        abstract: _abstractController.text,
        sections: _sections,
      );

      BlogService blogService = BlogService();
      final response = await blogService.createBlog(blog);
      if (response.blogId != "") {
        showSuccessSnackbar("Blog added successfully", context);
        Navigator.of(context).pop(true);
      } else {
        showErrorSnackbar("Failed to add blog", context);
      }
    } catch (e) {
      showErrorSnackbar("Failed to add blog", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Add Blog",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.1,
            vertical: height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Main Section",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                cursorColor: HexColor("#4f4f4f"),
                decoration: InputDecoration(
                  hintText: "Title",
                  fillColor: HexColor("#f0f3f1"),
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),

              // Abstract TextBox
              TextField(
                controller: _abstractController,
                keyboardType: TextInputType.text,
                cursorColor: HexColor("#4f4f4f"),
                decoration: InputDecoration(
                  hintText: "Abstract",
                  fillColor: HexColor("#f0f3f1"),
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),

              Text(
                "Tags",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tagController,
                keyboardType: TextInputType.text,
                cursorColor: HexColor("#4f4f4f"),
                decoration: InputDecoration(
                  hintText: "Add Tags (up to 5)",
                  // border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTag,
                  ),
                  fillColor: HexColor("#f0f3f1"),
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                onSubmitted: (_) => _addTag(),
              ),
              const SizedBox(height: 10),

              // Display Tags
              Wrap(
                spacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.all(8),
                    label: Text(
                      tag,
                      style: TextStyle(color: Colors.white),
                    ),
                    deleteIcon:
                        const Icon(Icons.close_outlined, color: Colors.white),
                    onDeleted: () => _removeTag(tag),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Sections
              Text(
                "Sub Sections",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
              ),
              const SizedBox(height: 10),

              // Add Section Button
              GestureDetector(
                onTap: _addSection,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add Sub Section',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                // ),
              ),
              const SizedBox(height: 10),

              // Display Sections
              Column(
                children: _sections.map((section) {
                  return ListTile(
                    title: Text(section.subtitle),
                    subtitle: Text(section.content),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Save Button
              MyButton(
                onPressed: _saveBlog,
                buttonText: 'Add Blog',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
