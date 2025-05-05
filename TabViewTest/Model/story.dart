import 'genre.dart';

class Story{
  int id;
  String title;
  String urlImg;
  int numOfChapter;
  String author;
  List<Genre> genres;

  Story({required this.id,required this.title, required this.urlImg, required this.numOfChapter,required this.author,required this.genres});
  // factory Story.fromJson(Map<String, dynamic> json) {
  //   return Story(
  //     id: json['id']??0,
  //     title: json['title'] ?? '',
  //     urlImg: json['urlImg'] ?? '',
  //     numOfChapter: json['numOfChapter'] ?? '',
  //     author: json['author']??'',
  //     genres: json['genres'],
  //   );
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id':id,
  //     'title': title,
  //     'urlImg': urlImg,
  //     'numOfChapter': numOfChapter,
  //     'author': author,
  //     'genres': genres,
  //   };
  // }
}