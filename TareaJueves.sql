-- Inventar un caso de uso con SP, funcion de tabla, funcion con parametro 
create database Practica3
go

use Practica3
go

create table Clientes (
    ID int primary key identity(1,1) not null,
    Nombre varchar(250),
    Email varchar(250)
)
go

create table Productos (
    ID int primary key identity(1,1) not null,
    Nombre varchar(250),
    Precio decimal(10, 2)
)
go

create table Pedidos (
    ID int primary key identity(1,1) not null,
    ClienteID int foreign key references Clientes(ID),
    FechaPedido varchar(250)
)
go

create table DetallesPedido (
    ID int primary key identity(1,1) not null,
    PedidoID int foreign key references Pedidos(ID),
    ProductoID int foreign key references Productos(ID),
    Cantidad int,
    PrecioUnitario decimal(10, 2)
)
go

INSERT INTO Clientes (Nombre, Email) VALUES
('Juan Perez', 'juan.perez@example.com'),
('Maria Lopez', 'maria.lopez@example.com'),
('Carlos Sanchez', 'carlos.sanchez@example.com'),
('Ana Martinez', 'ana.martinez@example.com'),
('Luis Gomez', 'luis.gomez@example.com');
GO

INSERT INTO Productos (Nombre, Precio) VALUES
('Laptop', 1500.00),
('Mouse', 25.00),
('Teclado', 45.00),
('Monitor', 300.00),
('Impresora', 200.00);
GO

INSERT INTO Pedidos (ClienteID, FechaPedido) VALUES
(1, '2025-02-20'),
(2, '2025-02-21'),
(3, '2025-02-22'),
(4, '2025-02-23'),
(5, '2025-02-24');
GO

INSERT INTO DetallesPedido (PedidoID, ProductoID, Cantidad, PrecioUnitario) VALUES
(1, 1, 1, 1500.00),
(1, 2, 2, 25.00),
(2, 3, 1, 45.00),
(2, 4, 1, 300.00),
(3, 5, 1, 200.00),
(4, 1, 1, 1500.00),
(4, 3, 1, 45.00),
(5, 2, 3, 25.00),
(5, 4, 2, 300.00);
GO

create procedure InsertarCliente
    @Nombre varchar(250),
    @Email varchar(250)
as
begin
    insert into Clientes (Nombre, Email) values (@Nombre, @Email)
end
go
exec InsertarCliente 'Pedro Ramirez', 'Pedro.Ramirez@@example.com'
go
select * from clientes
go
create procedure CrearPedido
    @ClienteID int,
    @FechaPedido varchar(250)
as
begin
    insert into Pedidos (ClienteID, FechaPedido) values (@ClienteID, @FechaPedido)
end
go

exec Crearpedido 6, '2025-02-26'
go
select * from Pedidos
go

create function CalcularTotalDePedido
(
    @PedidoID int
)
returns decimal(10, 2)
as
begin
    declare @Total decimal(10, 2)
    select @Total = sum(Cantidad * PrecioUnitario)
    from DetallesPedido
    where PedidoID = @PedidoID
    return @Total
end
go

select dbo.CalcularTotalDePedido(1) as TotalPedido1

select * from DetallesPedido