import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ApiService {
  final _dio = Dio();
  final String _apiEndpoint = "https://rickandmortyapi.com/api";

  late Database _appFavsDB;

  Future<Response<dynamic>> getLocationList() async {
    final response = await _dio
        .get("$_apiEndpoint/location")
        .timeout(Duration(seconds: 15))
        .catchError((e) {
          return Response(requestOptions: RequestOptions(), statusCode: 408);
        });

    return response;
  }

  Future<Response<dynamic>> getLocationDetails(int id) async {
    final response = await _dio
        .get("$_apiEndpoint/location/$id")
        .timeout(Duration(seconds: 15))
        .catchError((e) {
          return Response(requestOptions: RequestOptions(), statusCode: 408);
        });
    return response;
  }

  Future<Response<dynamic>> getCharacterDetails(int id) async {
    final response = await _dio
        .get("$_apiEndpoint/character/$id")
        .timeout(Duration(seconds: 15))
        .catchError((e) {
          return Response(requestOptions: RequestOptions(), statusCode: 408);
        });
    return response;
  }

  Future<void> initDB() async {
    _appFavsDB = await openDatabase(
      'app_favs.db',
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS app_favs(name TEXT, location_id INTEGER);",
        );
      },
      version: 1,
    );
  }

  Future<List> getFavs() async {
    return await _appFavsDB.rawQuery(("SELECT * FROM app_favs;"));
  }

  Future<void> removeFav(int id) async {
    await _appFavsDB.execute("DELETE FROM app_favs WHERE location_id = $id;");
  }

  Future<void> addFav(int id, String name) async {
    await _appFavsDB.execute("INSERT INTO app_favs VALUES (\"$name\", $id);");
  }
}
