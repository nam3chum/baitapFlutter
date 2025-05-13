import 'genre.dart';

class Story{
  int id;
  String title;
  String urlImg;
  int numOfChapter;
  String author;
  List<Genre> genres;

  Story({required this.id,required this.title, required this.urlImg, required this.numOfChapter,required this.author,required this.genres});
}