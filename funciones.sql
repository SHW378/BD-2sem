-- funciones definidas por el usuario

use ejemploProcedure
go

create function GetVentasWhereID1()
returns table 
as
return(Select * from ventas where idVenta= 1)

-- como usar funciones select
select * from GetVentasWhereID1()
go
-- funciones con parametros o funciones escalares
create function GetInfoProductos
(
	@Producto varchar(90),
	@Categoria varchar(50)
)
returns nvarchar(250)
as 
begin
return(select 'Producto: '+@Producto+'Categoria: '+@Categoria)
end
go

select dbo.GetInfoProductos(Producto, Categoria) as Info from Ventas
go
-- funcion para sumar 2 numeros en SQL
-- Param: n1, n2
-- Output: n1+n2
-- Sin select
go

create function sumarnums
(
	@n1 int,
	@n2 int
)

returns int
as 
begin
	declare @resultado int
	set @resultado = @n1 + @n2
	return @resultado
end
go
print dbo.sumarnums(5,7)
go

-- SP
-- Funcion tabla
-- Funcion parametro