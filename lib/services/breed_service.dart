import '../models/breed.dart';

class BreedService {
  // Simula una consulta a un servicio externo
  Future<List<Breed>> fetchBreeds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<Map<String, dynamic>> data = [
      // 5 gatos
      {
        "nombre": "Siamés",
        "especie": "Gato",
        "caracteristicas": {
          "tamano": "Mediano",
          "peso": "3-5 kg",
          "vida": "12-15 años",
        },
        "temperamento": ["Vocal", "Cariñoso", "Inteligente"],
        "cuidados": [
          "Alimentación balanceada",
          "Juegos interactivos",
          "Revisiones veterinarias",
        ],
        "salud": ["Problemas cardíacos", "Estrabismo"],
        "curiosidades": ["Originario de Tailandia", "Muy comunicativo"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/3/3e/Siamese_cat.jpg",
        "descripcion":
            "El siamés es una de las razas de gatos más antiguas y reconocidas, famoso por su personalidad vocal y su pelaje distintivo. Son muy sociables y apegados a sus dueños.",
      },
      {
        "nombre": "Persa",
        "especie": "Gato",
        "caracteristicas": {
          "tamano": "Grande",
          "peso": "4-7 kg",
          "vida": "12-17 años",
        },
        "temperamento": ["Tranquilo", "Dócil", "Cariñoso"],
        "cuidados": ["Cepillado diario", "Ambiente tranquilo"],
        "salud": ["Problemas respiratorios", "Enfermedad renal"],
        "curiosidades": ["Popular en concursos", "Nariz chata"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/6/6e/Persian_Cat_by_Lucy.jpg",
      },
      {
        "nombre": "Maine Coon",
        "especie": "Gato",
        "caracteristicas": {
          "tamano": "Muy grande",
          "peso": "6-9 kg",
          "vida": "10-13 años",
        },
        "temperamento": ["Sociable", "Juguetón", "Inteligente"],
        "cuidados": ["Cepillado frecuente", "Ejercicio regular"],
        "salud": ["Displasia de cadera", "Cardiomiopatía"],
        "curiosidades": ["Origen en EE.UU.", "Cola muy peluda"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/5/5e/MaineCoonSilverTabbyToby.jpg",
      },
      {
        "nombre": "Bengalí",
        "especie": "Gato",
        "caracteristicas": {
          "tamano": "Mediano",
          "peso": "4-7 kg",
          "vida": "12-16 años",
        },
        "temperamento": ["Activo", "Curioso", "Juguetón"],
        "cuidados": ["Juguetes interactivos", "Espacio para trepar"],
        "salud": ["Problemas cardíacos", "Luxación patelar"],
        "curiosidades": ["Pelaje tipo leopardo", "Muy energético"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/0/0b/Bengal_cat_2.jpg",
      },
      {
        "nombre": "Sphynx",
        "especie": "Gato",
        "caracteristicas": {
          "tamano": "Mediano",
          "peso": "3-6 kg",
          "vida": "8-14 años",
        },
        "temperamento": ["Cariñoso", "Extrovertido", "Juguetón"],
        "cuidados": ["Baños frecuentes", "Protección solar"],
        "salud": ["Problemas de piel", "Miocardiopatía"],
        "curiosidades": ["Sin pelo", "Muy sociable"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/5/5e/Sphinx_cat.jpg",
      },
      // 5 perros
      {
        "nombre": "Labrador Retriever",
        "especie": "Perro",
        "caracteristicas": {
          "tamano": "Grande",
          "peso": "25-36 kg",
          "vida": "10-12 años",
        },
        "temperamento": ["Amigable", "Inteligente", "Enérgico"],
        "cuidados": ["Ejercicio diario", "Alimentación balanceada"],
        "salud": ["Displasia de cadera", "Obesidad"],
        "curiosidades": ["Excelente nadador", "Muy popular"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/2/26/YellowLabradorLooking_new.jpg",
        "descripcion":
            "El labrador retriever es conocido por su carácter amigable y su inteligencia. Es una de las razas más populares del mundo y excelente como perro de familia y de trabajo.",
      },
      {
        "nombre": "Pastor Alemán",
        "especie": "Perro",
        "caracteristicas": {
          "tamano": "Grande",
          "peso": "22-40 kg",
          "vida": "9-13 años",
        },
        "temperamento": ["Leal", "Valiente", "Inteligente"],
        "cuidados": ["Entrenamiento constante", "Ejercicio físico y mental"],
        "salud": ["Displasia de cadera", "Problemas digestivos"],
        "curiosidades": ["Usado en policía", "Muy protector"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/7/7b/German_Shepherd_Dog.jpg",
      },
      {
        "nombre": "Pug",
        "especie": "Perro",
        "caracteristicas": {
          "tamano": "Pequeño",
          "peso": "6-8 kg",
          "vida": "12-15 años",
        },
        "temperamento": ["Juguetón", "Cariñoso", "Sociable"],
        "cuidados": ["Cuidado de arrugas", "Paseos cortos"],
        "salud": ["Problemas respiratorios", "Obesidad"],
        "curiosidades": ["Cara arrugada", "Muy expresivo"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/6/6f/Pug_600.jpg",
      },
      {
        "nombre": "Border Collie",
        "especie": "Perro",
        "caracteristicas": {
          "tamano": "Mediano",
          "peso": "14-20 kg",
          "vida": "12-15 años",
        },
        "temperamento": ["Activo", "Inteligente", "Trabajador"],
        "cuidados": ["Ejercicio intenso", "Estimulación mental"],
        "salud": ["Epilepsia", "Displasia de cadera"],
        "curiosidades": ["El más inteligente", "Excelente pastor"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/1/19/Border_Collie_liver_portrait.jpg",
      },
      {
        "nombre": "Chihuahua",
        "especie": "Perro",
        "caracteristicas": {
          "tamano": "Muy pequeño",
          "peso": "1-3 kg",
          "vida": "14-17 años",
        },
        "temperamento": ["Valiente", "Alerta", "Devoto"],
        "cuidados": ["Abrigo en frío", "Paseos cortos"],
        "salud": ["Problemas dentales", "Luxación patelar"],
        "curiosidades": ["Raza más pequeña", "Origen mexicano"],
        "imagen_url":
            "https://upload.wikimedia.org/wikipedia/commons/6/6b/Chihuahua1_bvdb.jpg",
      },
    ];
    return data.map((json) => Breed.fromJson(json)).toList();
  }
}
