import '../models/breed.dart';
import '../services/breed_service.dart';

class BreedController {
  final BreedService _service = BreedService();

  Future<List<Breed>> getBreeds() async {
    return await _service.fetchBreeds();
  }
}
