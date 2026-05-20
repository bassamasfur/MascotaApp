# 🐾 Roadmap - Pet App

## Visión del Proyecto
Asistente digital de salud y bienestar para mascotas con IA, que combina gestión médica, recomendaciones personalizadas y gamificación.

---

## 📋 FASE 1: MVP - Funcionalidades Básicas (4-6 semanas)

### Milestone 1: Perfil de Mascota Completo
**Objetivo**: Crear el perfil detallado de cada mascota

- [ ] **Tarea 1.1**: Expandir modelo Pet con campos completos
  - Agregar: raza, peso, fecha_nacimiento, foto
  - Agregar: tipo_raza (puro/mestizo), color, género
  - Agregar: microchip, número_registro

- [ ] **Tarea 1.2**: Pantalla de perfil de mascota (según mockup 1)
  - Vista detallada con foto circular
  - Sección "Datos de Salud"
  - Sección "Recordatorios"
  - Sección "Sugerencias para [nombre]"

- [ ] **Tarea 1.3**: Formulario de edición de mascota
  - Permitir subir foto desde galería/cámara
  - Campos: peso, raza, edad
  - Botón "Editar" en perfil

- [ ] **Tarea 1.4**: Implementar perfil multi-mascota
  - Lista de mascotas en home
  - Navegación entre perfiles
  - Indicador de mascota activa

---

### Milestone 2: Historial Médico
**Objetivo**: Registrar y consultar historial veterinario

- [ ] **Tarea 2.1**: Modelo de datos médicos
  - Model: Vaccine (nombre, fecha, próxima_dosis, veterinario)
  - Model: Medication (nombre, dosis, frecuencia, fecha_inicio, fecha_fin)
  - Model: VetVisit (fecha, motivo, diagnóstico, tratamiento, costo)

- [ ] **Tarea 2.2**: Vista de historial de vacunas
  - Lista de vacunas aplicadas
  - Indicador de estado (al día/vencida/próxima)
  - Botón para agregar nueva vacuna

- [ ] **Tarea 2.3**: Vista de medicamentos
  - Lista de medicamentos actuales y pasados
  - Horarios de administración
  - Notificación de dosis

- [ ] **Tarea 2.4**: Vista de visitas al veterinario
  - Historial de consultas
  - Detalles de cada visita
  - Notas del veterinario

---

### Milestone 3: Sistema de Recordatorios
**Objetivo**: Notificaciones de cuidados importantes

- [ ] **Tarea 3.1**: Modelo de Recordatorios
  - Model: Reminder (tipo, fecha, hora, repetición, completado)
  - Tipos: vacuna, medicamento, cita, desparasitación

- [ ] **Tarea 3.2**: Vista de recordatorios (como en mockup 1)
  - Lista de recordatorios pendientes
  - Badge con días restantes
  - Botón para completar/posponer

- [ ] **Tarea 3.3**: Crear/Editar recordatorio
  - Formulario con fecha/hora
  - Selector de repetición (diario, semanal, mensual, anual)
  - Notificación push

- [ ] **Tarea 3.4**: Sistema de notificaciones locales
  - Configurar flutter_local_notifications
  - Notificaciones programadas
  - Gestión de permisos

---

### Milestone 4: Agenda de Cuidados
**Objetivo**: Rutinas diarias de alimentación y ejercicio

- [ ] **Tarea 4.1**: Modelo de Rutinas
  - Model: FeedingSchedule (horarios, cantidad, tipo_alimento)
  - Model: ActivityLog (fecha, tipo_actividad, duración)

- [ ] **Tarea 4.2**: Vista de alimentación (como mockup 1)
  - Horarios de comida configurados
  - Checkbox para marcar comidas dadas
  - Recomendaciones de cantidad

- [ ] **Tarea 4.3**: Vista de ejercicio y actividad
  - Log de actividades realizadas
  - Tiempo de ejercicio recomendado vs real
  - Tipos: paseo, juego, entrenamiento

- [ ] **Tarea 4.4**: Dashboard de cuidados diarios
  - Vista resumen del día
  - Tareas completadas/pendientes
  - Racha de días cumplidos

---

## 🚀 FASE 2: Funcionalidades Diferenciadoras (6-8 semanas)

### Milestone 5: Recomendaciones con IA (como mockup 2)
**Objetivo**: Sugerencias personalizadas según mascota

- [ ] **Tarea 5.1**: Pantalla de recomendaciones (mockup 2)
  - Sección: Alimentación Recomendada
  - Sección: Ejercicio y Actividad
  - Sección: Cuidados de Salud
  - Sección: Sabías que...

- [ ] **Tarea 5.2**: Sistema de recomendaciones basado en reglas
  - Algoritmo según raza, edad, peso
  - Base de conocimiento de razas comunes
  - Recomendaciones de dieta y ejercicio

- [ ] **Tarea 5.3**: Integración con API de IA (OpenAI/Gemini)
  - Endpoint para generar recomendaciones
  - Prompt engineering para mascotas
  - Cache de recomendaciones

- [ ] **Tarea 5.4**: Actualización automática de recomendaciones
  - Recalcular cuando cambia peso/edad
  - Notificar cambios importantes
  - Historial de recomendaciones

---

### Milestone 6: Detección de Raza por Foto
**Objetivo**: Identificar raza automáticamente

- [ ] **Tarea 6.1**: Captura de foto de mascota
  - Integrar image_picker
  - Opción cámara/galería
  - Recorte y ajuste de imagen

- [ ] **Tarea 6.2**: Integración con API de detección de raza
  - Evaluar: Dog API, Cat API, o custom model
  - Endpoint de clasificación
  - Manejo de resultados

- [ ] **Tarea 6.3**: UI de sugerencia de raza
  - Mostrar % de confianza
  - Opción "Es mestizo"
  - Permitir corrección manual

- [ ] **Tarea 6.4**: Mejora de perfil con foto
  - Auto-completar datos según raza detectada
  - Sugerencias de peso/tamaño esperado
  - Info de características de la raza

---

### Milestone 7: Panel de Bienestar Visual
**Objetivo**: Gráficos e indicadores de salud

- [ ] **Tarea 7.1**: Gráfico de evolución de peso
  - Chart de línea temporal
  - Rango saludable según raza
  - Alertas de sobrepeso/bajo peso

- [ ] **Tarea 7.2**: Indicadores tipo semáforo
  - Salud: verde/amarillo/rojo
  - Vacunas al día
  - Actividad física
  - Alimentación

- [ ] **Tarea 7.3**: Dashboard de bienestar
  - Score general de salud
  - Métricas clave visuales
  - Comparativa con mes anterior

- [ ] **Tarea 7.4**: Integrar charts (fl_chart o similar)
  - Gráfico de barras para actividad
  - Gráfico circular para nutrición
  - Animaciones

---

### Milestone 8: Modo Offline
**Objetivo**: Funcionalidad sin conexión

- [ ] **Tarea 8.1**: Implementar base de datos local
  - Migrar a SQLite (sqflite)
  - Persistencia de todos los datos
  - Sincronización pendiente

- [ ] **Tarea 8.2**: Sistema de sincronización
  - Queue de operaciones offline
  - Sync cuando vuelve conexión
  - Manejo de conflictos

- [ ] **Tarea 8.3**: Indicador de estado de conexión
  - Badge online/offline
  - Notificar cuando se sincroniza
  - Datos pendientes de sync

---

### Milestone 9: Integración con Veterinarios
**Objetivo**: Conectar con clínicas locales

- [ ] **Tarea 9.1**: Exportar historial médico a PDF
  - Generar PDF con todos los datos
  - Incluir gráficos y fotos
  - Botón de compartir/enviar

- [ ] **Tarea 9.2**: Geolocalización de veterinarios
  - Integrar Google Maps API
  - Lista de clínicas cercanas
  - Filtros: distancia, especialidad, rating

- [ ] **Tarea 9.3**: Directorio de veterinarios
  - Perfil de veterinario
  - Horarios, contacto, servicios
  - Opción de llamar/navegar

- [ ] **Tarea 9.4**: Compartir historial directo
  - Enviar PDF por email/WhatsApp
  - QR code con datos de mascota
  - Portal para veterinarios (futuro)

---

### Milestone 10: Chatbot de Consultas
**Objetivo**: Asistente IA 24/7

- [ ] **Tarea 10.1**: UI de chat
  - Pantalla de conversación
  - Burblas de mensajes
  - Entrada de texto

- [ ] **Tarea 10.2**: Integración con IA (GPT/Gemini)
  - Contexto de mascota en prompts
  - Respuestas sobre salud/cuidados
  - Limitaciones y disclaimers

- [ ] **Tarea 10.3**: Base de conocimiento
  - FAQs pre-cargadas
  - Respuestas rápidas comunes
  - Links a recursos confiables

- [ ] **Tarea 10.4**: Historial de conversaciones
  - Guardar chats importantes
  - Buscar en historial
  - Compartir respuestas

---

### Milestone 11: Gamificación
**Objetivo**: Motivar el cuidado consistente

- [ ] **Tarea 11.1**: Sistema de logros
  - Definir logros/achievements
  - Iconos y descripciones
  - Notificación al desbloquear

- [ ] **Tarea 11.2**: Vista de insignias
  - Galería de logros desbloqueados
  - Progreso de logros en curso
  - Compartir en redes sociales

- [ ] **Tarea 11.3**: Sistema de puntos y rachas
  - Puntos por completar tareas
  - Racha de días consecutivos
  - Leaderboard (opcional)

- [ ] **Tarea 11.4**: Recompensas virtuales
  - Unlocks de temas/avatares
  - Stickers especiales
  - Certificados descargables

---

## 🎨 FASE 3: Mejoras y Pulido (2-4 semanas)

### Milestone 12: UI/UX Profesional
- [ ] Implementar tema personalizado coherente
- [ ] Animaciones y transiciones suaves
- [ ] Modo oscuro
- [ ] Onboarding tutorial
- [ ] Mejoras de accesibilidad

### Milestone 13: Backend y Autenticación
- [ ] Configurar Firebase/Supabase
- [ ] Sistema de login (email/Google/Apple)
- [ ] Sincronización en la nube
- [ ] Backup automático

### Milestone 14: Testing y Calidad
- [ ] Tests unitarios (models, controllers)
- [ ] Tests de widgets
- [ ] Tests de integración
- [ ] Corrección de bugs

### Milestone 15: Preparación para Producción
- [ ] Optimización de rendimiento
- [ ] Reducción de tamaño de app
- [ ] Documentación de código
- [ ] Preparar stores (Play/App Store)

---

## 📱 Arquitectura Técnica

### Stack Tecnológico
- **Framework**: Flutter
- **Arquitectura**: MVC (actual) → Migrar a Clean Architecture
- **Base de datos local**: SQLite (sqflite)
- **Backend**: Firebase/Supabase
- **IA**: OpenAI API / Google Gemini
- **Notificaciones**: flutter_local_notifications
- **Charts**: fl_chart
- **PDF**: pdf + printing
- **Imágenes**: image_picker, image_cropper
- **Maps**: google_maps_flutter
- **State Management**: Provider (expandir actual)

### Estructura de Carpetas Propuesta
```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── services/
├── data/
│   ├── models/
│   ├── repositories/
│   └── data_sources/
├── domain/
│   ├── entities/
│   └── use_cases/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── controllers/
└── main.dart
```

---

## 🎯 Priorización Sugerida

### Sprint 1 (2 semanas): Perfil y Datos Básicos
- Milestone 1 completo
- Tarea 2.1 del Milestone 2

### Sprint 2 (2 semanas): Historial Médico
- Milestone 2 completo

### Sprint 3 (2 semanas): Recordatorios
- Milestone 3 completo

### Sprint 4 (2 semanas): Agenda y MVP
- Milestone 4 completo
- **DEMO MVP**

### Sprint 5 (2 semanas): Recomendaciones IA
- Milestone 5 completo

### Sprint 6 (2 semanas): Detección de Raza
- Milestone 6 completo

### Sprints 7-10: Resto de features diferenciadores

---

## 📊 Métricas de Éxito
- [ ] 1000+ descargas en primer mes
- [ ] Rating >4.5 estrellas
- [ ] 60% retención a 30 días
- [ ] 30% usuarios con >1 mascota registrada
- [ ] 80% usuarios con recordatorios activos

---

## 🚦 Estado Actual
✅ Estructura MVC básica implementada  
✅ Modelo Pet inicial  
✅ CRUD básico de mascotas  
⏳ **SIGUIENTE**: Expandir modelo Pet con campos completos (Tarea 1.1)
