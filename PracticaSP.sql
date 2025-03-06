/*Crea un procedimiento almacenado avanzado que realice las siguientes funciones:
    1.  Reciba como entrada:
    �   El nombre del producto (@Producto)
    �   La categoria (@Categoria)
    �   La cantidad (@Cantidad)
    �   El precio unitario (@PrecioUnitario)
    2.  Antes de insertar el producto en la tabla Ventas:
    �   Si la cantidad o el precio es menor o igual a 0,
    el procedimiento debe cancelar la operacion y devolver un mensaje de error.
    �   Si el producto ya existe en la misma categoria,
    el procedimiento debe sumar la cantidad en lugar de insertar una nueva fila.
    3.  Devuelva como salida:
    �   El Id de la venta recien insertada o actualizada (@IdVentaSalida).
    �   Un mensaje de confirmacion (@Mensaje)
*/


	-- if exists (select 1 from table where x)
	--		existe el registro
	--		cantidad+ x
	--			update
	-- else 
	--		No existe el registro
	--		insert

create database Tiendita
GO
use Tiendita
GO

CREATE TABLE Producto (
	Id int primary key identity(1,1) not null,
    Producto varchar(250),
	Cantidad int, 
	PrecioUnitario decimal(18,2),
	Categoria varchar(50),

)
go
create procedure  sp_DeTiendita
(
@Producto varchar(250),
@Categoria varchar(250),
@Cantidad int,
@PrecioUnitario decimal(10, 2),
@IdVentaSalida int output,
@Mensaje varchar(250) output
)
as
BEGIN
if @Cantidad <= 0 or @PrecioUnitario <= 0
begin
set @Mensaje = 'La cantidad y el precio unitario deben ser mayores a 0.'
END
else 
BEGIN
if exists (select 1 from Ventas where Producto = @Producto and Categoria = @Categoria)
begin
update Ventas
set Cantidad = Cantidad + @Cantidad
where Producto = @Producto and Categoria = @Categoria
select @IdVentaSalida = ID from Ventas where Producto = @Producto and Categoria = @Categoria
set @Mensaje = 'Venta actualizada.'
end
else 
BEGIN
insert into Ventas (Producto, Categoria, Cantidad, PrecioUnitario)
values (@Producto, @Categoria, @Cantidad, @PrecioUnitario)
set @IdVentaSalida = scope_identity()
set @Mensaje = 'Venta insertada.'
END
END
END
go


declare @IdVentaSalida int
declare @Mensaje varchar(250)

exec sp_DeTiendita 'Laptop', 'Electrónica', 5, 1500.00, @IdVentaSalida output, @Mensaje output

print 'ID de la venta: ' + cast(@IdVentaSalida as varchar)
print 'Mensaje: ' + @Mensaje