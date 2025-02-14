create database bd_uniformes
go
 
use bd_uniformes
go

create table Producto (
id int primary key not null,
Nombre varchar(250),
Precio int,
Descripcion varchar(250),
FechaEstimadaLlegada varchar(250)
)

create table Proveedores (
id int primary key not null,
Nombre_proveedor varchar(250),
Dirección varchar(250),
Email varchar(250),
Telefono varchar(250),
ProductoID int foreign key references Producto(id)
)

create table Inventario (
id int primary key not null,
Telas varchar(250),
MaquinasCosturas int, 
CantidadMateriales int, 
ProveedorID int foreign key references Proveedores(id),
ProductoID int foreign key references Producto(id)
)

create table Clientes (
id int primary key not null,
Nombre_Cliente varchar(250),
Apellido_cliente varchar(250),
RegularidadCompras int,
Contacto varchar(250)
)

create table Ventas (
id int primary key not null,
Cantidad int,
FechaVenta varchar(250),
MontoTotal int,
ClienteID int foreign key references Clientes(id),
ProductoID int foreign key references Producto(id)

)

create table Pedidos (
id int primary key not null,
Fecha_pedido varchar(250),
Monto_total int,
ProductoID int foreign key references Producto(id),
ClientesID int foreign key references Clientes(id)
)

create table Empleados (
id int primary key not null,
Nombre_empleado varchar(250),
Apellido_empleado varchar(250),
RolDeEmpleado varchar(250),
ClienteID int foreign key references Clientes(id)
)

INSERT INTO Producto (id, Nombre, Precio, Descripcion, FechaEstimadaLlegada) VALUES 
(1, 'Camisa Blanca', 20, 'Camisa de manga larga blanca', '2025-03-01'),
(2, 'Pantalón Azul', 30, 'Pantalón de tela azul', '2025-04-15'),
(3, 'Falda Negra', 25, 'Falda de uniforme negra', '2025-02-20'),
(4, 'Jersey Gris', 35, 'Jersey de lana gris', '2025-05-10'),
(5, 'Chaqueta Azul Marino', 50, 'Chaqueta de uniforme azul marino', '2025-06-05');

INSERT INTO Proveedores (id, Nombre_proveedor, Dirección, Email, Telefono, ProductoID) VALUES 
(1, 'Textiles del Norte', '123 Calle Principal, CDMX', 'contacto@textilesdelnorte.com', '555-1234', 1),
(2, 'Uniformes y Más', '456 Avenida Central, Monterrey', 'ventas@uniformesymas.com', '555-5678', 2),
(3, 'Confecciones García', '789 Boulevard Reforma, Guadalajara', 'info@confeccionesgarcia.com', '555-9101', 3),
(4, 'Ropa Corporativa', '1010 Calle Industrial, Puebla', 'servicio@ropacorporativa.com', '555-1121', 4),
(5, 'Distribuciones Patria', '1111 Avenida de la Moda, Querétaro', 'contacto@distribucionespatria.com', '555-1314', 5);

INSERT INTO Inventario (id, Telas, MaquinasCosturas, CantidadMateriales, ProveedorID, ProductoID) VALUES 
(1, 'Tela Algodón Blanca', 10, 100, 1, 1),
(2, 'Tela Poliéster Azul', 15, 200, 2, 2),
(3, 'Tela Seda Negra', 5, 150, 3, 3),
(4, 'Tela Lana Gris', 20, 50, 4, 4),
(5, 'Tela Algodón Azul Marino', 12, 300, 5, 5);

INSERT INTO Clientes (id, Nombre_Cliente, Apellido_cliente, RegularidadCompras, Contacto) VALUES 
(1, 'Carlos', 'Hernández', 3, 'carlos.hernandez@example.com'),
(2, 'María', 'García', 2, 'maria.garcia@example.com'),
(3, 'Juan', 'Pérez', 4, 'juan.perez@example.com'),
(4, 'Ana', 'López', 1, 'ana.lopez@example.com'),
(5, 'Luis', 'Martínez', 5, 'luis.martinez@example.com');

INSERT INTO Ventas (id, Cantidad, FechaVenta, MontoTotal, ClienteID, ProductoID) VALUES 
(1, 10, '2025-01-15', 200, 1, 1),
(2, 15, '2025-01-20', 450, 2, 2),
(3, 8, '2025-02-05', 200, 3, 3),
(4, 5, '2025-02-10', 175, 4, 4),
(5, 12, '2025-02-15', 600, 5, 5);

INSERT INTO Pedidos (id, Fecha_pedido, Monto_total, ProductoID, ClientesID) VALUES 
(1, '2025-01-01', 200, 1, 1),
(2, '2025-01-05', 450, 2, 2),
(3, '2025-01-10', 200, 3, 3),
(4, '2025-01-15', 175, 4, 4),
(5, '2025-01-20', 600, 5, 5);

INSERT INTO Empleados (id, Nombre_empleado, Apellido_empleado, RolDeEmpleado, ClienteID) VALUES 
(1, 'Laura', 'Sánchez', 'Vendedora', 1),
(2, 'Miguel', 'Ramírez', 'Soporte Técnico', 2),
(3, 'Andrea', 'Torres', 'Gerente', 3),
(4, 'Roberto', 'Gómez', 'Vendedor', 4),
(5, 'Lucía', 'Morales', 'Soporte Técnico', 5);

select Clientes.Nombre_Cliente, Clientes.Apellido_cliente, sum(Ventas.Cantidad) as total_Productos_Vendidos from Ventas join Clientes on Ventas.ClienteID = Clientes.id group by Clientes.Nombre_Cliente, Clientes.Apellido_Cliente order by Total_Productos_Vendidos desc