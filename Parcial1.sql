/*
gbd_Parcial1_82196 
ID con identity(1,1)
Tablas: 
-- Empleados 
	- ID, Nombre, Telefono
- Producto 
	- Id, Nombre, Marca, Precio, Existencias
- Estimaciones
	- ID, Producto, Empleados, Precio total
- Ventas
	- ID, Fecha, Empleado, Cliente, Producto
- Clientes
	- Id, Nombre, Direcciones, Telefono, correo
*/

create database gbd_Parcial1_82196_1
go
use gbd_Parcial1_82196_1
go

create table Empleados (
ID int primary key identity(1,1) not null,
Nombre_Empl varchar(250),
Telefono varchar(250)
)
go
alter table Empleados add Estatus varchar(250) default 'Activo'
go
create table Producto (
ID int primary key identity(1,1) not null,
Nombre_Prod varchar(250),
Marca varchar(250),
Precio int,
Existencias int
)
go
alter table Producto add Estatus varchar(250) default 'Activo'
go
create table Estimaciones (
ID int primary key identity(1,1) not null,
PrecioTotal int,
ProductoID int foreign key references Producto(ID),
EmpleadoID int foreign key references Empleados(ID)
)
go
alter table Estimaciones add Estatus varchar(250) default 'Activo'
go
create table Clientes (
ID int primary key identity(1,1) not null,
Nombre_Cliente varchar(250),
Direcciones varchar(250),
Telefono varchar(250),
Correo varchar(250)
)
go
alter table Clientes add Estatus varchar(250) default 'Activo'
go
create table Ventas (
ID  int primary key identity(1,1) not null,
Fecha datetime default getdate(),
EmpleadoID int foreign key references Empleados(ID),
ClienteID int foreign key references Clientes(ID),
ProductoID int foreign key references Producto(ID)
)
go
alter table Ventas add Estatus varchar(250) default 'Activo'
go

create table LogTablas (
	ID int primary key identity(1,1) not null,
	Fecha datetime default getdate(),
	Accion varchar(250)
)
go

-- hasta aqui son las tablas

create trigger trg_cerosEmpleados2
on Empleados
after insert
as 
begin 
	update Empleados
	set Telefono = 0000000000000
	where Telefono is null
	and ID in (select ID from inserted)
end;
go

insert into Empleados (Nombre_Empl) values ('Juan Perez')
go

create function CalcularIVA(@Precio decimal(10, 2))
returns decimal(10, 2)
as
begin
    return @Precio * 1.16
end
go

create procedure sp_InsertarEstimacion
(
    @ProductoID int,
    @EmpleadoID int
)
as
begin
    declare @Precio decimal(10, 2)
    declare @PrecioTotal decimal(10, 2)

    -- Obtener el precio del producto
    select @Precio = Precio from Producto where ID = @ProductoID

    -- Calcular el precio total con IVA usando la función
    set @PrecioTotal = dbo.CalcularIVA(@Precio)

    -- Insertar en la tabla Estimaciones
    insert into Estimaciones (ProductoID, EmpleadoID, PrecioTotal)
    values (@ProductoID, @EmpleadoID, @PrecioTotal)
end
go

create procedure sp_AgregarProducto
(
	@Nombre_Prod varchar(250),
	@Marca varchar(250),
	@Precio int
)
as
begin
	declare @ProductoID int
	select @ProductoID = ID
	from Producto
	where Nombre_Prod = @Nombre_Prod and Marca = @Marca
	if @ProductoID is not null
	begin
		update Producto
		set Existencias = Existencias + 1
		where ID = @ProductoID
	end
	else
	begin
		insert into Producto (Nombre_Prod, Marca, Precio, Existencias, Estatus)
		values (@Nombre_Prod, @Marca, @Precio, 1, 'Activo')
	end
end;
go

exec sp_AgregarProducto 'Laptop', 'Dell', 1500
go

select * from Producto
go

--triggers de los logs
create trigger AfterInserEmpleados1
on Empleados
after insert
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Empleado Agregado' from inserted;
end;
go

create trigger AfterUpdateEmpleados1
on Empleados
after update
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Empleado Actualizado' from inserted;
end;
go

create trigger AfterInsertProducto1
on Producto
after insert
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Producto Agregado' from inserted;
end;
go

create trigger AfterUpdateProducto1
on Producto
after update
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Producto Actualizado' from inserted;
end;
go

create trigger AfterInsertEstimaciones1
on Estimaciones
after insert
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Estimacion Agregada' from inserted;
end;
go

create trigger AfterUpdateEstimaciones1
on Estimaciones
after update
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Estimacion Actualizada' from inserted;
end;	
go

create trigger AfterInsertClientes1
on Clientes
after insert
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Cliente Agregado' from inserted;
end;
go

create trigger AfterUpdateClientes1
on Clientes
after update
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Cliente Actualizado' from inserted;
end;
go

create trigger AfterInsertVentas1
on Ventas
after insert
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Venta Agregada' from inserted;
end;
go

create trigger AfterUpdateVentas1
on Ventas
after update
as
begin
	insert into LogTablas (ID, Accion)
	select ID, 'Venta Actualizada' from inserted;
end;
go
--aqui acaban los triggers de los logs

-- Empiezan triggers de prevenir delete
create trigger trg_PrevenirDeleteEmpleados
on Empleados 
instead of delete 
as
begin
	update Empleados set Estatus = 'Inactivo' where ID in (select ID from deleted)
end;
go

create trigger trg_PrevenirDeleteProducto
on Producto
instead of delete
as
begin
	update Producto set Estatus = 'Inactivo' where ID in (select ID from deleted)
end;
go

create trigger trg_PrevenirDeleteEstimaciones
on Estimaciones
instead of delete
as
begin
	update Estimaciones set Estatus = 'Inactivo' where ID in (select ID from deleted)
end;
go

create trigger trg_PrevenirDeleteClientes
on Clientes
instead of delete
as
begin
	update Clientes set Estatus = 'Inactivo' where ID in (select ID from deleted)
end;
go

create trigger trg_PrevenirDeleteVentas
on Ventas
instead of delete
as
begin
	update Ventas set Estatus = 'Inactivo' where ID in (select ID from deleted)
end;
go
-- aqui acaban los triggers de prevenir delete

create trigger trg_EstimacionAgregada
on Estimaciones
after insert
as
begin
    declare @EmpleadoID int
    declare @Nombre_Empl varchar(250)

    select @EmpleadoID = EmpleadoID from inserted

    select @Nombre_Empl = Nombre_Empl from Empleados where ID = @EmpleadoID

    print 'Estimacion agregada por ' + @Nombre_Empl
end;
go

create function ProductoMasVendido()
returns table
as
return
(
	select top 1 Producto.ID, Producto.Nombre_Prod, Producto.Marca, count(Ventas.ID) as TotalVentas
	from Producto
	join Ventas on Producto.ID = Ventas.ProductoID
	group by Producto.ID, Producto.Nombre_Prod, Producto.Marca
	order by TotalVentas desc
)
go

create function EmpleadosConMasEstimaciones()
returns table
as
return
(
	select Empleados.ID, Empleados.Nombre_Empl, count(Estimaciones.ID) as TotalEstimaciones
	from Empleados
	join Estimaciones on Empleados.ID = Estimaciones.EmpleadoID
	group by Empleados.ID, Empleados.Nombre_Empl
	order by TotalEstimaciones desc
)
go

create function ProductoMasCaro()
returns table
as
return
(
	select top 1 * from Producto order by Precio 
	desc
)
go

create function ProductoMasBarato()
returns table
as
return
(
	select top 1 * from Producto order by Precio 
	asc
)
go

create trigger trg_ActualizarExistenciasDeProducto
on Producto
after update 
AS
begin
	if update(Estatus)
	begin
		update Producto
		set Existencias = 0
		where Estatus = 'Inactivo'
		and ID in (select ID from inserted)
	end
end;
go

/*
insert into Empleados (Nombre_Empl, Telefono) values ('Juan Perez', '1234567890');
insert into Empleados (Nombre_Empl, Telefono) values ('Maria Lopez', '0987654321');
insert into Empleados (Nombre_Empl, Telefono) values ('Carlos Sanchez', null);
go

insert into Producto (Nombre_Prod, Marca, Precio, Existencias) values ('Laptop', 'Dell', 1500.00, 10);
insert into Producto (Nombre_Prod, Marca, Precio, Existencias) values ('Mouse', 'Logitech', 25.00, 50);
insert into Producto (Nombre_Prod, Marca, Precio, Existencias) values ('Teclado', 'Microsoft', 45.00, 30);
go

insert into Clientes (Nombre_Cliente, Direcciones, Telefono, Correo) values ('Cliente 1', 'Direccion 1', '1111111111', 'cliente1@example.com');
insert into Clientes (Nombre_Cliente, Direcciones, Telefono, Correo) values ('Cliente 2', 'Direccion 2', '2222222222', 'cliente2@example.com');
insert into Clientes (Nombre_Cliente, Direcciones, Telefono, Correo) values ('Cliente 3', 'Direccion 3', '3333333333', 'cliente3@example.com');
go

insert into Ventas (EmpleadoID, ClienteID, ProductoID) values (1, 1, 1);
insert into Ventas (EmpleadoID, ClienteID, ProductoID) values (2, 2, 2);
insert into Ventas (EmpleadoID, ClienteID, ProductoID) values (3, 3, 3);
go

exec sp_InsertarEstimacion 1, 1;
exec sp_InsertarEstimacion 2, 2;
exec sp_InsertarEstimacion 3, 3;
go


select * from Estimaciones;
go

exec sp_AgregarProducto 'Monitor', 'Samsung', 200.00;
exec sp_AgregarProducto 'Laptop', 'Dell', 1500.00; -- Incrementar existencias
go

select * from Producto;
go

select * from LogTablas;
go

update Empleados set Telefono = '5555555555' where ID = 1;
go

exec sp_InsertarEstimacion 1, 1;
go

select * from LogTablas;
go

update Producto set Estatus = 'Inactivo' where ID = 1;
go

select * from Producto;
go

select * from fn_ProductoMasVendido();
go

select * from fn_EmpleadosConMasEstimaciones();
go

select * from fn_ProductoMasCaro();
go

select * from fn_ProductoMasBarato();
go
*/