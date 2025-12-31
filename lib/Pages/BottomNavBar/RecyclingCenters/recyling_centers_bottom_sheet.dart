import 'package:flutter/material.dart';
import 'package:trashpick/Models/recycling_center_model.dart';

class RecyclingCentersBottomSheet {
  detailsTitle(BuildContext context, String detailsTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        detailsTitle,
        style: TextStyle(
            color: Theme.of(context).textTheme.subtitle2.color,
            fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  detailsName(BuildContext context, String detailsName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        detailsName,
        style: TextStyle(
            color: Theme.of(context).textTheme.subtitle2.color,
            fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  showCentersDetails(BuildContext context,
      RecyclingCenterModel recyclingCenterModel, var latitude, var longitude) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).appBarTheme.color,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 14.0,
                        ),
                        Text(
                          "Recycling Center",
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel_rounded),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Name"),
                detailsName(context, recyclingCenterModel.name),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Phone"),
                detailsName(context, recyclingCenterModel.phone),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Address"),
                detailsName(context, recyclingCenterModel.address),
                SizedBox(
                  height: 10.0,
                ),
                detailsTitle(context, "Latitude"),
                detailsName(context, latitude.toString()),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Longitude"),
                detailsName(context, longitude.toString()),
/*                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Street"),
                detailsName(context, street),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Postal Code"),
                detailsName(context, postalCode),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Administrative Area"),
                detailsName(context, administrativeArea),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Sub Administrative Area"),
                detailsName(context, subAdministrativeArea),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Thoroughfare"),
                detailsName(context, thoroughfare),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Sub Thoroughfare"),
                detailsName(context, subThoroughfare),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Locality"),
                detailsName(context, locality),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Sub Locality"),
                detailsName(context, subLocality),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Country"),
                detailsName(context, country),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "ISO Country Code"),
                detailsName(context, isoCountryCode),*/
                SizedBox(
                  height: 80.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
