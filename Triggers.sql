-- Trigger

-- AFTER (FOR) Triggers
-- Se ejecutan despues de un INSERT, UPDATE, DELETE

-- Instead of triggers
-- Se ejecutan luego de la operación que los activo

-- DDL(LDD) Triggers
--Se activan despues de modificaciones al modelo de bd
--Después de CREATE, ALTER o DROP

--LOGON Triggers
--Se activan cuando un usuario inicia sesion en SQL Server


-- After Trigger
use test2
go

create  table Empleados(
	ID int primary key identity(1,1),
	Nombre varchar(50),
	Departamento varchar(50)
);

Alter table Empleados add Estatus varchar(15) default 'Activo'

create table Empleados_log(
	ID int primary key identity(1,1),
	EmpleadoID int,
	Accion varchar(50),
	Fecha datetime default getdate()
);

--Se requiere registrar un log cada vez que se inserta un empleado nuevo
go
create trigger trg_AfterInsertEmpleado
on Empleados 
after insert 
as 
begin
	insert into Empleados_Log (EmpleadoID, Accion)
	select ID, 'Empleado Agregado' from inserted;
end;

--Test
drop table Empleados
delete from Empleados where id =3
select * from Empleados
select * from Empleados_log

insert into Empleados (Nombre, Departamento) values ('Gerardo', 'Ventas')
go

--Trigger que cuando se actualice un empleado, cree un log con accion 'Empleado Actualizado'
create trigger trg_AfterUpdateEmpleado
on Empleados
after update
as begin
	insert into Empleados_Log (EmpleadoID, Accion)
	select ID, 'Empleado Actualizado' from inserted
end;

update Empleados set Departamento = 'finanzas' where id = '2'
go

--Insted of
--Tenemos que evitar que se eliminen registros de empleados, Cuando alguien intente eliminar un empleado, Solo se tiene que desactivar mas no eliminar 
-- == Eliminación lógica
go

create trigger trg_PrevenirDeleteEmpleado
on Empleados
instead of delete 
as
begin
	update Empleados set Estatus = 'Inactivo' where id in (select id from deleted) 
end;

select * from Empleados

delete from Empleados where id = 7