class LocationItem {
  LocationItem(
    this.id,
    this.name,
    this.type,
    this.dimension,
    this.residents,
  );

  final int id;
  final String name;
  final String type;
  final String dimension;
  final List residents;
}

class CharacterItem {
  CharacterItem(
    this.id,
    this.name,
    this.status,
    this.species,
    this.origin,
    this.location,
    this.image,
  );

  final int id;
  final String name;
  final String status;
  final String species;
  final String origin;
  final String location;
  final String image;
}
