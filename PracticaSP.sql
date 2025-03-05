/*Crea un procedimiento almacenado avanzado que realice las siguientes funciones:
    1.  Reciba como entrada:
    •   El nombre del producto (@Producto)
    •   La categoría (@Categoria)
    •   La cantidad (@Cantidad)
    •   El precio unitario (@PrecioUnitario)
    2.  Antes de insertar el producto en la tabla Ventas:
    •   Si la cantidad o el precio es menor o igual a 0,
    el procedimiento debe cancelar la operación y devolver un mensaje de error.
    •   Si el producto ya existe en la misma categoría,
    el procedimiento debe sumar la cantidad en lugar de insertar una nueva fila.
    3.  Devuelva como salida:
    •   El Id de la venta recién insertada o actualizada (@IdVentaSalida).
    •   Un mensaje de confirmación (@Mensaje)
*/


	-- if exists (select 1 from table where x)
	--		existe el registro
	--		cantidad+ x
	--			update
	-- else 
	--		No existe el registro
	--		insert

