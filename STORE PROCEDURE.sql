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
	select @totalIngresos = sum(Cantidad*Precio) from Ventas where Categoria=@Categoria
end;
go

declare @Total int
go
exec GetIngresosCat 'Zapatos', @Total output