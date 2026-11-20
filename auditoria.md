# Auditoría del proyecto — Sistema de Taller Mecánico

> Documento técnico previo a la elaboración del manual académico. Basado de forma fidedigna y exhaustiva en el código fuente del proyecto `taller-mecanico`.

---

## A. Tecnologías detectadas

| Tecnología / Gema | Versión declarada / detectada | Propósito y Uso en el Proyecto |
|---|---|---|
| **Ruby** | `4.0.6` | Lenguaje de programación base definido en `.ruby-version`. |
| **Ruby on Rails** | `~> 8.1.3`, `>= 8.1.3.1` | Framework MVC full-stack moderno. |
| **PostgreSQL** | `~> 1.5` (gem `pg`) | Motor de base de datos relacional (desarrollo, pruebas y producción). Configurado en `config/database.yml` con adaptador `postgresql`. |
| **Puma** | `>= 5.0` | Servidor HTTP / Web application server para concurrencia multi-hilo. |
| **Propshaft** | default Rails 8 | Pipeline moderno de gestión de assets ligeros (sucesor de Sprockets). |
| **Tailwind CSS** | `>= 4.6` (gem `tailwindcss-rails`) | Framework de utilidades CSS integrado mediante motor nativo/standalone. |
| **Pagy** | `~> 43.0` | Sistema ultrarrápido y ligero de paginación para colecciones de Active Record (`config/initializers/pagy.rb` fija límite en 5). |
| **Import Maps** | gem `importmap-rails` | Gestión de módulos ES JavaScript sin empaquetadores pesados de Node.js (Webpack/Vite). |
| **Hotwire Turbo** | gem `turbo-rails` | Acelerador de navegación SPA-like, formularios y reemplazo de fragmentos HTML (Turbo Drive/Frames). |
| **Hotwire Stimulus** | gem `stimulus-rails` | Microframework de JavaScript pragmático para interacciones UI (utilizado en el controlador `sidebar_controller.js`). |
| **Jbuilder** | gem `jbuilder` | Generación estructurada de respuestas JSON. |
| **Solid Cache** | gem `solid_cache` | Adaptador de caché persistido directamente en base de datos relacional. |
| **Solid Queue** | gem `solid_queue` | Cola de trabajos en segundo plano (Active Job) respaldada en base de datos. |
| **Solid Cable** | gem `solid_cable` | Manejo de WebSockets (Action Cable) persistido en base de datos sin depender de Redis. |
| **Bootsnap** | gem `bootsnap` | Optimización del tiempo de arranque de la aplicación cacheando rutas y compilaciones. |
| **Kamal** | gem `kamal` | Herramienta de despliegue mediante contenedores Docker. |
| **tzinfo-data** | gem `tzinfo-data` | Base de datos de zonas horarias para compatibilidad en sistemas Windows. |

**Módulo principal de la aplicación**: `TallerMecanico` (`config/application.rb`).  
**Defaults de configuración**: `config.load_defaults 8.1`.

---

## B. Arquitectura y Decisiones de Diseño

El sistema está construido como un **monolito web server-rendered moderno con Rails 8**, optimizado para alta productividad y bajo costo operacional:

1. **Frontend / Presentación**:
   - Renderizado en servidor con plantillas **ERB**.
   - Maquetación y diseño responsivo estructurado con **Tailwind CSS v4**.
   - Interactividad dinámica mediante **Hotwire**:
     - **Turbo Drive** para acelerar cambios de página y peticiones REST.
     - **Stimulus JS** para comportamiento reactivo del lado del cliente (ej. colapso y apertura del sidebar lateral mediante `sidebar_controller.js`).
     - **Pagy Helpers** para navegación paginada limpia y eficiente.

2. **Capa de Control y Rutas**:
   - Mapeo híbrido: recursos estándar para vehículos (`resources :cars, except: :show`) y endpoints hispanizados manuales para clientes (`/clientes`, `/clientes/new`, etc.).
   - Uso de las convenciones más recientes de Rails 8 como `params.expect(...)` en controladores para sustituir el patrón clásico `params.require(...).permit(...)`.

3. **Capa de Negocio y Persistencia**:
   - **Active Record** como ORM sobre **PostgreSQL**.
   - Dominio modelado en inglés técnico (`Customer`, `Car`) con vistas y etiquetas de navegación localizadas al español para el usuario final.
   - Relación 1 a N: Un cliente (`Customer`) posee múltiples vehículos (`Car`), con borrado en cascada (`dependent: :destroy`).

4. **Flujo de una petición típica (`GET /clientes`)**:
   ```
   Navegador (Usuario)
          │  HTTP GET /clientes (o con filtro ?q=...)
          ▼
   Rails Router (config/routes.rb)
          │  Mapea a CustomersController#index
          ▼
   CustomersController
          │  Evalúa si existe params[:q]:
          │   ├─ Sí: Customer.where("lower(first_name) LIKE :q ...")
          │   └─ No: pagy(:offset, Customer.ordered.order(:id))
          ▼
   Active Record → PostgreSQL
          │  Genera: SELECT * FROM customers ORDER BY LOWER(last_name), LOWER(first_name), id LIMIT 5
          ▼
   Vista (app/views/customers/index.html.erb)
          │  Renderiza tabla con clases Tailwind + componente pagy
          ▼
   Layout Principal (app/views/layouts/application.html.erb)
          │  Integra Sidebar Stimulus + navegación
          ▼
   Respuesta HTML enviada al Navegador
   ```

---

## C. Estructura de Directorios del Proyecto

```
taller-mecanico/
├── app/
│   ├── assets/
│   │   ├── build/
│   │   └── stylesheets/application.tailwind.css
│   ├── controllers/
│   │   ├── concerns/
│   │   ├── application_controller.rb
│   │   ├── cars_controller.rb            # CRUD de vehículos
│   │   ├── customers_controller.rb       # CRUD de clientes con búsqueda y paginación
│   │   └── home_controller.rb            # Dashboard / métricas rápidas
│   ├── helpers/
│   │   └── application_helper.rb         # Helper sidebar_link_classes
│   ├── javascript/
│   │   ├── controllers/
│   │   │   ├── application.js
│   │   │   ├── index.js
│   │   │   └── sidebar_controller.js     # Manejo del menú colapsable responsive
│   │   └── application.js
│   ├── models/
│   │   ├── concerns/
│   │   ├── application_record.rb
│   │   ├── car.rb                        # Modelo Vehículo (belongs_to :customer)
│   │   └── customer.rb                   # Modelo Cliente (has_many :cars, scope :ordered)
│   └── views/
│       ├── cars/
│       │   ├── _form.html.erb            # Formulario compartido con Tailwind
│       │   ├── edit.html.erb
│       │   ├── index.html.erb            # Listado con badges de color y acciones
│       │   └── new.html.erb
│       ├── customers/
│       │   ├── _cars.html.erb            # Sub-tabla de autos del cliente
│       │   ├── _form.html.erb            # Formulario cliente
│       │   ├── edit.html.erb
│       │   ├── index.html.erb            # Buscador en vivo + Pagy + Tabla
│       │   └── new.html.erb
│       ├── home/
│       │   └── index.html.erb            # Dashboard principal con conteos (KPIs)
│       ├── layouts/
│       │   └── application.html.erb      # Layout con navegación lateral Tailwind/Stimulus
│       └── shared/
│           └── _page_header.html.erb     # Parcial reutilizable de encabezados de página
├── config/
│   ├── initializers/
│   │   └── pagy.rb                       # Configuración de límite de items
│   ├── database.yml                      # Conexión a PostgreSQL
│   └── routes.rb                         # Mapeo de URLs
├── db/
│   ├── migrate/                          # Historial de 7 migraciones aplicadas
│   └── schema.rb                         # Schema actual de base de datos
├── test/                                 # Entorno Minitest
├── Gemfile                               # Especificación de gemas
├── Procfile.dev                          # Orquestador local (Rails + Tailwind watcher)
└── tailwind.config.js                    # Configuración de utilidades CSS
```

---

## D. Análisis de Base de Datos y Modelos

### 1. Tablas y Esquema Físico (PostgreSQL)

#### Tabla: `customers`
Representa los propietarios de vehículos y clientes del taller.
- `id` (`bigint`, PK, autoincremental)
- `first_name` (`string`): Nombre de pila del cliente.
- `last_name` (`string`): Apellido(s) del cliente.
- `phone` (`string`): Número de contacto.
- `active` (`boolean`, default: `true`): Estado de activación del cliente.
- `created_at` / `updated_at` (`datetime`, not null).

#### Tabla: `cars`
Representa los autos registrados para reparaciones o mantenimientos.
- `id` (`bigint`, PK, autoincremental)
- `customer_id` (`bigint`, FK not null, indexado hacia `customers.id`).
- `brand` (`string`): Marca (Toyota, Ford, Chevrolet, etc.).
- `model` (`string`): Modelo del automóvil (Corolla, Ranger, etc.).
- `year` (`integer`): Año de fabricación.
- `plate` (`string`): Matrícula o patente identificadora.
- `color` (`string`): Color exterior del vehículo.
- `created_at` / `updated_at` (`datetime`, not null).

#### Restricciones de Integridad Referencial
- Clave foránea definida en PostgreSQL: `add_foreign_key "cars", "customers"`.

### 2. Historial de Migraciones Aplicadas
1. `20260831213914_create_customers.rb`: Creación inicial de `customers`.
2. `20260831215025_create_carts.rb`: Creación de tabla temporal `carts` (posible error tipográfico inicial por "cars").
3. `20260831215430_add_firt_name_last_name_to_customers.rb`: Corrección de campos de nombres.
4. `20260831222837_add_phone_number_to_customers.rb`: Inclusión del teléfono.
5. `20261012213129_create_cars.rb`: Creación formal de la entidad `cars`.
6. `20261019133000_add_customer_to_cars.rb`: Asociación de `customer_id` con clave foránea e índice.
7. `20261019140000_drop_carts.rb`: Limpieza y eliminación de la tabla redundante `carts`.

### 3. Modelos y Lógica de Dominio

#### Modelo `Customer` (`app/models/customer.rb`):
- **Asociación**: `has_many :cars, dependent: :destroy` (si se da de baja al cliente, se eliminan sus autos asociados para proteger la integridad referencial).
- **Scopes**:
  - `ordered`: Ordenamiento insensible a mayúsculas/minúsculas por apellido y nombre:
    ```ruby
    scope :ordered, -> { order(Arel.sql("LOWER(last_name)"), Arel.sql("LOWER(first_name)")) }
    ```
- **Métodos auxiliares**:
  - `full_name`: Concatena `first_name` y `last_name` eliminando espacios en blanco innecesarios (`[first_name, last_name].compact_blank.join(" ")`).

#### Modelo `Car` (`app/models/car.rb`):
- **Asociación**: `belongs_to :customer`.

---

## E. Mapeo de Rutas y Controladores

| Verbo HTTP | Ruta (URL) | Controlador#Acción | Helper de Ruta | Propósito |
|---|---|---|---|---|
| `GET` | `/` | `home#index` | `root_path` | Dashboard con estadísticas clave |
| `GET` | `/clientes` | `customers#index` | `clientes_path` | Lista de clientes, buscador dinámico y paginación Pagy |
| `GET` | `/clientes/new` | `customers#new` | `new_cliente_path` | Formulario de nuevo cliente |
| `POST` | `/clientes` | `customers#create` | `clientes_path` | Persistencia de nuevo cliente |
| `GET` | `/clientes/:id/edit` | `customers#edit` | `edit_cliente_path(:id)` | Edición de cliente y visualización de sus autos |
| `PATCH/PUT`| `/clientes/:id` | `customers#update` | `cliente_path(:id)` | Actualización de cliente |
| `DELETE` | `/clientes/:id` | `customers#destroy` | `cliente_path(:id)` | Eliminación de cliente (en cascada) |
| `GET` | `/cars` | `cars#index` | `cars_path` | Listado general de autos |
| `GET` | `/cars/new` | `cars#new` | `new_car_path` | Formulario de alta de auto |
| `POST` | `/cars` | `cars#create` | `cars_path` | Persistencia de auto |
| `GET` | `/cars/:id/edit` | `cars#edit` | `edit_car_path(:id)` | Edición de datos del auto |
| `PATCH/PUT`| `/cars/:id` | `cars#update` | `car_path(:id)` | Actualización de auto |
| `DELETE` | `/cars/:id` | `cars#destroy` | `car_path(:id)` | Eliminación de auto |
| `GET` | `/up` | `rails/health#show` | `rails_health_check_path` | Health check probe para despliegues |

---

## F. Interfaz de Usuario y Experiencia (UI/UX)

1. **Diseño Visual**:
   - Paleta sobria basada en azul marino (`bg-blue-900`) para la navegación y acentos en `sky` / `teal` para acciones y métricas.
   - Tipografía sans-serif limpia con estados interactivos hover/focus nativos de Tailwind.
2. **Componente de Navegación Lateral (Sidebar)**:
   - Implementado en `app/views/layouts/application.html.erb` y gobernado por Stimulus JS (`app/javascript/controllers/sidebar_controller.js`).
   - Soporta colapso/despliegue en pantallas pequeñas y preserva el estado visual del enlace activo gracias al helper `sidebar_link_classes` en `ApplicationHelper`.
3. **Búsqueda Dinámica**:
   - El listado de clientes permite filtrar al vuelo mediante el parámetro `params[:q]`, cotejando en minúsculas sobre nombre, apellido o teléfono.
4. **Edición contextualizada**:
   - En la vista de edición del cliente (`customers/edit.html.erb`), se embebe el parcial `_cars.html.erb`, permitiendo ver los vehículos que pertenecen a dicho cliente y agregar nuevos directamente vinculados.

---

## G. Diagnóstico: Fortalezas, Deuda Técnica y Recomendaciones

### Aspectos Fuertes Implementados
1. **Pila Tecnológica Moderna**: Adopción de Rails 8.1 puro con Propshaft, Tailwind CSS y PostgreSQL, una configuración apta para producción empresarial.
2. **Paginación Eficiente**: Incorporación de `pagy`, reduciendo sustancialmente el consumo de memoria respecto a gemas tradicionales como Kaminari.
3. **Manejo Seguro de Parámetros**: `CarsController` utiliza la directiva moderna `params.expect(...)` introducida en versiones recientes de Rails.

### Observaciones y Deuda Técnica Detectada
1. **Validaciones en Modelos**:
   - Ni `Customer` ni `Car` cuentan con validaciones a nivel de modelo (`validates :first_name, presence: true`, presencia de `plate`, unicidad de matrícula, rango válido de `year`, etc.).
   - En `CustomersController#create` y `#update`, no se evalúa el resultado de `save` / `update` con bloque condicional `if/else`, por lo que errores de validación no se mostrarían al usuario si se añaden.
2. **Divergencia de Nomenclatura en Rutas**:
   - Mientras los vehículos usan la convención plural inglesa de Rails (`resources :cars`), los clientes están cableados manualmente en español (`/clientes`). Sería recomendable estandarizar o documentar explícitamente el uso de `path: "clientes"` en el enrutador.
3. **Funcionalidades pendientes del taller**:
   - En el Dashboard y menú se observan referencias a módulos planificados pero aún no modelados: Órdenes de Trabajo (`OrdenTrabajo`), Mecánicos, Repuestos/Inventario y Facturación (similares a los existentes en el proyecto de referencia).
4. **Autenticación y Control de Accesos**:
   - A diferencia del proyecto de referencia, actualmente no hay módulo de usuarios ni login activo (`has_secure_password` se encuentra comentado en el Gemfile).

---

## H. Conclusión de la Auditoría

El proyecto presenta una base sólida, limpia y moderna construida bajo estándares actuales de Ruby on Rails 8, PostgreSQL y Tailwind CSS. El modelo de datos es modular y la UI cuenta con excelente ergonomía. 

Esta auditoría sirve como insumo directo para estructurar el **Material de Estudio / Manual Académico** (Fase 2), donde se explicará paso a paso cómo se construyó este sistema, qué conceptos de programación web ilustra y cómo extenderlo profesionalmente.
