import 'package:flutter/material.dart';
import 'package:hwfefu/repo_service/repo_service.dart';
import 'package:hwfefu/data_types/data_types.dart';

class StateManager extends ChangeNotifier {
  StateManager(this._appRepo);

  final AppRepo _appRepo;

  late List<LocationItem> itemList;

  late CharacterItem characterItem;

  late LocationItem locationItem;

  int itemListStatusCode = 0;
  int characterItemStatusCode = 0;
  int locationItemStatusCode = 0;

  late List<LocationItem> favsItemList;

  bool isFavsLoading = false;

  int navBarState = 0;

  void updateNavBarState(int state) {
    navBarState = state;
    notifyListeners();
  }

  Future<void> getLocationList() async {
    itemListStatusCode = 0;
    notifyListeners();

    final response = await _appRepo.getLocationList();

    if (response.statusCode == 200) {
      itemList = List.generate(response.data["results"].length, (int index) {
        return LocationItem(
          response.data["results"][index]["id"],
          response.data["results"][index]["name"],
          response.data["results"][index]["type"],
          response.data["results"][index]["dimension"],
          response.data["results"][index]["residents"],
        );
      });
      itemListStatusCode = 200;
    } else {
      itemListStatusCode = response.statusCode!;
    }
    notifyListeners();
  }

  Future<void> getCharacterDetails(int id) async {
    characterItemStatusCode = 0;
    notifyListeners();

    final response = await _appRepo.getCharacterDetails(id);

    if (response.statusCode == 200) {
      characterItem = CharacterItem(
        response.data["id"],
        response.data["name"],
        response.data["status"],
        response.data["species"],
        response.data["origin"]["name"],
        response.data["location"]["name"],
        response.data["image"],
      );
      characterItemStatusCode = 200;
    } else {
      characterItemStatusCode = response.statusCode!;
    }
    notifyListeners();
  }

  Future<void> getLocationDetails(int id) async {
    locationItemStatusCode = 0;
    notifyListeners();

    final response = await _appRepo.getLocationDetails(id);

    if (response.statusCode == 200) {
      locationItem = LocationItem(
        response.data["id"],
        response.data["name"],
        response.data["type"],
        response.data["dimension"],
        response.data["residents"],
      );
      locationItemStatusCode = 200;
    } else {
      locationItemStatusCode = response.statusCode!;
    }
    notifyListeners();
  }

  Future<void> initFavs() async {
    isFavsLoading = true;
    notifyListeners();
    await _appRepo.initFavs();
    await getFavs();
    isFavsLoading = false;
    notifyListeners();
  }

  Future<void> getFavs() async {
    isFavsLoading = true;
    notifyListeners();
    List favs = await _appRepo.getFavs().catchError((e) {
      return [];
    });
    favsItemList = List.generate(
      favs.length,
      (int index) => LocationItem(
        favs[index]["location_id"],
        favs[index]["name"],
        "",
        "",
        [],
      ),
    );
    isFavsLoading = false;
    notifyListeners();
  }

  Future<void> removeFav(int id) async {
    isFavsLoading = true;
    notifyListeners();
    await _appRepo.removeFav(id);
    await getFavs();
    isFavsLoading = false;
    notifyListeners();
  }

  Future<void> addFav(int id, String name) async {
    isFavsLoading = true;
    notifyListeners();
    await _appRepo.addFav(id, name);
    await getFavs();
    isFavsLoading = false;
    notifyListeners();
  }
}
