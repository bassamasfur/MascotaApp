# 📱 Mockup Inicial - Pet App

## Pantallas Base (según imágenes proporcionadas)

### 🏠 Pantalla 1: "Mi Mascota" (Home/Perfil)

#### Estructura Visual:
```
┌─────────────────────────┐
│  ☰  Mi Mascota      ⚙️  │ ← AppBar azul
├─────────────────────────┤
│                         │
│   ┌─────────────────┐   │
│   │   🐱 [Foto]    │   │ ← Foto circular
│   │                 │   │
│   │  Luna           │   │ ← Nombre grande
│   │  Gato | 3 años  │   │ ← Info básica
│   │  Peso: 4.2 kg   │   │
│   │  Raza: Mestizo  │   │
│   │         [Editar]│   │ ← Botón editar
│   └─────────────────┘   │
│                         │
│  📊 Datos de Salud      │ ← Sección
│  ┌─────┐  ┌─────────┐  │
│  │ 🍽️  │  │   💊    │  │ ← Cards horizontales
│  │Dieta│  │Medicam. │  │
│  └─────┘  └─────────┘  │
│                         │
│  🔔 Recordatorios       │ ← Sección
│  ┌──────────────────┐  │
│  │ 🚨 Vacuna anti-  │  │
│  │    rrábica       │  │
│  │ Próxima dosis:   │  │
│  │ 15 Jun          ›│  │
│  └──────────────────┘  │
│  ┌──────────────────┐  │
│  │ 📋 Visita al     │  │
│  │    Veterinario   │  │
│  │ Chequeo general  │  │
│  │ 20 Jun          ›│  │
│  └──────────────────┘  │
│                         │
│  💡 Sugerencias para    │ ← Sección con fondo azul claro
│     Luna                │
│  ┌──────────────────┐  │
│  │ 🎯 Juega con     │  │
│  │    Luna al menos │  │
│  │    15 min al día │  │
│  │                  │  │
│  │ 🪵 Ofrece        │  │
│  │    rascadores    │  │
│  └──────────────────┘  │
│                         │
│  ┌───────────────────┐ │
│  │ + Añade Mascota  │ │ ← Botón verde grande
│  └───────────────────┘ │
└─────────────────────────┘
```

#### Componentes Necesarios:
1. **PetProfileCard**: Card con foto, nombre, info básica
2. **HealthDataSection**: Grid de cards de salud
3. **RemindersList**: Lista de recordatorios pendientes
4. **SuggestionBox**: Caja con sugerencias personalizadas
5. **AddPetButton**: Botón flotante/fijo para agregar mascota

---

### 📋 Pantalla 2: "Recomendaciones para [Nombre]"

#### Estructura Visual:
```
┌─────────────────────────┐
│ ← Recomendaciones   ℹ️  │ ← AppBar con back button
│   para Luna             │
├─────────────────────────┤
│                         │
│  ┌─────────────────┐    │
│  │ 🐱 [Foto]       │    │ ← Header con info resumida
│  │ Gato Mestizo    │    │
│  │ 3 años | 4.2 kg │    │
│  └─────────────────┘    │
│                         │
│  🥗 Alimentación        │ ← Card verde
│     Recomendada         │
│  ┌──────────────────┐  │
│  │ • Proporcionale  │  │
│  │   comida seca    │  │
│  │   alta en        │  │
│  │   proteínas      │  │
│  │                  │  │
│  │ • Sirve 2        │  │
│  │   porciones      │  │
│  │   pequeñas al día│  │
│  └──────────────────┘  │
│                         │
│  🏃 Ejercicio y         │ ← Card azul
│     Actividad           │
│  ┌──────────────────┐  │
│  │ • Juega con Luna │  │
│  │   al menos 15    │  │
│  │   minutos al día │  │
│  │                  │  │
│  │ • Usa rascadores │  │
│  │   y juguetes     │  │
│  │   interactivos   │  │
│  └──────────────────┘  │
│                         │
│  🏥 Cuidados de Salud   │ ← Card rojo/naranja
│  ┌──────────────────┐  │
│  │ • Limpia sus     │  │
│  │   orejas una vez │  │
│  │   por semana     │  │
│  │                  │  │
│  │ • Agenda un      │  │
│  │   chequeo        │  │
│  │   veterinario    │  │
│  │   cada 6 meses   │  │
│  └──────────────────┘  │
│                         │
│  💡 Sabías que:         │ ← Card amarillo
│  ┌──────────────────┐  │
│  │ Los gatos        │  │
│  │ mestizos suelen  │  │
│  │ ser muy curiosos │  │
│  │ y activos.       │  │
│  │ Bríndales un     │  │
│  │ entorno          │  │
│  │ enriquecido.     │  │
│  └──────────────────┘  │
│                         │
│  ┌───────────────────┐ │
│  │ Guardar Mascota  │ │ ← Botón verde
│  └───────────────────┘ │
└─────────────────────────┘
```

#### Componentes Necesarios:
1. **PetSummaryHeader**: Header compacto con info de mascota
2. **RecommendationCard**: Card temática con icono y lista de bullets
3. **FunFactCard**: Card especial para datos curiosos
4. **SaveButton**: Botón de acción principal

---

## 🎨 Paleta de Colores

### Colores Principales:
- **Azul Principal**: `#2196F3` (AppBar, headers)
- **Azul Claro**: `#E3F2FD` (Fondos de sugerencias)
- **Verde**: `#4CAF50` (Botones de acción, alimentación)
- **Naranja**: `#FF9800` (Alertas, cuidados de salud)
- **Rojo**: `#F44336` (Alertas urgentes)
- **Amarillo**: `#FFC107` (Fun facts, tips)
- **Gris**: `#757575` (Textos secundarios)
- **Blanco**: `#FFFFFF` (Fondos de cards)

### Iconos por Categoría:
- **Alimentación**: 🥗 🍽️ 
- **Medicamentos**: 💊 
- **Ejercicio**: 🏃 🎯 
- **Salud**: 🏥 ❤️ 
- **Vacunas**: 💉 🚨 
- **Veterinario**: 👨‍⚕️ 📋 
- **Sugerencias**: 💡 ⭐ 
- **Cuidados**: ✂️ 🪥 

---

## 📐 Especificaciones de Diseño

### Espaciado:
- **Padding general**: 16px
- **Espacio entre cards**: 12px
- **Espacio entre secciones**: 24px
- **Border radius**: 12px (cards)

### Tipografía:
- **Título principal**: 24px, Bold
- **Nombre de mascota**: 28px, Bold
- **Secciones**: 18px, SemiBold
- **Texto normal**: 14px, Regular
- **Texto secundario**: 12px, Regular

### Componentes Comunes:
- **Cards**: Elevación 2, border radius 12px
- **Botones primarios**: Alto 48px, full width
- **Iconos**: 24x24px (estándar), 48x48px (grandes)
- **Foto de perfil**: 80x80px (lista), 120x120px (perfil completo)

---

## 🔄 Flujo de Navegación

```
Home (Lista de Mascotas)
    ↓
Perfil de Mascota
    ├→ Editar Mascota
    ├→ Recomendaciones para [Nombre]
    ├→ Historial Médico
    │   ├→ Vacunas
    │   ├→ Medicamentos
    │   └→ Visitas al Veterinario
    ├→ Recordatorios
    │   └→ Crear/Editar Recordatorio
    └→ Agenda de Cuidados
        ├→ Alimentación
        └→ Ejercicio

Agregar Mascota (Modal)
    ├→ Tomar/Seleccionar Foto
    ├→ Detectar Raza (IA)
    └→ Guardar → Recomendaciones
```

---

## ✅ Checklist de Implementación del Mockup

### Paso 1: Modelos de Datos
- [ ] Expandir Pet model (peso, raza, fecha_nacimiento, foto)
- [ ] Crear Reminder model
- [ ] Crear HealthData model
- [ ] Crear Recommendation model

### Paso 2: Pantalla de Perfil
- [ ] AppBar con título y botón de configuración
- [ ] PetProfileCard con foto circular
- [ ] Sección "Datos de Salud" con grid de cards
- [ ] Sección "Recordatorios" con lista
- [ ] Sección "Sugerencias" con fondo especial
- [ ] Botón "Añade Mascota"

### Paso 3: Pantalla de Recomendaciones
- [ ] AppBar con back button e info
- [ ] PetSummaryHeader
- [ ] Card de Alimentación (verde)
- [ ] Card de Ejercicio (azul)
- [ ] Card de Cuidados de Salud (naranja)
- [ ] Card de "Sabías que" (amarillo)
- [ ] Botón "Guardar Mascota"

### Paso 4: Componentes Reutilizables
- [ ] InfoCard (base para todas las cards temáticas)
- [ ] SectionHeader
- [ ] ReminderItem
- [ ] HealthMetricCard
- [ ] BulletList

---

## 🎯 Estado Actual vs Mockup

### ✅ Ya Tenemos:
- Estructura MVC
- Lista básica de mascotas
- CRUD de mascotas
- Modal para agregar mascota

### ⏳ Por Implementar (Prioridad Alta):
1. Expandir campos del modelo Pet
2. Pantalla de perfil completo (Mockup 1)
3. Sistema de recordatorios básico
4. Pantalla de recomendaciones (Mockup 2)
5. Cards temáticas para diferentes secciones

### 🔮 Futuro:
- Historial médico completo
- Integración con IA para recomendaciones
- Detección de raza por foto
- Dashboard con gráficos
- Sistema de notificaciones

---

## 💡 Sugerencias de Implementación

1. **Empezar por los datos**: Expandir modelos antes de UI
2. **Componentes reutilizables**: Crear InfoCard base que se pueda tematizar
3. **Mock data**: Usar datos de ejemplo para cada mascota
4. **Navegación**: Implementar Navigator para ir entre pantallas
5. **Consistencia**: Mantener colores y espaciados del theme actual

---

**Próximo paso recomendado**: Tarea 1.1 - Expandir modelo Pet con todos los campos necesarios.
