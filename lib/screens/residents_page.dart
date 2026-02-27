import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ResidentsPage extends StatefulWidget {
  const ResidentsPage({super.key, required this.residentEndpoint});
  final String residentEndpoint;

  @override
  State<ResidentsPage> createState() => _ResidentsPageState();
}

class _ResidentsPageState extends State<ResidentsPage> {
  @override
  void initState() {
    super.initState();
    dataFetcher();
  }

  late ResidentItem _residentItem;

  int statusCode = 0;

  final Dio _dio = Dio();

  void dataFetcher() async {
    final response = await _dio
        .get(widget.residentEndpoint)
        .timeout(Duration(seconds: 15))
        .catchError((e) {
          return Response(requestOptions: RequestOptions(), statusCode: 408);
        });
    if (response.statusCode == 200) {
      setState(() {
        _residentItem = ResidentItem.fromJson(response.data);
        statusCode = 200;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return statusCode == 200
        ? ExpansionTile(
            initiallyExpanded: false,
            title: Center(child: Text(_residentItem.name)),
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        clipBehavior: .antiAlias,
                        borderRadius: BorderRadiusGeometry.circular(10),
                        child: Image.network(
                          _residentItem.image,
                          fit: BoxFit.cover,
                          width: 150,
                          errorBuilder: (context, error, stackTrace) =>
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: Center(child: Icon(Icons.error_outline_outlined, size: 54,)),
                              ),
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                              ? child
                              : SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Center(
                                    child: CircularProgressIndicator.adaptive(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status: ${_residentItem.status}"),
                          Text("Species: ${_residentItem.species}"),
                          Text("Origin: ${_residentItem.origin}"),
                          Text("Location: ${_residentItem.location}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
  }
}

class ResidentItem {
  late int id;
  late String name;
  late String status;
  late String species;
  late String origin;
  late String location;
  late String image;

  ResidentItem.fromJson(Map json) {
    id = json["id"];
    name = json["name"];
    status = json["status"];
    species = json["species"];
    origin = json["origin"]["name"];
    location = json["location"]["name"];
    image = json["image"];
  }
}
