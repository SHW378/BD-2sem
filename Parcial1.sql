/*
gbd_Parcial1_82196 
ID con identity(1,1)
Tablas: 
-- Empleados 
	- ID, Nombre, Telefono
- Producto 
	- Id, Nombre, Marca, Precio, Existencias
- Estimaciones
	- ID, Producto, Empleados, Precio total
- Ventas
	- ID, Fecha, Empleado, Cliente, Producto
- Clientes
	- Id, Nombre, Direcciones, Telefono, correo
*/

create database gbd_Parcial1_82196
go
use gbd_Parcial1_82196
go

create table Empleados (
ID int primary key identity(1,1) not null,
Nombre_Empl varchar(250),
Telefono varchar(250)
)
go

create table Producto (
ID int primary key identity(1,1) not null,
Nombre_Prod varchar(250),
Marca varchar(250),
Precio int,
Existencias int
)
go

create table Estimaciones (
ID int primary key identity(1,1) not null,
PrecioTotal int,
ProductoID int foreign key references Producto(ID),
EmpleadoID int foreign key references Empleados(ID)
)

create table Clientes (
ID int primary key identity(1,1) not null,
Nombre_Cliente varchar(250),
Direcciones varchar(250),
Telefono varchar(250),
Correo varchar(250)
)

create table Ventas (
ID  int primary key identity(1,1) not null,
Fecha datetime default getdate(),
EmpleadoID int foreign key references Empleados(ID),
ClienteID int foreign key references Clientes(ID),
ProductoID int foreign key references Producto(ID)
)