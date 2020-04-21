class Book {
  final String author;
  final String title;
  final String url;

  Book({this.author, this.title, this.url});

 factory Book.fromJson(Map<String, dynamic> json, searchText) {

    return Book(
      author: json['ISBN:'+searchText]['authors'][0]['name'],
      title: json['ISBN:'+searchText]['title'],
      url: json['ISBN:'+searchText]['cover'] == null ? null : json['ISBN:'+searchText]['cover']['large']
    );
  }
}
