# 🚗 Sistema de Gestión de Taller Mecánico

Sistema web integral para la administración y control operativo de un taller mecánico automotriz, desarrollado en **Ruby on Rails 8.1** con **PostgreSQL**, siguiendo una arquitectura RESTful limpia y utilizando herramientas nativas de Rails sin librerías externas de JavaScript.

Proyecto final desarrollado para la cátedra de **Programación IV**.

---

## 🛠️ Tecnologías y Stack Técnico

- **Framework:** Ruby on Rails 8.1 (Vanilla Rails puro con Hotwire / Turbo y Stimulus nativo)
- **Lenguaje:** Ruby 4.0+
- **Base de Datos:** PostgreSQL
- **Estilos y UI:** Tailwind CSS v4 + Vanilla CSS modularizado en `application.css`
- **Paginación:** Pagy (ultraliviano y compatible con búsquedas dinámicas)
- **Pruebas:** Minitest (suite completa de tests unitarios y de integración con 32 tests y 60 assertions)
- **Localización (I18n):** Configuración en español Paraguay (`es-PY`), moneda Guaraníes (₲) con separador de miles por punto (`.`) y zona horaria Asunción (`America/Asuncion`).

---

## 📋 Módulos y Funcionalidades del Sistema

### 1. Panel de Control (Dashboard)
- Métricas en tiempo real: Clientes registrados, Vehículos ingresados, Órdenes en taller (pendientes vs. en proceso) y Total facturado de órdenes completadas.
- Acceso directo a los submódulos y listado rápido de las últimas órdenes ingresadas.

### 2. Gestión de Clientes (`/clientes`)
- Registro de clientes con soporte para documentos paraguayos e internacionales:
  - **CI (Cédula de Identidad):** Validación por expresión regular (5 a 8 dígitos) y normalización automática de puntos de miles.
  - **RUC:** Validación de formato con dígito verificador (`########-#`).
  - **Extranjero:** Pasaportes o documentos foráneos.
- Búsqueda en tiempo real multi-criterio (nombre, apellido, cédula, teléfono).
- Vista de detalle (`show`) con historial de vehículos asociados y órdenes del cliente.
- Protección de integridad referencial (`restrict_with_error`).

### 3. Registro de Vehículos (`/cars`)
- Ficha técnica completa: Marca, Modelo, Año, Placa/Chapa, Chasis (VIN), Kilometraje y Color.
- Selector interactivo (Combobox nativo) para asociar el vehículo al cliente propietario con búsqueda en vivo.
- Restricción de borrado para vehículos con órdenes de trabajo activas o históricas.

### 4. Catálogo de Servicios (`/servicios`)
- Mantenimiento preventivo y correctivo con precios en Guaraníes (₲).
- Búsqueda por nombre y descripción.

### 5. Equipo de Mecánicos (`/mecanicos`)
- Registro de profesionales del taller y su especialidad técnica (Frenos, Inyección, Electricidad, Motor, etc.).
- Vista de detalle con desglose de órdenes asignadas clasificadas por estado.

### 6. Órdenes de Trabajo (`/ordenes`)
- **Flujo operativo:** Estados *Pendiente*, *En Proceso* y *Completada*.
- Acciones rápidas de cambio de estado en un clic (`patch :update_status`).
- Asignación múltiple y flexible de mecánicos por orden de trabajo.
- Validación cronológica de negocio: la fecha de entrega debe ser igual o posterior a la fecha de ingreso (`delivery_date >= order_date`), permitiendo servicios rápidos en el día.
- **Rutas anidadas RESTful:** Gestión y desglose de servicios realizados con recálculo automático de subtotales y total general en base de datos.

---

## 🚀 Instalación y Puesta en Marcha

### Requisitos previos
- Ruby 3.3+ (o Ruby 4.0+)
- PostgreSQL 14+
- Bundler (`gem install bundler`)

### Pasos de configuración

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/walter8729/ProyectoPG4RailsTallerMecanico.git
   cd ProyectoPG4RailsTallerMecanico
   ```

2. **Instalar dependencias:**
   ```bash
   bundle install
   ```

3. **Configurar la base de datos:**
   Revisar las credenciales en `config/database.yml` y luego ejecutar:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

4. **Cargar datos de prueba (Seeds de Encarnación, Paraguay):**
   ```bash
   bin/rails db:seed
   ```
   *Carga automáticamente 38 clientes reales, 50 vehículos frecuentes, mecánicos y catálogo completo de 20 servicios con precios en moneda local.*

5. **Iniciar el servidor de desarrollo:**
   ```bash
   bin/rails server
   ```
   Abrir en el navegador: [http://localhost:3000](http://localhost:3000)

---

## 🧪 Ejecución de Pruebas Unitarias

Para correr la suite de tests automatizados (modelos, controladores, restricciones e integridad referencial):

```bash
bin/rails test
```

Resultado esperado:
```text
32 runs, 60 assertions, 0 failures, 0 errors, 0 skips
```

---

## 🏛️ Arquitectura y Principios de Diseño

- **100% Rails Nativo:** Sin librerías pesadas externas de JavaScript; utiliza Turbo Drive, Stimulus y HTML5 puro para interactividad y validaciones.
- **Strong Parameters de Rails 8:** Sanitización segura de parámetros mediante `params.expect`.
- **Leyes de UI/UX aplicadas:**
  - *Ley de Jakob:* Patrones de navegación estándar y consistencia en vistas show/index.
  - *Ley de Fitts:* Botones con áreas de toque amplias y separación visual de acciones destructivas (`.btn-accion-borrar`).
  - *Ley de Miller:* Agrupación de formularios en bloques lógicos reduciendo la carga cognitiva.
  - *Ley de Tesler:* Distribución balanceada en 2 columnas en órdenes y cálculo automático de totales.
