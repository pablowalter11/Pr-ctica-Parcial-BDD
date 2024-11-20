-- Obtener los nombres de los productos que se encuentran en el deposito Paso 
-- (resolver con sub consultas)
select p.nombre
from productos p
join stock_productos sp on p.id_producto = sp.id_producto
where sp.id_deposito in (
	select id_deposito
    from depositos
    where nombre like 'Paso'
);

-- Mostrar los productos que su precio es mayor al precio promedio (resolver con sub consultas)
select p.*
from productos p
where precio_unitario > (
	select avg(precio_unitario)
	from productos
);

-- Escribir una sentencia MySQL para mostrar un ranking de las 10 razones sociales que mas se 
-- le vendieron el producto que el Id_Producto es 1234. Mostrar razon social y la cantidad de 
-- productos que se vendieron en total. NOTA: incluir las razones sociales que no tengan ventas 
-- asignados con el valor 0.
select v.razon_social, ifnull(sum(iv.cantidad),0) as 'Cantidad Vendida'
from ventas
left join items_ventas iv on v.id_venta = iv.id_venta
where iv.id_producto = 1234
group by v.razon_social
order by sum(iv.cantidad) desc
limit 10;

-- Mostrar los 3 productos que su stock es el mayor y los 3 productos stock es el menor.
-- Realizarlo todo en una sola consulta.
(
	select p.*
    from productos p 
    left join stock_producos sp on p.id_producto = sp.id_producto
    order by sp.stock desc
    limit 3
) union all (
		select p.*
    from productos p 
    left join stock_producos sp on p.id_producto = sp.id_producto
    order by sp.stock asc
    limit 3
);

-- Mostrar las dos razones sociales que mas se le vendiero en el 2023 y las dos que menos se 
-- les vendieron en el 2023. 
(
	select razon_social, count(id_venta)
	from ventas
	where v.anio = 2023
	group by razon_social
	order by count(id_venta) desc
	limit 3
) union all (
	select razon_social, count(id_venta)
	from ventas
	where v.anio = 2023
	group by razon_social
	order by count(id_venta) desc
	limit 3
);

-- Mostrar los 3 rubros que la sumatoria del precio de sus productos es el mayor y los 3 productos 
-- que la sumatoria de sus productos es la mas económicos todo en una sola consulta.
(
	select r.id_rubro, r.nombre, sum(p.precio_unitario) as suma_productos
    from rubros r 
    left join productos p on r.id_rubro = p.id_rubro
    group by r.id_rubro, r.nombre
    order by suma_productos desc
    limit 3
) union all (
	select r.id_rubro, r.nombre, sum(p.precio_unitario) as suma_productos
    from rubros r 
    left join productos p on r.id_rubro = p.id_rubro
    group by r.id_rubro, r.nombre
    order by suma_productos asc
    limit 3
);

