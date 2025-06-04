-- El sistema de base de datos debe de hacer un full back up cada que se inserta un registro en una tabla de base de datos
-- POC (prueba de concepto)
create database practicabackup
go

use practicabackup
go

create table empleados (
id int primary key identity(1,1) not null,
nombre varchar(250),
)
go

create table vendedores (
id int primary key identity(1,1) not null,
nombre varchar(250)
)
go

create procedure sp_InsertBackUp
    @nombreEmpleado varchar(250)
AS
BEGIN
    begin transaction
    insert into empleados (nombre)
    values (@nombreEmpleado);
    if @@error = 0
    begin
        commit transaction
        backup database practicabackup to disk = 'C:\Users\cesar\OneDrive\Documentos\BackUpsSQL\BackUp.bak' with format, init, name = 'DB practicabackup FULL Backup 5/27'
    end
    else 
        begin
        rollback transaction
        print 'Error al insertar el registro'
        return
    end
END
GO

exec sp_InsertBackUp 'Cesar';
go

insert into empleados values ('Julian');
go
select  * from empleados
go
--
insert into vendedores values ('Alberto');
go
select * from vendedores
go

drop table vendedores1

drop trigger trg_backupVendedores1
