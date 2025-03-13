class Blog {
  final String blogId;
  final String title;
  final List<String> tags;
  final String abstract;
  final List<BlogSection> sections;

  Blog({
    required this.blogId,
    required this.title,
    this.tags = const [],
    required this.abstract,
    required this.sections,
  });

  // Factory method to create a Blog object from JSON
  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blogId'],
      title: json['title'],
      tags: List<String>.from(json['tags'] ?? []),
      abstract: json['abstract'],
      sections: List<BlogSection>.from(
        json['sections']?.map((section) => BlogSection.fromJson(section)) ?? [],
      ),
    );
  }

  // Convert a Blog object to JSON
  Map<String, dynamic> toJson() {
    return {
      'blogId': blogId,
      'title': title,
      'tags': tags,
      'abstract': abstract,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}

class BlogSection {
  final String subtitle;
  final String content;

  BlogSection({
    required this.subtitle,
    required this.content,
  });

  // Factory method to create a BlogSection object from JSON
  factory BlogSection.fromJson(Map<String, dynamic> json) {
    return BlogSection(
      subtitle: json['subtitle'],
      content: json['content'],
    );
  }

  // Convert a BlogSection object to JSON
  Map<String, dynamic> toJson() {
    return {
      'subtitle': subtitle,
      'content': content,
    };
  }
}
