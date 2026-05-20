# Arquitectura MVC - Pet App

Esta aplicación Flutter sigue el patrón **Model-View-Controller (MVC)** con las mejores prácticas de programación.

## 📁 Estructura del Proyecto

```
lib/
├── main.dart              # Punto de entrada de la aplicación
├── app.dart               # Configuración principal de la app
├── models/                # 📊 MODELS - Datos y lógica de negocio
│   └── pet.dart          # Modelo de mascota
├── views/                 # 🖼️ VIEWS - Interfaces de usuario
│   └── home_view.dart    # Vista principal
├── controllers/           # 🎮 CONTROLLERS - Lógica de control
│   └── pet_controller.dart # Controlador de mascotas
└── widgets/               # 🧩 WIDGETS - Componentes reutilizables
    ├── pet_card.dart     # Tarjeta de mascota
    └── add_pet_dialog.dart # Diálogo para agregar mascota
```

## 🏗️ Patrón MVC

### 1️⃣ Models (Modelos)
**Ubicación:** `lib/models/`

Los modelos representan los datos y la lógica de negocio de la aplicación.

**Responsabilidades:**
- Definir la estructura de los datos
- Validar datos
- Conversión entre JSON y objetos Dart
- Lógica de negocio relacionada con los datos

**Ejemplo:** `pet.dart`
```dart
class Pet {
  final String id;
  final String name;
  final String species;
  // ...
}
```

### 2️⃣ Views (Vistas)
**Ubicación:** `lib/views/`

Las vistas son responsables de mostrar la información al usuario.

**Responsabilidades:**
- Renderizar la interfaz de usuario
- Escuchar cambios del controlador
- Delegar acciones al controlador
- No contener lógica de negocio

**Ejemplo:** `home_view.dart`
```dart
class HomeView extends StatelessWidget {
  final PetController controller;
  // Solo muestra datos y captura eventos
}
```

### 3️⃣ Controllers (Controladores)
**Ubicación:** `lib/controllers/`

Los controladores gestionan la comunicación entre modelos y vistas.

**Responsabilidades:**
- Gestionar el estado de la aplicación
- Procesar acciones del usuario
- Actualizar modelos
- Notificar a las vistas sobre cambios

**Ejemplo:** `pet_controller.dart`
```dart
class PetController extends ChangeNotifier {
  List<Pet> _pets = [];
  
  Future<void> addPet(Pet pet) async {
    _pets.add(pet);
    notifyListeners(); // Notifica a las vistas
  }
}
```

### 4️⃣ Widgets (Componentes)
**Ubicación:** `lib/widgets/`

Widgets reutilizables que pueden ser usados en múltiples vistas.

**Responsabilidades:**
- Componentes de UI reutilizables
- Recibir datos como parámetros
- Emitir eventos a través de callbacks

## 🔄 Flujo de Datos

```
Usuario Interactúa con la Vista
         ↓
Vista llama al Controlador
         ↓
Controlador modifica el Modelo
         ↓
Controlador notifica a las Vistas
         ↓
Vista se actualiza automáticamente
```

## ✨ Buenas Prácticas Implementadas

### 1. Separación de Responsabilidades
Cada componente tiene una responsabilidad clara y única.

### 2. Uso de ChangeNotifier
El controlador usa `ChangeNotifier` para implementar el patrón Observer.

```dart
class PetController extends ChangeNotifier {
  // Notifica cambios a los listeners
  notifyListeners();
}
```

### 3. Widgets Stateless donde sea posible
Las vistas son `StatelessWidget` que escuchan cambios del controlador.

```dart
ListenableBuilder(
  listenable: controller,
  builder: (context, child) {
    // Se reconstruye cuando el controlador notifica cambios
  },
)
```

### 4. Inmutabilidad en Modelos
Los modelos usan propiedades `final` y método `copyWith` para inmutabilidad.

```dart
class Pet {
  final String id;
  final String name;
  
  Pet copyWith({String? name, ...}) { ... }
}
```

### 5. Validación de Datos
Validación en formularios y en el modelo.

### 6. Manejo de Errores
El controlador captura y gestiona errores de forma centralizada.

```dart
try {
  // Operación
} catch (e) {
  _errorMessage = 'Error: $e';
  notifyListeners();
}
```

### 7. Operaciones Asíncronas
Uso correcto de `async/await` para operaciones que toman tiempo.

```dart
Future<void> addPet(Pet pet) async {
  _setLoading(true);
  try {
    await Future.delayed(...);
    _pets.add(pet);
  } finally {
    _setLoading(false);
  }
}
```

### 8. Documentación
Todos los archivos y métodos importantes tienen documentación clara.

```dart
/// Controlador que maneja la lógica de negocio de las mascotas
class PetController extends ChangeNotifier { ... }
```

## 🎯 Ventajas de esta Arquitectura

1. **Escalabilidad:** Fácil agregar nuevas funcionalidades
2. **Mantenibilidad:** Código organizado y fácil de entender
3. **Testabilidad:** Cada componente puede ser probado independientemente
4. **Reutilización:** Widgets y modelos reutilizables
5. **Separación de concerns:** Cada capa tiene su responsabilidad
6. **Claridad:** Estructura clara y predecible

## 🚀 Cómo Extender la Aplicación

### Agregar un nuevo modelo
1. Crear archivo en `lib/models/`
2. Definir la clase con propiedades `final`
3. Implementar `fromJson`, `toJson`, `copyWith`

### Agregar una nueva vista
1. Crear archivo en `lib/views/`
2. Implementar `StatelessWidget`
3. Recibir el controlador como parámetro
4. Usar `ListenableBuilder` para escuchar cambios

### Agregar un nuevo controlador
1. Crear archivo en `lib/controllers/`
2. Extender `ChangeNotifier`
3. Implementar métodos que modifiquen el estado
4. Llamar a `notifyListeners()` después de cambios

### Agregar un widget reutilizable
1. Crear archivo en `lib/widgets/`
2. Implementar un widget que reciba datos por parámetros
3. Usar callbacks para emitir eventos

## 📚 Recursos Adicionales

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Provider Package](https://pub.dev/packages/provider) - Para gestión de estado más avanzada

---

**Nota:** Esta arquitectura es ideal para aplicaciones pequeñas a medianas. Para aplicaciones grandes, considera usar patrones como BLoC, Clean Architecture o MVVM con Provider/Riverpod.
