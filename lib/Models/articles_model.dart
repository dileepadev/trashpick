import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesModel {
  final String articleID;
  final String articleDescription;
  final String articleImage;
  final String articleLink;
  final String articlePostedDate;
  final String articleTitle;

  ArticlesModel({
    this.articleID,
    this.articleDescription,
    this.articleImage,
    this.articleLink,
    this.articlePostedDate,
    this.articleTitle,
  });

  factory ArticlesModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return ArticlesModel(
      articleID: documentSnapshot['articleID'],
      articleDescription: documentSnapshot['articleDescription'],
      articleImage: documentSnapshot['articleImage'],
      articleLink: documentSnapshot['articleLink'],
      articlePostedDate: documentSnapshot['articlePostedDate'],
      articleTitle: documentSnapshot['articleTitle'],
    );
  }
}
