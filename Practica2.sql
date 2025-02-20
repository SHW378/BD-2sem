-- crear una BD de al menos 5 tablas 
-- Relaciones 1-1, 1-*, *-*

-- crud
-- Create 
-- Read -- Select * from
-- Update
-- Delete

-- A  base de SP
-- Un SP para cada operacion que funcione para todas las tablas
-- Un SP para cada tabla y cada operaciòn

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
