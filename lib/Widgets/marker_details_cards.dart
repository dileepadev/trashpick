import 'package:flutter/material.dart';

import 'button_widgets.dart';

class MarkerDetailsCard {
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

  showSelectLocationDetails(List _trashLocationDetails, context) {
    String latitude,
        longitude,
        name,
        street,
        postalCode,
        administrativeArea,
        subAdministrativeArea,
        thoroughfare,
        subThoroughfare,
        locality,
        subLocality,
        country,
        isoCountryCode;

    if (_trashLocationDetails[0] == "") {
      latitude = "No latitude found";
    } else {
      latitude = _trashLocationDetails[0].toString();
    }

    if (_trashLocationDetails[1] == "") {
      longitude = "No longitude found";
    } else {
      longitude = _trashLocationDetails[1].toString();
    }

    if (_trashLocationDetails[2] == "") {
      name = "No name found";
    } else {
      name = _trashLocationDetails[2].toString();
    }

    if (_trashLocationDetails[3] == "") {
      street = "No street found";
    } else {
      street = _trashLocationDetails[3].toString();
    }

    if (_trashLocationDetails[4] == "") {
      postalCode = "No postal code found";
    } else {
      postalCode = _trashLocationDetails[4].toString();
    }

    if (_trashLocationDetails[5] == "") {
      administrativeArea = "No administrative area found";
    } else {
      administrativeArea = _trashLocationDetails[5].toString();
    }

    if (_trashLocationDetails[6] == "") {
      subAdministrativeArea = "No sub administrative area found";
    } else {
      subAdministrativeArea = _trashLocationDetails[6].toString();
    }

    if (_trashLocationDetails[7] == "") {
      thoroughfare = "No thoroughfare found";
    } else {
      thoroughfare = _trashLocationDetails[7].toString();
    }

    if (_trashLocationDetails[8] == "") {
      subThoroughfare = "No sub thoroughfare found";
    } else {
      subThoroughfare = _trashLocationDetails[8].toString();
    }

    if (_trashLocationDetails[9] == "") {
      locality = "No locality found";
    } else {
      locality = _trashLocationDetails[9].toString();
    }

    if (_trashLocationDetails[10] == "") {
      subLocality = "No sub locality found";
    } else {
      subLocality = _trashLocationDetails[10].toString();
    }

    if (_trashLocationDetails[11] == "") {
      country = "No country found";
    } else {
      country = _trashLocationDetails[11].toString();
    }

    if (_trashLocationDetails[12] == "") {
      isoCountryCode = "No ISO country code found";
    } else {
      isoCountryCode = _trashLocationDetails[12].toString();
    }

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
                          "Location Address",
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
                  height: 10.0,
                ),
                detailsTitle(context, "Latitude"),
                detailsName(context, latitude),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Longitude"),
                detailsName(context, longitude),
                SizedBox(
                  height: 5.0,
                ),
                detailsTitle(context, "Name"),
                detailsName(context, name),
                SizedBox(
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
                detailsName(context, isoCountryCode),
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
