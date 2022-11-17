import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/storage_service.dart';

Widget image_getter(Storage storage) {
  return FutureBuilder(
      future: storage.downloadURL('image1.jpg'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {}
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return Container();
      });
}
