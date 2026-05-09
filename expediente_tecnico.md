# Expediente Técnico Detallado: Control de Asistencia App

## 1. Introducción
Esta aplicación Flutter permite gestionar el control de asistencia laboral. Incluye funcionalidades para empleados (marcar entrada/salida, ver historial) y administradores (monitoreo, gestión de usuarios, reportes). Opera con almacenamiento local (SharedPreferences), sin backend.

**Nombre del Proyecto:** control_asistencia_app  
**Versión Flutter:** >=3.0.0 <4.0.0  
**Dependencias Principales:** shared_preferences: ^2.5.3  
**Assets:** bg_splash.png, bg_login.png, logo.png  
**Plataformas:** Android, iOS, Web, Desktop  

## 2. Arquitectura General
- **Estructura de Navegación:** Rutas nombradas en `app_routes.dart`.
- **Estado:** Gestionado por `SessionService` (login, check-in/out).
- **UI Común:** `AppScaffold` (barra superior, navegación inferior, FAB), `SectionCard` (tarjetas con sombra), colores en `AppColors` (brown, green, red, etc.).
- **Layout:** Constrained a 390px ancho, bordes redondeados, fondo gris para simular móvil.

## 3. Pantallas Detalladas

### 3.1 Splash Screen (`/splash`)
**Funcionalidad:** Pantalla de carga inicial. Verifica estado de login y asistencia, redirige a login, attendance o home.  
**Diseño:**
- Fondo: Imagen completa `assets/bg_splash.png` (fit: cover).
- Centro: `CircularProgressIndicator` (color por defecto).
- Duración: 2 segundos.
- Colores: Sin colores específicos, usa Material default.

### 3.2 Login Screen (`/login`)
**Funcionalidad:** Autenticación básica (sin validación real). Guarda estado en SharedPreferences.  
**Diseño:**
- Fondo: Imagen `assets/bg_login.png` (fit: cover).
- Título: "Control de Asistencia" (fontSize: 26, weight: bold, color: #3E2723).
- Subtítulo: "Ingresa para continuar" (color: black54).
- Decorativo: Línea marrón con círculo central.
- Campos:
  - Email: Ícono `Icons.email_outlined`, placeholder "Ingresa tu correo electronico".
  - Password: Ícono `Icons.lock_outline`, toggle visibilidad, placeholder implícito.
- Checkbox: "Recordarme" (inicial: true).
- Enlace: "Olvidaste tu contrasena?" (color: orange.shade700).
- Botón: Gradiente marrón (#6D4C41 a #3E2723), texto blanco, altura 55, borderRadius 30.
- Layout: SingleChildScrollView, padding horizontal 24, SafeArea.

### 3.3 Home Screen (`/home`)
**Funcionalidad:** Dashboard principal. Muestra estado laboral, métricas diarias, balance, banner motivacional. FAB para attendance.  
**Diseño:**
- AppScaffold: Título "Hola, Ana", subtítulo fecha, ícono notificaciones (con badge si hay), menú a admin.
- Fondo: Gradiente AppColors.bg a blanco.
- Lista vertical con padding (20,8,20,110).
- Secciones:
  - **_WorkingSessionCard:** Tarjeta blanca con sombra, padding 16, borderRadius 14.
    - Ícono trabajo (verde, fondo verde 12% opacidad, borderRadius 16).
    - Badge "En jornada" (verde, fondo verde 14%, borderRadius 12).
    - Texto "Estás trabajando" (size 20, bold), entrada "09:00 AM" (muted).
    - Tiempo trabajado "03:41:32" (size 28, bold), salida estimada "06:00 PM" (size 22, bold), faltan "02:18:28" (muted).
    - Divider color #EDE0D9.
  - **_DaySummarySection:** Título "Resumen del día" (bold, size 17).
    - Row de 3 _LargeStatCard (expandido, padding 14, blanco, borderRadius 14, sombra).
      - Horas requeridas: Ícono schedule, "8h 00m".
      - Horas trabajadas: Ícono work_outline, "03h 41m", color verde.
      - Balance del día: Ícono trending_up, "+04h 19m", color verde.
  - **_BalanceGeneralSection:** Similar a DaySummary, pero métricas generales (horas a favor, en contra, total).
  - **_MotivationBanner:** No leído, pero probablemente banner con mensaje motivacional.
- Navegación inferior: 4 ítems (Inicio, Historial, Resumen, Perfil), FAB centrado.

### 3.4 Attendance Screen (`/attendance`)
**Funcionalidad:** Marcar entrada/salida con timestamp. Actualiza estado local. Muestra reloj en tiempo real.  
**Diseño:**
- Fondo: #FFFFAF7.
- Header: Back arrow, título "Registro de Asistencia" (size 22, bold, darkBrown), botón "Historial" (outlined, border #EECDBF, borderRadius 28).
- Main Card: Padding 18, lista vertical.
  - Tiempo: Formato 12h con AM/PM, segundos.
  - Fecha: Día semana, día mes año en español.
  - Botón: Dinámico (Marcar Entrada/Salida/Finalizada), ícono (login/logout/check), gradiente verde, altura 60, borderRadius 30.
- Bottom Nav: Similar a home, pero sin FAB.
- SnackBar: Verde para mensajes de registro.

### 3.5 History Screen (`/history`)
**Funcionalidad:** Lista de registros diarios con entrada/salida/total/status. Filtros por período.  
**Diseño:**
- Fondo: #FFFFAF7.
- Header: Título "Historial" (size 27, bold), subtítulo.
- ShellCard: Blanco, borderRadius 16, sombra.
  - Tabs: Probablemente "Diario", "Semanal".
  - Period Selector: Dropdown o selector.
  - Records: Lista de _RecordCard (blanco, padding, ícono status, colores verde/rojo/ámbar).
    - Campos: Día, fecha, entrada, salida, total, status con ícono.
  - No Record: Para días sin registro.
  - Period Summary: Totales del período.
  - Correction Card: Opción para corregir registros.
- Bottom Nav: DesignBottomNav, active 1.

### 3.6 Summary Screen (`/summary`)
**Funcionalidad:** Resúmenes generales, gráficos, insights.  
**Diseño:**
- Fondo: #FFFFAF7.
- Header: Título "Resumen" (size 27, bold), subtítulo, ícono calendario (blanco, sombra).
- Period Tabs: Container blanco, border #EEDFD8, tabs para períodos.
- Cards: Balance, Chart, Totals, Week Resume, Insight, History Link (todas blancas, borderRadius, sombras).
- Bottom Nav: DesignBottomNav, active 2.

### 3.7 Profile Screen (`/profile`)
**Funcionalidad:** Ver info laboral, configuración, soporte, logout.  
**Diseño:**
- Fondo: #FFFFAF7.
- Header: Título "Perfil" (size 36, bold), ícono settings.
- Profile Header: Card blanco, border #EEDFD8, avatar círculo (#E8D0C0), nombre "Ana Rodriguez", rol.
- Secciones: "INFORMACION LABORAL", "CONFIGURACION", "SOPORTE" (títulos bold).
  - Info Cards: Lista de _InfoRow (ícono, label, value, switch si aplica).
- Logout Button: Rojo, texto blanco.
- Bottom Nav: DesignBottomNav, active 3.

### 3.8 Admin Screen (`/admin`)
**Funcionalidad:** Dashboard admin: métricas, alertas, lista empleados con status.  
**Diseño:**
- Fondo: #FFFFAF7.
- Header: Menú, título "Panel de control", fecha, notificaciones con badge 3.
- Metric Grid: Row de 2 _Metric (presentes: verde, tardanzas: ámbar).
- Alert Card: Probablemente warning.
- Filter Chips: Chips para filtros.
- Section Header: "Estado del Equipo".
- Person Cards: Lista con avatar, nombre, rol, status (verde/tarde/rojo), hora.
- Quick Actions: Botones para acciones rápidas.
- Bottom Nav: AdminBottomNav, active 0.

### 3.9 Users Screen (`/users`)
**Funcionalidad:** Gestionar usuarios: ver, buscar, agregar.  
**Diseño:**
- Header: Menú, título "Usuarios", add button marrón.
- Search: Campo con ícono search, placeholder "Buscar usuario...".
- Filters: Chips.
- Tabs: Activos/Inactivos.
- User Cards: Avatar, nombre, email, rol, status.
- Team Control: Card para controles de equipo.
- Bottom Nav: AdminBottomNav, usersMode true.

### 3.10 Reports Screen (`/reports`)
**Funcionalidad:** Generar reportes de asistencia. (No leído en detalle, pero similar a summary con export).

### 3.11 Corrections Screen (`/corrections`)
**Funcionalidad:** Corregir registros erróneos.

### 3.12 Schedules Screen (`/schedules`)
**Funcionalidad:** Gestionar horarios laborales.

## 4. Colores y Tema
- **AppColors:** brown (#5D4037), darkBrown (#3E2723), muted (#8D6E63), green (#2E7D32), red (#C62828), amber (#F9A825), soft (#F3E6DD), bg (#F4E7DE).
- Tema: Material Design, gradientes suaves, sombras para profundidad.

## 5. Funcionalidades Técnicas
- **Persistencia:** SharedPreferences para login y asistencia.
- **Navegación:** pushNamed, pushReplacementNamed.
- **Temporizadores:** Timer para reloj en attendance.
- **Mensajes:** SnackBar para feedback.
- **Layout:** Responsive limitado, SafeArea, ListView para scroll.

## 6. Limitaciones y Mejoras
- Sin backend: Datos no persisten entre instalaciones.
- Sin validación real de login.
- Sin geolocalización o biometría.
- Mejoras: Agregar Firebase, SQLite, notificaciones push, tests.

Para convertir este Markdown a PDF, usa herramientas como Pandoc o un conversor online.