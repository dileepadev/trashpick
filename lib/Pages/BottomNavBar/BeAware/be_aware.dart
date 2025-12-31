import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/articles_model.dart';
import 'package:trashpick/Pages/BottomNavBar/BeAware/read_article.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import '../../../Widgets/primary_app_bar_widget.dart';

class BeAware extends StatefulWidget {
  @override
  _BeAwareState createState() => _BeAwareState();
}

class _BeAwareState extends State<BeAware> {
  int documents;

  @override
  void initState() {
    getTotalArticles();
    super.initState();
  }

  getTotalArticles() async {
    final QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection('Articles').get();
    documents = qSnap.docs.length;
    print(
        "----------------------- TOTAL ARTICLES: $documents -----------------------");
  }

  @override
  Widget build(BuildContext context) {
    Widget articleDetailsCard(
        AsyncSnapshot<QuerySnapshot> snapshot, ArticlesModel articlesModel) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.grey.shade100,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print('Selected Article: ${articlesModel.articleID}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReadArticle(articlesModel.articleLink)),
                );
              },
              child: snapshot.data.docs.length == null
                  ? Container()
                  : Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            articlesModel.articleImage,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  articlesModel.articleTitle,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .fontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor),
                                ),
                                Divider(
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                Text(
                                  articlesModel.articleDescription,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: AppThemeData
                                          .lightTheme.iconTheme.color),
                                ),
                                //Text(trashPickUpsModel.trashLocationAddress),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    }

    _articlesList() {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Articles")
            .orderBy('articlePostedDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container()
              : snapshot.data.docs.length.toString() == "0"
                  ? Container(
                      height: 250.0,
                      width: 200.0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            "You have no articles yet",
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .fontSize),
                          ),
                          Image.asset(
                            'assets/icons/icon_broom.png',
                            height: 100.0,
                            width: 100.0,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        ArticlesModel articlesModel =
                            ArticlesModel.fromDocument(
                                snapshot.data.docs[index]);
                        return articleDetailsCard(snapshot, articlesModel);
                      },
                    );
        },
      );
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Be Aware",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.notifications_rounded,
              color: AppThemeData().secondaryColor,
              size: 35.0,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TrashPick Articles",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                _articlesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
