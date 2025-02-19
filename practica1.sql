create database practica1 
go
use practica1
go

create table productos (
id int,
Nombre varchar(250),
cantidad int, 
)
go
insert into productos values (1, 'Cartas', 23)
insert into productos values (3, 'Guantes', 15)
go
create procedure insertardatos 

as begin
insert into productos values (4, 'Bolza', 53)
select * from productos 
end;
go
exec insertardatos
go
