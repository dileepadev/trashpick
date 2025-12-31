import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/new_trash_pick_up.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import '../../../Widgets/primary_app_bar_widget.dart';
import '../../../Models/trash_pick_ups_model.dart';
import 'view_trash_details.dart';

class PickMyTrash extends StatefulWidget {
  final String accountType;

  PickMyTrash(this.accountType);

  @override
  _PickMyTrashState createState() => _PickMyTrashState();
}

class _PickMyTrashState extends State<PickMyTrash> {
  final String userProfileID = FirebaseAuth.instance.currentUser.uid.toString();
  final firestoreInstance = FirebaseFirestore.instance;

/*  _scheduledTrashPicksList() {
    return Text("_scheduledTrashPicksList");
  }*/

  Widget trashDetailsCard(AsyncSnapshot<QuerySnapshot> snapshot,
      TrashPickUpsModel trashPickUpsModel) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.grey.shade100,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Selected Trash: ${trashPickUpsModel.trashID}');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewTrashDetails(userProfileID,
                      trashPickUpsModel.trashID, widget.accountType)),
            );
          },
          child: snapshot.data.docs.length == null
              ? Container()
              : Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        trashPickUpsModel.trashImage,
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
                              trashPickUpsModel.trashName,
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
                              trashPickUpsModel.trashDescription,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color:
                                      AppThemeData.lightTheme.iconTheme.color),
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
    );
  }

  _scheduledTrashPicksList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      //color: Colors.red,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(userProfileID)
            .collection('Trash Pick Ups')
            .orderBy('postedDate', descending: true)
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
                            "You have no scheduled trash pick ups yet",
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
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        TrashPickUpsModel trashPickUpsModel =
                            TrashPickUpsModel.fromDocument(
                                snapshot.data.docs[index]);
                        return trashDetailsCard(snapshot, trashPickUpsModel);
                      },
                    );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Pick My Trash",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.transfer_within_a_station_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 35.0,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Made for ${widget.accountType}",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.subtitle1.fontSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                MinButtonWidget(
                  text: "Schedule a Trash Pick Up",
                  color: Theme.of(context).backgroundColor,
                  onClicked: () {
                    print("Pressed: Schedule a Trash Pick Up");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewTrashPickUp(widget.accountType)),
                    );
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "My Scheduled Trash Pick Ups",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                _scheduledTrashPicksList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
