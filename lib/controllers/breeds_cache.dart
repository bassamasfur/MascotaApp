import '../models/breed.dart';

class BreedsCache {
  static final BreedsCache _instance = BreedsCache._internal();
  factory BreedsCache() => _instance;
  BreedsCache._internal();

  List<Breed>? breeds;
}
