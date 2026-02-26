import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AppStateProvider with ChangeNotifier {
  final _dio = Dio();

  final String apiListEndpoint = "https://rickandmortyapi.com/api/location";

  List listDataset = [];
  bool isDatasetError = false;

  void updateDatasetError(bool value) {
    isDatasetError = value;
    notifyListeners();
  }

  void getList(BuildContext context) async {
    final response = await _dio
        .get(apiListEndpoint)
        .timeout(Duration(seconds: 15))
        .catchError((e) {
          return Response(requestOptions: RequestOptions(), statusCode: 408);
        });
    if (response.statusCode == 200) {
      Map jsonResponse = response.data;
      listDataset = jsonResponse["results"];
    } else {
      isDatasetError = true;
      context.mounted
          ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                persist: false,
                content: Text(
                  "Error ${response.statusCode} occured while loading data",
                ),
                action: SnackBarAction(
                  label: "Try again",
                  onPressed: () => getList(context),
                ),
              ),
            )
          : null;
    }
    notifyListeners();
  }
}

