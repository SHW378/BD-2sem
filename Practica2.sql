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

INSERT INTO Productos (Nombre_Prod, Precio) VALUES
('Manzana', 15),
('Leche', 22),
('Pan', 12),
('Jabón', 10),
('Arroz', 18);
GO

create procedure InsertarProd
    @Nombre_Prod varchar(250),
    @Precio int
as
begin
    insert into Productos (Nombre_Prod, Precio)
    values (@Nombre_Prod, @Precio)
end
go

exec InsertarProd 'Manzana', 25
GO

create procedure SeleccionarProd
as
begin
    select * from Productos
end
go
exec SeleccionarProd
GO

create procedure UpdateProd
    @ID int,
    @Nombre_Prod varchar(250),
    @Precio int
as
begin
    update Productos
    set Nombre_Prod = @Nombre_Prod,
    Precio = @Precio
    where ID = @ID
END
go

exec UpdateProd '1', 'Manzana', 20
GO
create procedure DeleteProd
    @ID int
as
begin
    delete from Productos
    where ID = @ID
end
go
exec DeleteProd '1'
go

create table Proveedores (
ID int primary key identity(1,1) not null,
Nombre_Prov varchar(250),
Telefono varchar(250),
email varchar(250),
Dirección varchar(250)
)
go
INSERT INTO Proveedores (Nombre_Prov, Telefono, email, Dirección) VALUES
('Proveedor 1', '555-1234', 'proveedor1@example.com', 'Calle Falsa 123'),
('Proveedor 2', '555-5678', 'proveedor2@example.com', 'Av. Principal 456'),
('Proveedor 3', '555-9876', 'proveedor3@example.com', 'Calle Secundaria 789'),
('Proveedor 4', '555-4321', 'proveedor4@example.com', 'Camino Vecinal 101'),
('Proveedor 5', '555-6543', 'proveedor5@example.com', 'Avenida Central 202');
go

create procedure InsertarProv
    @Nombre_Prov varchar(250),
    @Telefono varchar(250),
    @email varchar(250),
    @Dirección varchar(250)
as
begin
    insert into Proveedores (Nombre_Prov, Telefono, email, Dirección)
    values (@Nombre_Prov, @Telefono, @email, @Dirección)
end
go

exec InsertarProv 'Proveedor 6', '555-1234', 'proveedor6@example.com', 'Marte 123'
go

create procedure SeleccionarProv
as
begin
    select * from Proveedores
end
go

exec SeleccionarProv 
GO

create procedure UpdateProv
    @ID int,
    @Nombre_Prov varchar(250),
    @Telefono varchar(250),
    @email varchar(250),
    @Dirección varchar(250)
as
begin
    update Proveedores
    set Nombre_Prov = @Nombre_Prov,
    Telefono = @Telefono,    
    email = @email,
    Dirección = @Dirección,
    Nombre_Prov = @Nombre_Prov
    where ID = @ID
END
go

exec UpdateProv 1, 'Proveedor 1', '555-1234', 'proveedor1@example.com', 'Jupiter 163'
GO

create procedure DeleteProv
    @ID int
as
begin
    delete from Proveedores
    where ID = @ID
end
go
exec DeleteProv 6
go

create table Inventario (
ID int primary key identity(1,1) not null,
NombreProd varchar(250),
CantidadProds int,
ProductoID int foreign key references Productos(ID),
ProveedorID int foreign key references Proveedores(ID)
)
go

INSERT INTO Inventario (NombreProd, CantidadProds, ProductoID, ProveedorID) VALUES
('Manzana', 100, 1, 1),
('Leche', 200, 2, 1),
('Pan', 150, 3, 2),
('Jabón', 80, 4, 2),
('Arroz', 50, 5, 1);
GO

create procedure InsertarInv
    @NombreProd varchar(250),
    @CantidadProds int,
    @ProductoID int,
    @ProveedorID int
as
begin
    insert into Inventario (NombreProd, CantidadProds, ProductoID, ProveedorID)
    values (@NombreProd, @CantidadProds, @ProductoID, @ProveedorID)
end
go

exec InsertarInv 'uva', 180, 1, 1
GO

create procedure SelectInv
as
begin
    select * from Inventario
end
go
exec SelectInv 
GO

create procedure UpdateInv
    @ID int,
    @NombreProd varchar(250),
    @CantidadProds int,
    @ProductoID int,
    @ProveedorID int
as
begin
    update Inventario
    set NombreProd = @NombreProd,
    CantidadProds = @CantidadProds,
    ProductoID = @ProductoID,
    ProveedorID = @ProveedorID
end
go
exec UpdateInv 1, 'uva', 200, 1, 1
go

create procedure DeleteInv
    @ID int
as
begin
    delete from Inventario where ID = @ID
end
go
exec DeleteInv 'uva', 200, 1, 1
go

create table Empleados (
ID int primary key identity(1,1) not null,
Nombre_Empl varchar(250),
Apellido_Empl varchar(250),
TelefonoContaco varchar(250),
Edad varchar(250)
)
go

INSERT INTO Empleados (Nombre_Empl, Apellido_Empl, TelefonoContaco, Edad) VALUES
('Carlos', 'Perez', '555-1122', '30'),
('Maria', 'Lopez', '555-3344', '25'),
('Luis', 'Martínez', '555-5566', '28'),
('Ana', 'García', '555-7788', '32'),
('Pedro', 'Ramírez', '555-9900', '26');
GO

create procedure InsertarEmpl
    @Nombre_Empl varchar(250),
    @Apellido_Empl varchar(250),
    @TelefonoContaco varchar(250),
    @Edad varchar(250)
as
begin
    insert into Empleados (Nombre_Empl, Apellido_Empl, TelefonoContaco, Edad)
    values (@Nombre_Empl, @Apellido_Empl, @TelefonoContaco, @Edad)
end
go

exec InsertarEmpl 'Juan', 'Torres', '555-1752', '36'
go

create procedure SeleccionarEmpl
as
begin
    select * from Empleados
end
go
exec SeleccionarEmpl
go

create procedure UpdateEmpl
    @ID int,
    @Nombre_Empl varchar(250),
    @Apellido_Empl varchar(250),
    @TelefonoContaco varchar(250),
    @Edad varchar(250)
as 
begin
    update Empleados
    set Apellido_Empl = @Apellido_Empl,
    TelefonoContaco = @TelefonoContaco,
    Edad = @Edad,
    Nombre_Empl = @Nombre_Empl
    where ID = @ID
end
go
exec UpdateEmpl 6, 'Juan', 'Torres', '589-1752', '36'
go

create procedure DeleteEmpl
    @ID int
as
begin
    delete from Empleados
    where ID = @ID
end
go
exec DeleteEmpl 6

create table Ventas (
ID int primary key identity(1,1) not null,
Cantidad int, 
FechaVenta varchar(250),
MontoTotal varchar(250),
ProductoID int foreign key references Productos(ID)
)
go

INSERT INTO Ventas (Cantidad, FechaVenta, MontoTotal, ProductoID) VALUES
(10, '2025-02-20', '150.00', 1),
(20, '2025-02-21', '440.00', 2),
(5, '2025-02-22', '60.00', 3),
(15, '2025-02-23', '150.00', 4),
(25, '2025-02-24', '225.00', 5);
go

create procedure InsertarVent
    @Cantidad int,
    @FechaVenta varchar(250),
    @MontoTotal varchar(250),
    @ProductoID int
as
begin
    insert into Ventas (Cantidad, FechaVenta, MontoTotal, ProductoID)
    values (@Cantidad, @FechaVenta, @MontoTotal, @ProductoID)
end
go

exec InsertarVent 15, '2025-12-17', '500.00', 1
go

create procedure SelectVent
as
begin
    select * from Ventas
end
go
exec SelectVent
go

create procedure UpdateVent
    @ID int,
    @Cantidad int,
    @FechaVenta varchar(250),
    @MontoTotal varchar(250),
    @ProductoID int
as
begin
    update Ventas
    set Cantidad = @Cantidad,
    FechaVenta = @FechaVenta,
    MontoTotal = @MontoTotal,
    ProductoID = @ProductoID
    where ID = @ID
end
go
exec UpdateVent 1, 10, '2025-12-17', '500.00', 1
create table Ventas (
ID int primary key identity(1,1) not null,
Cantidad int, 
FechaVenta varchar(250),
MontoTotal varchar(250),
ProductoID int foreign key references Productos(ID)
)
go

create procedure DeleteVent
    @ID int
as 
begin
    delete from Ventas where ID = @ID
end
go
