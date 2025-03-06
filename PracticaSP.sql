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

