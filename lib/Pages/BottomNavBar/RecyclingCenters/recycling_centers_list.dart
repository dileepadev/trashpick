import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/recycling_center_model.dart';
import 'package:trashpick/Theme/theme_provider.dart';

class RecyclingCentersList extends StatefulWidget {
  @override
  _RecyclingCentersListState createState() => _RecyclingCentersListState();
}

class _RecyclingCentersListState extends State<RecyclingCentersList> {
  final firestoreInstance = FirebaseFirestore.instance;
  RecyclingCenterModel recyclingCenterModel;
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

  Widget recyclingCentersDetailsCard(AsyncSnapshot<QuerySnapshot> snapshot,
      RecyclingCenterModel recyclingCenterModel) {
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
              print('Selected Trash: ${recyclingCenterModel.id}');
/*              setState(() {
                viewTrashPicker = true;
                selectedTrashPickerModel = userModelClass;
              });*/
            },
            child: snapshot.data.docs.length == null
                ? Container()
                : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/icons/icon_recycle.png",
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
                                recyclingCenterModel.name,
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
                                recyclingCenterModel.address,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppThemeData
                                        .lightTheme.iconTheme.color),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                recyclingCenterModel.phone,
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

  _recyclingCentersList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Recycling Centers")
            .orderBy('name', descending: false)
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
                            "No Recycling Centers yet",
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
                        recyclingCenterModel =
                            RecyclingCenterModel.fromDocument(
                                snapshot.data.docs[index]);
                        return recyclingCentersDetailsCard(
                            snapshot, recyclingCenterModel);
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
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              _recyclingCentersList(),
            ],
          ),
        ),
      ),
    );
  }
}
