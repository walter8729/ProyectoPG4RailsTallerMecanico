# Plan de Implementación del Sistema de Taller Mecánico

> **Basado en:** `tentativa_schema.md`  
> **Moneda:** Todos los montos (`Precio`, `PrecioUnitario`, `Subtotal`, `Total`) se manejan como enteros (`INT`) en Guaraníes (PYG), sin decimales.  
> **Requisitos transversales:**  
> 1. Validaciones robustas en backend (modelos Rails) y frontend (HTML5 / atributos / feedback visual).  
> 2. Buscador en cada sección con persistencia de query y paginación con Pagy estilizada.  
> 3. Registro detallado de todas las operaciones en `bitacora.log`.

---

## 1. Arquitectura y Modelo de Datos

```
Cliente (1) ----< (N) Auto (1) ----< (N) Orden (1) ----< (N) DetalleOrden (N) >---- (1) Servicio
                                           |
                                           +---< (N) Asignacion (N) >---- (1) Mecanico
```

---

## 2. Fases de Ejecución Paso a Paso

### Fase 1: Base de Datos y Modelos (Migraciones y Validaciones)
- [x] **Paso 1.1: Actualizar `customers`**
  - Campos a agregar: `document_type` (CI, RUC, Extranjero), `document_number` (único, no nulo), `email`, `address`.
  - Validaciones en `Customer`: presencia de `first_name`, `last_name`, `document_type`, `document_number`, `phone`. Unicidad de `document_number`. Formato de `email` opcional.
- [x] **Paso 1.2: Actualizar `cars`**
  - Campos a agregar: `chassis` (VIN único, no nulo), `mileage` (entero >= 0, no nulo).
  - Validaciones en `Car`: presencia de `brand`, `model`, `year`, `plate`, `chassis`, `mileage`, `customer_id`. Unicidad de `plate` y `chassis`. `mileage` >= 0, `year` válido.
- [x] **Paso 1.3: Crear Modelos y Migraciones Nuevas**
  - `Service`: `name` (string), `description` (text/string), `price` (integer >= 0).
  - `Mechanic`: `first_name` (string), `last_name` (string), `specialty` (string), `phone` (string).
  - `Order`: `car_id` (FK), `order_date` (date), `delivery_date` (date, nullable), `status` (string: Pendiente, En Proceso, Completada), `notes` (text/string), `total` (integer >= 0, default 0).
  - `OrderDetail`: `order_id` (FK), `service_id` (FK), `quantity` (integer >= 1), `unit_price` (integer >= 0), `subtotal` (integer >= 0).
  - `Assignment`: `order_id` (FK), `mechanic_id` (FK), `assigned_at` (date).
- [x] **Paso 1.4: Lógica de Negocio y Callbacks de Cálculo**
  - En `OrderDetail`: cálculo automático de `subtotal = quantity * unit_price`.
  - En `Order`: recálculo automático de `total` al guardar/modificar items (`order_details`).
  - Configuración de `accepts_nested_attributes_for` en `Order` para agregar servicios y mecánicos de manera integrada.

---

### Fase 2: Catálogo de Servicios y Mecánicos (CRUD + Búsqueda + Pagy + Validaciones)
- [ ] **Paso 2.1: Módulo de Servicios (`services`)**
  - Controlador `ServicesController` con acciones completas.
  - Buscador por `name` o `description`.
  - Paginación Pagy con límite y navegación fluida.
  - Vistas con validaciones HTML5 (campos requeridos, precio numérico entero min=0).
  - Agregar enlace al sidebar.
- [ ] **Paso 2.2: Módulo de Mecánicos (`mechanics`)**
  - Controlador `MechanicsController` con acciones completas.
  - Buscador por `first_name`, `last_name`, `specialty` o `phone`.
  - Paginación Pagy.
  - Vistas con validación frontend.
  - Agregar enlace al sidebar.

---

### Fase 3: Refactorización y Completitud de Clientes y Autos
- [ ] **Paso 3.1: Módulo de Clientes (`customers`)**
  - Actualizar formulario (`_form.html.erb`) con `document_type`, `document_number`, `email`, `address`.
  - Validaciones frontend en inputs (select para tipo de documento, required, pattern/type email).
  - Ampliar buscador para filtrar por nombre, apellido, documento o teléfono.
- [ ] **Paso 3.2: Módulo de Autos (`cars`)**
  - Agregar paginación Pagy en `CarsController#index`.
  - Agregar barra de búsqueda por placa, chasis, marca, modelo o nombre del cliente.
  - Actualizar formulario con `chassis` y `mileage`.

---

### Fase 4: Módulo Central de Órdenes de Trabajo (`orders`)
- [ ] **Paso 4.1: Listado de Órdenes (`orders#index`)**
  - Filtros: por texto (placa, chasis, cliente) y por estado (`Pendiente`, `En Proceso`, `Completada`).
  - Paginación Pagy y Badges visuales según estado.
- [ ] **Paso 4.2: Formulario de Creación/Edición de Órdenes**
  - Selección de Auto y Cliente.
  - Fecha de orden y estimada de entrega.
  - Selección múltiple / anidada de Servicios con cantidad y precio sugerido.
  - Asignación de mecánico(s) responsable(s).
  - Validaciones front y back (fechas coherentes, al menos un auto seleccionado).
- [ ] **Paso 4.3: Vista de Detalle de Orden (`orders#show`)**
  - Ficha imprimible/limpia con datos del cliente, auto, mecánicos asignados, desglose de ítems y total en Guaraníes.
  - Botones de acción rápida: cambiar estado (`En Proceso`, `Completada`).

---

### Fase 5: Dashboard y Métricas de Inicio (`home#index`)
- [ ] **Paso 5.1: Métricas en Vivo**
  - Contador de órdenes activas (Pendientes / En Proceso).
  - Total facturado en el mes (en Guaraníes).
  - Cantidad de autos y clientes registrados.
- [ ] **Paso 5.2: Accesos rápidos**
  - Tabla de últimas órdenes ingresadas y alertas de entregas pendientes.

---

### Fase 6: Pruebas, Verificación y Limpieza Final
- [ ] Ejecución de tests (`bin/rails test`).
- [ ] Verificación de navegación y paginación en todos los módulos.
- [ ] Verificación de registro completo en `bitacora.log`.
