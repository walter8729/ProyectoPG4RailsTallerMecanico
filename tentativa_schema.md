# SISTEMA-TALLER-MECANICO

> **Nota sobre moneda:** Todos los montos (`Precio`, `PrecioUnitario`, `Subtotal`, `Total`) se almacenan como enteros (`INT`) en Guaraníes (PYG), sin decimales.

## 1. Entidades y Atributos

### 1. Cliente
| Atributo | Tipo | Restricción | Descripción |
| :--- | :--- | :--- | :--- |
| `ClienteID` | `INT` | `PK` | Identificador único del cliente. |
| `TipoDocumento` | `VARCHAR(20)` | `NOT NULL` | Tipo de documento (`CI`, `RUC`, `Extranjero`). |
| `Documento` | `VARCHAR(30)` | `UNIQUE, NOT NULL` | Número de Cédula, RUC o documento extranjero. |
| `Nombre` | `VARCHAR(100)` | `NOT NULL` | Nombre del cliente. |
| `Apellido` | `VARCHAR(100)` | `NOT NULL` | Apellido del cliente. |
| `Telefono` | `VARCHAR(20)` | `NOT NULL` | Número de teléfono de contacto. |
| `Email` | `VARCHAR(100)` | `NULL` | Dirección de correo electrónico. |
| `Direccion` | `VARCHAR(200)` | `NULL` | Dirección física del cliente. |

### 2. Auto
| Atributo | Tipo | Restricción | Descripción |
| :--- | :--- | :--- | :--- |
| `AutoID` | `INT` | `PK` | Identificador único del vehículo. |
| `ClienteID` | `INT` | `FK, NOT NULL` | Relación con el cliente propietario (`Cliente`). |
| `Marca` | `VARCHAR(50)` | `NOT NULL` | Marca del vehículo. |
| `Modelo` | `VARCHAR(50)` | `NOT NULL` | Modelo del vehículo. |
| `Anio` | `INT` | `NOT NULL` | Año de fabricación. |
| `Placa` | `VARCHAR(15)` | `UNIQUE, NOT NULL` | Número de chapa/placa del vehículo. |
| `Chasis` | `VARCHAR(30)` | `UNIQUE, NOT NULL` | VIN / Nro. de Chasis o Bastidor. |
| `Color` | `VARCHAR(30)` | `NULL` | Color del vehículo. |
| `Kilometraje` | `INT` | `NOT NULL` | Kilometraje actual registrado del vehículo. |

### 3. Servicio
| Atributo | Tipo | Restricción | Descripción |
| :--- | :--- | :--- | :--- |
| `ServicioID` | `INT` | `PK` | Identificador único del servicio. |
| `NombreServicio` | `VARCHAR(100)` | `NOT NULL` | Nombre del servicio (ej. "Cambio de Aceite"). |
| `Descripcion` | `VARCHAR(255)` | `NULL` | Descripción del servicio. |
| `Precio` | `INT` | `NOT NULL` | Precio base del servicio en Guaraníes (sin decimales). |

### 4. Mecanico
| Atributo | Tipo | Restricción | Descripción |
| :--- | :--- | :--- | :--- |
| `MecanicoID` | `INT` | `PK` | Identificador único del mecánico. |
| `Nombre` | `VARCHAR(100)` | `NOT NULL` | Nombre del mecánico. |
| `Apellido` | `VARCHAR(100)` | `NOT NULL` | Apellido del mecánico. |
| `Especialidad` | `VARCHAR(100)` | `NOT NULL` | Especialidad (mecánica general, electricidad, etc.). |
| `Telefono` | `VARCHAR(20)` | `NOT NULL` | Número de contacto. |

### 5. Orden
| Atributo | Tipo | Restricción | Descripción |
| :--- | :--- | :--- | :--- |
| `OrdenID` | `INT` | `PK` | Identificador único de la orden de trabajo. |
| `AutoID` | `INT` | `FK, NOT NULL` | Relación con el vehículo (`Auto`). |
| `FechaOrden` | `DATE` | `NOT NULL` | Fecha de ingreso/creación de la orden. |
| `FechaEntrega` | `DATE` | `NULL` | Fecha de finalización o entrega del vehículo. |
| `Estado` | `VARCHAR(20)` | `NOT NULL` | Estado (`Pendiente`, `En Proceso`, `Completada`). |
| `Observaciones` | `VARCHAR(255)` | `NULL` | Falla reportada por el cliente o diagnóstico inicial. |
| `Total` | `INT` | `NOT NULL` | Total calculado de la orden en Guaraníes (sin decimales). |

### 6. DetalleOrden
| Atributo | Tipo | Restricción | Descripción |
| :--- | :--- | :--- | :--- |
| `DetalleID` | `INT` | `PK` | Identificador único del detalle. |
| `OrdenID` | `INT` | `FK, NOT NULL` | Relación con la orden de trabajo (`Orden`). |
| `ServicioID` | `INT` | `FK, NOT NULL` | Relación con el servicio solicitado (`Servicio`). |
| `Cantidad` | `INT` | `NOT NULL` | Cantidad del servicio aplicado. |
| `PrecioUnitario` | `INT` | `NOT NULL` | Precio unitario en Guaraníes al momento de la orden. |
| `Subtotal` | `INT` | `NOT NULL` | Subtotal calculado (`Cantidad * PrecioUnitario`) en Guaraníes. |

### 7. Asignacion
| Atributo | Tipo | Restricción | Descripción |
| :--- | :--- | :--- | :--- |
| `AsignacionID` | `INT` | `PK` | Identificador único de la asignación. |
| `OrdenID` | `INT` | `FK, NOT NULL` | Relación con la orden de trabajo (`Orden`). |
| `MecanicoID` | `INT` | `FK, NOT NULL` | Relación con el mecánico asignado (`Mecanico`). |
| `FechaAsignacion` | `DATE` | `NOT NULL` | Fecha en que se asignó el trabajo al mecánico. |

---

## 2. Relaciones Entre Entidades

1. **Cliente y Auto (1:N):** Un cliente puede tener varios autos, pero un auto pertenece a un solo cliente.
2. **Auto y Orden (1:N):** Un auto puede tener varias órdenes de trabajo a lo largo del tiempo.
3. **Orden y DetalleOrden (1:N):** Una orden puede incluir múltiples detalles de servicios.
4. **Servicio y DetalleOrden (1:N):** Un mismo servicio puede aparecer en múltiples detalles de distintas órdenes.
5. **Orden y Asignacion (1:N):** Una orden puede tener uno o varios mecánicos asignados.
6. **Mecanico y Asignacion (1:N):** Un mecánico puede ser asignado a múltiples órdenes de trabajo.

---

## 3. Diagrama de Relaciones

```text
Cliente (ClienteID [PK], TipoDocumento, Documento [UQ], Nombre, Apellido, Telefono, Email, Direccion)
  | 1:N
  v
Auto (AutoID [PK], ClienteID [FK], Marca, Modelo, Anio, Placa [UQ], Chasis [UQ], Color, Kilometraje)
  | 1:N
  v
Orden (OrdenID [PK], AutoID [FK], FechaOrden, FechaEntrega, Estado, Observaciones, Total)
  | 1:N                                                      | 1:N
  v                                                          v
DetalleOrden (DetalleID [PK], OrdenID [FK],                  Asignacion (AsignacionID [PK], OrdenID [FK],
              ServicioID [FK], Cantidad,                                 MecanicoID [FK], FechaAsignacion)
              PrecioUnitario, Subtotal)                        ^
  ^                                                            | N:1
  | N:1                                                        |
Servicio (ServicioID [PK], NombreServicio,                   Mecanico (MecanicoID [PK], Nombre, Apellido,
          Descripcion, Precio)                                         Especialidad, Telefono)