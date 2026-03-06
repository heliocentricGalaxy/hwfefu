import 'package:dio/dio.dart';
import 'package:hwfefu/api_service/api_service.dart';

class AppRepo {
  AppRepo(this._apiService);

  final ApiService _apiService;

  Future<Response<dynamic>> getLocationList() async {
    return await _apiService.getLocationList();
  }

  Future<Response<dynamic>> getLocationDetails(int id) async {
    return await _apiService.getLocationDetails(id);
  }

  Future<Response<dynamic>> getCharacterDetails(int id) async {
    return await _apiService.getCharacterDetails(id);
  }

  Future<void> initFavs() async => await _apiService.initDB();

  Future<List> getFavs() async => await _apiService.getFavs();

  Future<void> removeFav(int id) async => await _apiService.removeFav(id);

  Future<void> addFav(int id, String name) async =>
      await _apiService.addFav(id, name);
}
