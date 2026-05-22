import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/breed.dart';

class BreedService {
  static const String _catsUrl =
      'https://mascotas-api.vercel.app/api/mascotas/razas/gatos';
  static const String _dogsUrl =
      'https://mascotas-api.vercel.app/api/mascotas/razas/perros';

  Future<List<Breed>> fetchBreeds() async {
    final List<Breed> breeds = [];
    try {
      // Fetch cats
      final catsResponse = await http.get(Uri.parse(_catsUrl));
      if (catsResponse.statusCode == 200) {
        final catsList = json.decode(catsResponse.body);
        if (catsList is List) {
          breeds.addAll(
            catsList.map((json) => Breed.fromJson(json)).toList().cast<Breed>(),
          );
        }
      }
      // Fetch dogs
      final dogsResponse = await http.get(Uri.parse(_dogsUrl));
      if (dogsResponse.statusCode == 200) {
        final dogsList = json.decode(dogsResponse.body);
        if (dogsList is List) {
          breeds.addAll(
            dogsList.map((json) => Breed.fromJson(json)).toList().cast<Breed>(),
          );
        }
      }
    } catch (e) {
      // Puedes manejar el error aquí o lanzarlo
      rethrow;
    }
    return breeds;
  }
}
