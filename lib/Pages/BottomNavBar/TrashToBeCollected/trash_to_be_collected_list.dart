import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/trash_pick_ups_model.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/pick_my_trash_page.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/view_trash_details.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';

class TrashToBeCollectedList extends StatefulWidget {
  @override
  _TrashToBeCollectedListState createState() => _TrashToBeCollectedListState();
}

class _TrashToBeCollectedListState extends State<TrashToBeCollectedList> {
  final firestoreInstance = FirebaseFirestore.instance;
  TrashPickUpsModel trashPickUpsModel;
  UserModelClass selectedTrashPickerModel;
  String accountType = "Trash Collector";
  bool viewTrashPicker = false;

  @override
  void initState() {
    super.initState();
  }

  loadingProgress() {
    return Container(
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(),
          height: 40.0,
          width: 40.0,
        ),
      ),
    );
  }

  Widget trashPickersDetailsCard(
      AsyncSnapshot<QuerySnapshot> snapshot, UserModelClass userModelClass) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.grey.shade100,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              print('Selected Trash: ${userModelClass.uuid}');
              setState(() {
                viewTrashPicker = true;
                selectedTrashPickerModel = userModelClass;
              });
            },
            child: snapshot.data.docs.length == null
                ? Container()
                : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Image.network(
                            userModelClass.profileImage,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                          ),
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
                                userModelClass.name,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .fontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                userModelClass.homeAddress,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppThemeData
                                        .lightTheme.iconTheme.color),
                              ),
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

  _trashPickersList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where('accountType', isEqualTo: "Trash Picker")
            //.orderBy('name',descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingProgress();
          }
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
                            "No Trash Pickers registered yet",
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .fontSize),
                          ),
                          ClipOval(
                            child: Image.asset(
                              'assets/images/trashpick_user_avatar.png',
                              height: 60.0,
                              width: 60.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModelClass userModelClass =
                            UserModelClass.fromDocument(
                                snapshot.data.docs[index]);
                        return trashPickersDetailsCard(
                            snapshot, userModelClass);
                      },
                    );
        },
      ),
    );
  }

  getAllTrashPickUps() {
    FirebaseFirestore.instance.collection("Users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(result.id)
            .collection("Trash Pick Ups")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            TrashPickUpsModel trashPickUpsModel =
                TrashPickUpsModel.fromDocument(result);

            print("--------------------- Trash Pick Ups ---------------------\n"
                "id: ${trashPickUpsModel.trashID}\n"
                "name: ${trashPickUpsModel.trashName}\n"
                "image: ${trashPickUpsModel.trashImage}");
          });
        });
      });
    });
  }

  _selectedTrashPicker() {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                setState(() {
                  viewTrashPicker = false;
                });
              },
            ),
            Text(
              "${selectedTrashPickerModel.name}'s Trash Pick Ups",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        _scheduledTrashPicksList(
            selectedTrashPickerModel.name, selectedTrashPickerModel.uuid),
      ],
    );
  }

  Widget trashDetailsCard(AsyncSnapshot<QuerySnapshot> snapshot,
      TrashPickUpsModel trashPickUpsModel, String userID) {
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
                  builder: (context) => ViewTrashDetails(
                      userID, trashPickUpsModel.trashID, "Trash Collector")),
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

  _scheduledTrashPicksList(String userName, String userID) {
    return Container(
      height: MediaQuery.of(context).size.height,
      //color: Colors.red,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
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
                            "$userName has no scheduled trash pick ups yet",
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
                        return trashDetailsCard(
                            snapshot, trashPickUpsModel, userID);
                      },
                    );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: viewTrashPicker
              ? Container(
                  child: _selectedTrashPicker(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Trash Pickers",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    _trashPickersList(),
                  ],
                ),
        ),
      ),
    );
  }
}
