-- Store Procedures / Procedimientos Almacenados 
create database ejemploProcedure
go
use ejemploProcedure
go

create procedure InsertarProd2 as begin 
insert into Ventas values (5, 'Tenis', 'Sport', 34, 500)
select * from ventas -- to do
end; 
go
-- llamar o ejecutar el PA 
exec InsertarProd2; 
go
create table Ventas (
idVenta int, 
producto varchar(50),
Categoria varchar(50),
Cantidad int, 
Precio int,
)
go
insert into Ventas values (1, 'Tenis', 'Sport', 34, 500)
insert into Ventas values (2, 'Tenis', 'Sport', 34, 500)
insert into Ventas values (3, 'Tenis', 'Sport', 34, 500)

select * from ventas  
go
create procedure InsertarProducto2

@SetId int, 
@SetProducto varchar(50),
@SetCategoria varchar(50),
@SetPrecio int, 
@SetCantidad int

as begin
insert into Ventas values (@SetId, @SetProducto, @SetCategoria, @SetPrecio, @SetCantidad)
end
go

exec InsertarProducto2 1, 'Chanclas', 'Zapatos', 2, 1;
exec InsertarProducto2 2, 'Chanclas', 'Zapatos', 2, 1;

go
--sp que busque las ventas de un producto en especifico 
create procedure BuscarProdc2

@SetProducto varchar(50)

as
begin 
select * from ventas where Producto = @SetProducto
end
go

exec BuscarProdc2 'Chanclas'
go

--SP que devuelva los ingresos de una categoria especifica E. g Zapatos 

create procedure GetIngresosCat
@Categoria varchar(50),
@TotalIngresos int output
as
begin
	select @TotalIngresos = sum(Cantidad*Precio) from Ventas where Categoria=@Categoria
end;
go

declare @TotalIngresos int;
exec GetIngresosCat 'Zapatos', @TotalIngresos output;
select @TotalIngresos as TotalIngresos;

select * from ventas
go

-- 1. ejecutar el SP1 para obtener la suma de x categoria
-- 2. ejecutar SP2 para guardar esa suma de una tabla con la sig definicion
-- Tabla historial
-- Columnas: ID int identity(1,1)
-- Total: int,
-- Fecha de Transacci�n: Date
-- El SP2 va a obtener la suma de x categoria (SP1 y va a guardar en la tabla Historial)
-- Llenando el campo de Total con el dato de SP1 y la fecha con la fecha en el momento de la 
-- transacción (Obtenida automaticamente) NO SE VA A PONER MANUALMENTE

--Get Date


create table Historial (
    ID int identity(1,1),
    Total int,
    FechaTransaccion date
);
go


create procedure GuardarSumaTabla
@Categoria varchar(50)
as
begin
    declare @Ingresos int;
    exec GetIngresosCat @Categoria, @Ingresos output
    insert into Historial (Total, FechaTransaccion) values (@Ingresos, getdate());
end;
GO
exec GuardarSumaTabla 'Zapatos';
select * from Historial;
go

--ccrear un SP que inserte registros en una tabla x y que llevue un conteo de el siguiente ID a insertar

create table Datos (
id int primary key, 
dato varchar(50)
)

go

select * from Datos
insert into Datos values (1,'dato1')

go
create procedure insertarsinidentity2
@dato varchar(50)
as begin	
	declare @contador int;
	select @contador = (Select top 1 id from Datos order by id desc) + 1 
	insert into Datos (id, dato) values (@contador, @dato)

end;
go

exec insertarsinidentity2 'dato3'

--if else
declare @contador int;
declare @dato varchar(50);
IF @Dato = 0
BEGIN
 set @contador = (select top 1 ID from Datos order by ID Desc) +0
 insert into Datos(ID, Dato) Values (@contador , @dato);
	END
ELSE
	BEGIN
 set @contador = (select top 1 ID from Datos order by ID Desc) +1
 insert into Datos(ID, Dato) Values (@contador , @dato);
END