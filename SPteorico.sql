-- procedimientos almacenados
-- metodos que se pueden ejecutar en cualuiqer lugar de la base de datos
-- y en cualquier momento
-- Funcionalidades de los SP
-- Requerir parametros de entrara (numerico, varchar, booleano)
-- Proveer parametros de salida (Return numeros, varchar, booleano)
-- Se ejecutan con el nombre + (parametro)
-- funcionalidad principal es agrupar transacciones que tienen que ejecutarse juntas
-- Gestionar una base de datos
-- Para automatizar tareas/flujos



create procedure nombrex 
as
begin
	--Totas las transacciones que necesites hacer en tu flujo
end;

--Ejecutarlo
exec nombrex
go

--SP con parametros de entrada
create procedure nombrex1
	@Parametro1 tipoDato
	--@Nombre varchar(50)
	--@Id int 
	--@Status boolean
as
begin
	--Todas las transacciones que necesites hacer en tu flujo
	--E.g Select * from tabla wher Id = @Id
end;
go
exec nombrex1 1, 'Hola'
go
--Sp con Parametros de salida

create procedure nombrex2 
	@ParametroSalida tipodato output
	--@Totalventas int output
	--Id encontrado int output
	-- Nombre varchar(50) output
	--nvarchar(500) para output
as
begin
	--Todas las transacciones que necesites hacer en tu flujo
	--E.g Select * from tabla wher Id = @Id
	--Agregar valor al parametro output
	--Select @parametro salida = id from ventas where cliente = 'Gerardo'
end;
declare @Resultado tipoDato 
exec nombrex2 @Resultado output;
print @Resultado

--Asignar valor a una variable 



