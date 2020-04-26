class FormData{
  String extractedText;
  String page;
  String chapter;
  String thoughts;
  String author;
  String bookname;
  String url;
  List<dynamic> textList = [];

  FormData({this.extractedText, this.page, this.chapter, this.thoughts, this.author, this.bookname, this.url, this.textList});

  Map<String, dynamic> toJson() {
    return {
      'author': this.author,
      'bookname': this.bookname,
      'url': this.url,
      'textList' : this.textList
    };
  }

}