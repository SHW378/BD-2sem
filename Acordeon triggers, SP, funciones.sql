--En el examen se deberia llamar GBD_Parcial1_(matricula)
--IDs con Identity(1,1)
--Tabla Empleados: ID, Nombre, Telefono
--Producto: ID, Nombre, Marca, Precio, Existencias
--Estimaciones: ID, Producto (foregein key de la tabla Producto), Empleado (foregein key de la tabla Empleados), Precio Total
--Ventas: ID, Fecha, Empleado (foregein key de la tabla Empleados), Cliente (foregein key de la tabla Clientes), Producto (foregein key de la tabla Productos)
--Clientes: ID, Nombre, Direccion, Telefono, Correo

create database acordeon_S2P1
go

use acordeon_S2P1
go

create table Empleados (
	ID int primary key identity(1,1),
	Nombre varchar(50),
	Telefono varchar(50),
	Estatus varchar(15) default 'Activo' --Default indica que la variable se añade automaticamente
);
go

create table Productos (
	ID int primary key identity(1,1),
	Nombre varchar(50),
	Marca varchar(50),
	Precio int,
	Existencias int
);
go

create table Clientes (
	ID int primary key identity(1,1),
	Nombre varchar(50),
	Direccion varchar(50),
	Telefono varchar(50),
	Correo varchar(50)
);
go

create table Estimaciones (
	ID int primary key identity(1,1),
	ProductoID int foreign key references Productos(ID),
	EmpleadoID int foreign key references Empleados(ID),
	Precio_Total int
);
go

create table Ventas (
	ID int primary key identity(1,1),
	Fecha date,
	EmpleadoID int foreign key references Empleados(ID),
	ClienteID int foreign key references Clientes(ID),
	ProductoID int foreign key references Productos(ID)
);
go

--Apartir de aqui, se convierte en acordeon con los procedures, funciones y triggers realizados anteriormente

--creacion tabla para triggers, este caso Empleado
create table Empleados_log (
	ID int primary key identity(1,1),
	EmpleadoID int,
	Accion varchar(50),
	Fecha datetime default getdate() --Default indica que la variable se añade automaticamente
);
go

--AFTER (FOR) Triggers (Eventos que se activen cuando se haga una accion)

--After Insert Empleado (Registrar LOG)
create trigger tgr_AfterInsertEmpleado
on Empleados
after insert
as
begin
	insert into Empleados_Log (EmpleadoID, Accion) 
	select ID, 'Empleado Agregado' 
	from inserted;
end;
go

--Prueba After insert 
insert into Empleados(Nombre, Telefono) values ('Nombre 1', 'Telefono 1') --Registro de prueba
go

--After Update Empleado (Registrar LOG)
create trigger trg2_AfterUpdateEmpleado
on Empleados
after update
as
begin
	insert into Empleados_Log (EmpleadoID, Accion) 
	select ID, 'Empleado Actualizado' 
	from inserted;
end;
go

--Prueba After update 
insert into Empleados(Nombre, Telefono) values ('Nombre 1', 'Telefono 1') --primero registrar otro ejemplo
go
update Empleados set Nombre = 'Nombre 2', Telefono = 'Telefono 2' where ID = 2 --Registro de prueba se actualiza
go

--After Delete Empleado (Registrar LOG)
create trigger trg3_AfterDeleteEmpleado
on Empleados
after delete
as
begin
	insert into Empleados_Log (EmpleadoID, Accion) 
	select ID, 'Empleado Eleminado' 
	from deleted;
end;
go

--Prueba After delete
insert into Empleados(Nombre, Telefono) values ('Nombre 3', 'Telefono 3') --primero registrar otro ejemplo
go
delete from Empleados where ID = 3 --Registro de prueba de Eleminado
go

--INSTEAD OF Triggers (Eventos que reemplazar a las acciones que se indiquen)

--Instead of delete Empleado (Prevenir eleminar Empleado + Registrar LOG)
Create trigger tgr4_PrevenirDeleteEmpleado
on Empleados
Instead Of delete
as
begin
	Update Empleados 
	set Estatus = 'inactivo' 
	where ID in (Select ID from deleted);

	insert into Empleados_log (EmpleadoID, Accion) 
	select ID, 'Intento de eleminar Empleado'
	from deleted;
end;
go

--Prueba instead of delete 
insert into Empleados(Nombre, Telefono) values ('Nombre 4', 'Telefono 4') --primero registrar otro ejemplo
go
delete from Empleados where ID = 4 --Registro de prueba de Eleminado
go

--Instead of insert Empleado (Prevenir registrar nombre vacio mediante condicion if, + Registrar LOG)
Create trigger tgr5_NoNombreVacio
on Empleados
Instead of insert
as
begin
	if exists (select * from inserted where Nombre = '')
	begin
		Insert Empleados_Log (EmpleadoID, Accion) select ID, 'Intento de insertar nombre vacio'
		from inserted where Nombre = '';
	end
	else
	begin
		Insert Empleados (Nombre, Telefono)
		select Nombre, Telefono
		from inserted;
	end
end;
go

--Prueba instead of insert 
insert into Empleados(Nombre, Telefono) values ('', 'Telefono x') --Registro de prueba de insert
go

--Instead of Update Empleado (Prevenir actualizar telefono mediante condicion if + Regustrar LOG)
create trigger tgr6_PrevenirUpdateTelefono
on Empleados
instead of update
as
begin
	if update(Telefono)
	begin
		Insert Empleados_Log (EmpleadoID, Accion) 
		select ID, 'Intento de actualizar telefono'
		from inserted;
		-- Para actualizar la tabla empleados pero no el telefono, es necesario in INNER JOIN
		update Empleados
        set Nombre = i.Nombre --Nombre (Empleado) columa obtiene alias i
        from Empleados e --Empleado tabla tiene alias e
        join inserted i on e.ID = i.ID; --asigna alias i al join con el inserted con e.ID (EmpleadoID) que coincida con i.ID (inserted ID)
	end
	else
	begin
		update Empleados
		set Nombre = i.Nombre, Telefono = i.Telefono --lo mismo pero añadiendo telefono, para que tambien se modifique
        from Empleados e
        join inserted i on e.ID = i.ID;
	end
end;
go

--Prueba instead of update
insert into Empleados(Nombre, Telefono) values ('Nombre 5', 'Telefono 5') --Primero insert
go
update Empleados set Nombre = 'Nombre  5' where ID = 5; --modifica solo Nombre y no Telefono
go
update Empleados set Nombre = 'Nombre 5', Telefono = 'Telefono  5' where ID = 5;
go

--Comprobacion todos los triggers realizados
select * from Empleados
go
select * from Empleados_log
go

--Crear registros en otras tablas para los siguientes procedures y funciones a usar
insert into Empleados (Nombre, Telefono, Estatus) values 
('Juan Perez', '123-456-7890', 'Activo'),
('Maria Lopez', '234-567-8901', 'Activo'),
('Carlos Sanchez', '345-678-9012', 'Activo'),
('Ana Gomez', '456-789-0123', 'Activo'),
('Luis Ramirez', '567-890-1234', 'Activo');
go

insert into Productos (Nombre, Marca, Precio, Existencias) values 
('Producto A1', 'Marca1', 100, 50),
('Producto A2', 'Marca1', 150, 30),
('Producto B1', 'Marca2', 200, 20),
('Producto B2', 'Marca2', 250, 10),
('Producto C1', 'Marca3', 300, 15);
go

insert into Clientes (Nombre, Direccion, Telefono, Correo) values 
('Cliente 1', 'Direccion 1', '111-222-3333', 'cliente1@example.com'),
('Cliente 2', 'Direccion 2', '222-333-4444', 'cliente2@example.com'),
('Cliente 3', 'Direccion 3', '333-444-5555', 'cliente3@example.com'),
('Cliente 4', 'Direccion 4', '444-555-6666', 'cliente4@example.com'),
('Cliente 5', 'Direccion 5', '555-666-7777', 'cliente5@example.com');
go

insert into Estimaciones (ProductoID, EmpleadoID, Precio_Total) values 
(1, 6, 500),
(2, 6, 750),
(3, 7, 300),
(4, 8, 450),
(5, 9, 600);
go

insert into Ventas (Fecha, EmpleadoID, ClienteID, ProductoID) values 
('2025-03-01', 6, 1, 1),
('2025-03-02', 7, 2, 2),
('2025-03-03', 8, 3, 3),
('2025-03-04', 9, 4, 4),
('2025-03-05', 10, 5, 5);
go

--Crear tabla de Registro de ingresos
create table RegistrosIngresos (
    ID int primary key identity(1,1),
    Fecha date,
    TotalIngresos int
);
go

--PROCEDURES (Procdimiento Almacenados)

--SP1 Conseguir precio de un producto
create procedure SP1_ConseguirPrecio
	@ProductoID int
as
begin
    select ProductoID, sum(Precio_Total) as Precio_Total
    from Estimaciones
    where ProductoID = @ProductoID
    group by ProductoID;
end;
go

--Probar Procedure Conseguir Precio
exec SP1_ConseguirPrecio @ProductoID = 2;
go

--SP2 Generar todos los ingresos 
create procedure SP2_CalcularTotalIngresos
as
begin
    select sum(Precio * Existencias) as TotalIngresos
    from Productos;
end;
go

--Probar Procedure Calcular el total de ingresos
exec SP2_CalcularTotalIngresos;
go

--SP3 Guardar suma en la tabla (y la hace)
create procedure SP3_GuardarTotalIngresos
as
begin
    declare @TotalIngresos int;

    -- Calcular el total de ingresos
    select @TotalIngresos = sum(Precio * Existencias)
    from Productos;

    -- Insertar el total de ingresos en la tabla RegistrosIngresos
    insert into RegistrosIngresos (Fecha, TotalIngresos)
    values (getdate(), @TotalIngresos);
end;
go

--Prueba Procedure Guardar la suma en la tabla
exec SP3_GuardarTotalIngresos;
go
select * from RegistrosIngresos
go

--SP4 Registrar sin Identity, si esta vacio se inserta el ID num 1
create procedure SP4_InsertarSinIdentity
	@Nombre varchar(50),
	@Marca varchar(50),
	@Precio int,
	@Existencias int
as
begin
	declare @contador int;
	if not exists (select 1 from Productos) --si esta vacia inserta registro con ID1
	begin
		set @contador= 1; 
	end
	else
	begin
	select @contador = (select top 1 ID from Productos order by ID desc) + 1;
	end
	set identity_insert Productos on; --Habilita el insert ide ID (Identity)
	insert into Productos (ID, Nombre, Marca, Precio, Existencias) values (@contador, @Nombre, @Marca, @Precio, @Existencias);
	select * from Productos;
	set identity_insert Productos off; --Desabilita
end;
go

--Preba Procedure Insertar sin Identity
exec SP4_InsertarSinIdentity 'Producto D1', 'Marca4', 400, 25;
go
select * from Productos
go

--Usar Procedure para operaciones CRUD

--CRUD Solo una tabla

--SP5 Create Cliente
create procedure SP5_CrearCliente
    @Nombre varchar(50),
	@Direccion varchar(50),
	@Telefono varchar(50),
    @Correo varchar(50)
as
begin
    insert into Clientes (Nombre, Direccion, Telefono, Correo)
    values (@Nombre, @Direccion, @Telefono, @Correo);
end;
go

--Prueba Prcedure Create Cliente
exec SP5_CrearCliente 'FabCA', 'abc123', '123456789', 'FabCA@gmail.com'
go

--SP6 Read Cliente
create procedure SP6_ReadCliente
as
begin
	select * from Clientes;
end;
go

--Prueba Procedure Read cliente
exec SP6_ReadCliente
go

--SP7 Update Cliente
create procedure SP7_ActualizarCliente
	@ID int,
    @Nombre varchar(50),
	@Direccion varchar(50),
	@Telefono varchar(50),
    @Correo varchar(50)
as
begin
    update Clientes
    set Nombre = @Nombre, Direccion = @Direccion, Telefono = @Telefono, Correo = @Correo where ID = @ID;
end;
go

--Prueba Procedure Update Cliente
exec SP7_ActualizarCliente 6, 'Fab', 'Santa Virtudes', '477-138-7230', 'FabCA06.2@gmail.com'
go

--SP8 Delete Cliente
create procedure SP8_DeleteCliente
	@ID int
as
begin
	delete from Clientes
	where ID = @ID;
end;
go

--Prueba Procedure Delete Cliente
exec SP8_DeleteCliente 6
go

--CRUD Cualquier tabla

--SP9 Crear registro cualquier tabla
create procedure SP9_CreateRegistroAll
	@nombreTabla varchar(50),
	@columnas varchar(max),
	@valores nvarchar(max)
as
begin
	declare @accion varchar(max)
	set @accion = 'insert into ' + @nombreTabla + ' (' + @columnas + ') values (' + @valores + ');';
	exec (@accion)
end;
go

--Prueba Procedure Create Cliente All
exec SP9_CreateRegistroAll 
	@nombreTabla = 'Clientes', 
	@columnas = 'Nombre, Direccion, Telefono, Correo', 
    @valores = '''Juan Perez'', ''123 Main St'', ''123-456-7890'', ''juan.perez@example.com''';
go

--SP10 Read registro cualquier tabla
create procedure SP10_ReadRegistroAll
	@nombreTabla varchar(50)
as
begin
	declare @accion varchar(max)
	set @accion = 'select * from ' + @nombreTabla;
	exec (@accion)
end;
go

--Prueba Procedure Read Cliente All
exec SP10_ReadRegistroAll 'Clientes'
go

--SP11 Update registro cualquier tabla
create procedure SP11_UpdateRegistroAll
	@nombreTabla varchar(50),
	@columnas_valores varchar(max),
	@condicion varchar(50)
as
begin
	declare @accion varchar(max)
	set @accion = 'update ' + @nombreTabla + ' set ' + @columnas_valores + ' where ' + @condicion + ';';
	exec (@accion)
end;
go

--Prueba Procedure Update cualquier tabla
exec SP11_UpdateRegistroAll 
    @nombreTabla = 'Clientes', 
    @columnas_valores = 'Nombre = ''Nuevo Nombre'', Direccion = ''Nueva Direccion''', 
    @condicion = 'ID = 1';
go

--SP12 Delete registro cualquier tabla
create procedure SP12_DeleteRegistroAll
	@nombreTabla varchar(50),
	@condicion varchar(50)
as
begin
	declare @accion varchar(max)
	set @accion = 'delete from ' + @nombreTabla + ' where ' + @condicion + ';';
	exec (@accion)
end;
go

--Prueba Procedure Delete cualquier tabla
exec SP12_DeleteRegistroAll 'Ventas', 'ID = 8'
go

--SP13 info Clientes y productos mediante join
create procedure SP13_ClientesYPedidos
as

begin
    select c.ID as ClienteID, c.Nombre, c.Direccion, c.Telefono, c.Correo, 
           v.ID as VentaID, p.Nombre as ProductoNombre, p.Marca, p.Precio, p.Existencias
    from Clientes c
    join Ventas v on c.ID = v.ClienteID
    join Productos p on v.ProductoID = p.ID;
end;
go

--Prueba Procedure Clientes y productos
exec SP13_ClientesYPedidos
go

--PROCEDIMIENTO AVANZADO
--Crea un procedimiento almacenado avanzado que realice las siguientes funciones:
--    1.  Reciba como entrada:
--    •   El nombre del producto (@Producto)
--    •   La categoría (@Categoria)
--    •   La cantidad (@Cantidad)
--    •   El precio unitario (@PrecioUnitario)
--    2.  Antes de insertar el producto en la tabla Ventas:
--    •   Si la cantidad o el precio es menor o igual a 0,
--    el procedimiento debe cancelar la operación y devolver un mensaje de error.
--    •   Si el producto ya existe en la misma categoría,
--    el procedimiento debe sumar la cantidad en lugar de insertar una nueva fila.
--    3.  Devuelva como salida:
--    •   El Id de la venta recién insertada o actualizada (@IdVentaSalida).
--    •   Un mensaje de confirmación (@Mensaje)

create procedure SP14_RegistrarVenta
    @Producto varchar(50),
    @Categoria varchar(50),
    @Cantidad int,
    @PrecioUnitario int,
    @IdVentaSalida int output,
    @Mensaje nvarchar(255) output
as
begin
    -- Verificar si la cantidad o el precio es menor o igual a 0
    if @Cantidad <= 0 OR @PrecioUnitario <= 0
    begin
        set @Mensaje = 'Error: La cantidad y el precio unitario deben ser mayores a 0.'
        return;
    end
    declare @ProductoID int;
    declare @EmpleadoID int = 1; -- Asumimos un EmpleadoID por defecto
    declare @ClienteID int = 1; -- Asumimos un ClienteID por defecto
    declare @Fecha date = getdate();
    -- Verificar si el producto ya existe en la misma categoría
    select @ProductoID = ID
    from Productos
    where Nombre = @Producto and Marca = @Categoria;
    if @ProductoID is not null
    begin
        -- El producto ya existe, sumar la cantidad en lugar de insertar una nueva fila
        update Productos
        set Existencias = Existencias + @Cantidad
        where ID = @ProductoID;
        -- Registrar la venta
        insert into Ventas (Fecha, EmpleadoID, ClienteID, ProductoID)
        values (@Fecha, @EmpleadoID, @ClienteID, @ProductoID);
        -- Obtener el ID de la venta recién insertada
        select @IdVentaSalida = scope_identity();
        set @Mensaje = 'Venta actualizada exitosamente.';
    end
    else
    begin
        -- El producto no existe, insertar un nuevo registro en la tabla Productos
        insert into Productos (Nombre, Marca, Precio, Existencias)
        values (@Producto, @Categoria, @PrecioUnitario, @Cantidad);
        -- Obtener el ID del nuevo producto
        select @ProductoID = scope_identity();
        -- Registrar la venta
        insert into Ventas (Fecha, EmpleadoID, ClienteID, ProductoID)
        values (@Fecha, @EmpleadoID, @ClienteID, @ProductoID);
        -- Obtener el ID de la venta recién insertada
        select @IdVentaSalida = scope_identity();
        set @Mensaje = 'Venta registrada exitosamente.';
    end
end;
go

--FUNCIONES

--Tabla valor

--Fun 1 Obtener los productos de cada categoria
create function fun1_ObtenerProductosPorCategoria (@Categoria varchar(50))
returns table --funcion tabla
as
return (
    select p.ID as ProductoID, p.Nombre, p.Precio
    from Productos p
    where p.Marca = @Categoria
);
go

--Prueba fun Obtener productos por categoria
select * from fun1_ObtenerProductosPorCategoria('Marca1');
go

--Fun 2 Obtener ventas por cliente
create function fun2_Obtenerventasporcliente (@clienteid int)
returns table
as
return (
    select v.ID as VentaID, v.Fecha, v.EmpleadoID, v.ProductoID, p.Nombre as ProductoNombre, p.Precio
    from Ventas v
    join Productos p on v.ProductoID = p.ID
    where v.ClienteID = @clienteid
);
go

--Prueba fun obtener ventas por cliente 
select * from fun2_obtenerventasporcliente(1);
go

--Fun 3 Obtener estimaciones por empleado
create function fun3_obtenerestimacionesporempleado (@empleadoid int)
returns table
as
return (
    select e.ID as EstimacionID, e.ProductoID, p.Nombre as ProductoNombre, e.Precio_Total
    from Estimaciones e
    join Productos p on e.ProductoID = p.ID
    where e.EmpleadoID = @empleadoid
);
go

--Prueba fun obtener esimaciones
select * from fun3_obtenerestimacionesporempleado(1);
go

--Funciones escalares

--Fun 4 Calcular total pedido
create function fun4_calculartotalventa (@VentaID int)
returns decimal(10, 2)
as
begin
    declare @Total decimal(10, 2);
    select @Total = sum(p.Precio)
    from Ventas v
    join Productos p on v.ProductoID = p.ID
    where v.ID = @VentaID;
    return @Total;
end;
go

--prueba imprimir la total venta
declare @Total DECIMAL(10, 2);
SELECT @Total = dbo.fun4_calculartotalventa(4);
PRINT @Total;
go

--Fun 5 Numero de ventas por Empleado
create function fun5_ObtenerNumeroVentasEmpleado(@EmpleadoID int)
returns int
as
begin
    declare @NumeroVentas int;
    select @NumeroVentas = count(*)
    from Ventas
    where EmpleadoID = @EmpleadoID;
    return @NumeroVentas;
end;
go

--prueba obtener numero de ventas
print dbo.fun5_ObtenerNumeroVentasEmpleado(1);

--Extra: Comandos para eleminar tablas, triggers, procedures y funciones
--drop table Empleados_log;
--drop table Ventas;
--drop table Estimaciones;
--drop table Productos;
--drop table Clientes;
--drop table Empleados;

--drop trigger tgr_AfterInsertEmpleado;
--drop trigger trg2_AfterUpdateEmpleado;
--drop trigger trg3_AfterDeleteEmpleado;
--drop trigger tgr4_PrevenirDeleteEmpleado;
--drop trigger tgr5_NoNombreVacio;
--drop trigger tgr6_PrevenirUpdateTelefono;

--drop procedure SP1_ConseguirPrecio
--drop procedure SP2_CalcularTotalIngresos
--drop procedure SP3_GuardarTotalIngresos
--drop procedure SP4_InsertarSinIdentity
--drop procedure SP5_CrearCliente
--drop procedure SP6_ReadCliente
--drop procedure SP7_ActualizarCliente
--drop procedure SP8_DeleteCliente
--drop procedure SP9_CreateRegistroAll
--drop procedure SP10_ReadRegistroAll
--drop procedure SP11_UpdateRegistroAll
--drop procedure SP12_DeleteRegistroAll
--drop procedure SP13_ClientesYPedidos
--drop procedure SP14_RegistrarVenta

--drop function fun1_ObtenerProductosPorCategoria
--drop function fun2_Obtenerventasporcliente
--drop function fun3_obtenerestimacionesporempleado
--drop function fun4_calculartotalventa
--drop function fun5_ObtenerNumeroVentasEmpleado