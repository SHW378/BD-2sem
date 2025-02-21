-- crear una BD de al menos 5 tablas 
-- Relaciones 1-1, 1-*, *-*

-- crud
-- Create 
-- Read -- Select * from
-- Update
-- Delete

-- A  base de SP
-- Un SP para cada operacion que funcione para todas las tablas
-- Un SP para cada tabla y cada operaci�n

create database AbarrotesSeñorDeLosImposibles
go

use AbarrotesSeñorDeLosImposibles
go

create table Productos (
ID int primary key identity(1,1) not null,
Nombre_Prod varchar(250),
Precio int,
)
go

create table Proveedores (
ID int primary key identity(1,1) not null,
Nombre_Prov varchar(250),
Telefono varchar(250),
email varchar(250),
Dirección varchar(250)
)
go

create table Inventario (
ID int primary key identity(1,1) not null,
NombreProd varchar(250),
CantidadProds int,
ProductoID int foreign key references Productos(ID),
ProveedorID int foreign key references Proveedores(ID)
)
go

create table Empleados (
ID int primary key identity(1,1) not null,
Nombre_Empl varchar(250),
Apellido_Empl varchar(250),
TelefonoContaco varchar(250),
Edad varchar(250)
)
go

create table Ventas (
ID int primary key identity(1,1) not null,
Cantidad int, 
FechaVenta varchar(250),
MontoTotal varchar(250),
ProductoID int foreign key references Productos(ID)
)
go

INSERT INTO Productos (Nombre_Prod, Precio) VALUES
('Manzana', 15),
('Leche', 22),
('Pan', 12),
('Jabón', 10),
('Arroz', 18);
GO
INSERT INTO Proveedores (Nombre_Prov, Telefono, email, Dirección) VALUES
('Proveedor 1', '555-1234', 'proveedor1@example.com', 'Calle Falsa 123'),
('Proveedor 2', '555-5678', 'proveedor2@example.com', 'Av. Principal 456');
go
INSERT INTO Inventario (NombreProd, CantidadProds, ProductoID, ProveedorID) VALUES
('Manzana', 100, 1, 1),
('Leche', 200, 2, 1),
('Pan', 150, 3, 2),
('Jabón', 80, 4, 2),
('Arroz', 50, 5, 1);
GO
INSERT INTO Empleados (Nombre_Empl, Apellido_Empl, TelefonoContaco, Edad) VALUES
('Carlos', 'Perez', '555-1122', '30'),
('Maria', 'Lopez', '555-3344', '25');
GO
INSERT INTO Ventas (Cantidad, FechaVenta, MontoTotal, ProductoID) VALUES
(10, '2025-02-20', '150.00', 1),
(20, '2025-02-21', '440.00', 2);
go

