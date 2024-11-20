-- 1.2.7.1 Con operadores básicos de comparación
-- 1. Devuelve un listado con todos los empleados que tiene el departamento de Sistemas. 
--  (Sin utilizar INNER JOIN).

select *
from empleado
where codigo_departamento = (
	select codigo
    from departamento
    where nombre = 'Sistemas'
);

-- 2. Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada.
select nombre, presupuesto
from departamento
group by nombre, presupuesto
order by max(presupuesto) desc
limit 1;

select nombre, presupuesto
from departamento
where presupuesto = (
	select max(presupuesto)
    from departamento
);

-- 3. Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada.
select nombre, presupuesto
from departamento
group by nombre, presupuesto
order by min(presupuesto) asc
limit 1;

select nombre, presupuesto
from departamento
where presupuesto = (
	select min(presupuesto)
    from departamento
);

-- 1.2.7.2 Subconsultas con ALL y ANY
-- 4. Devuelve el nombre del departamento con mayor presupuesto y la cantidad
-- que tiene asignada. Sin hacer uso de MAX, ORDER BY ni LIMIT.
select nombre, presupuesto
from departamento
where presupuesto >= all (
	select presupuesto
    from departamento
);

-- 5. Devuelve el nombre del departamento con menor presupuesto y la cantidad
-- que tiene asignada. Sin hacer uso de MIN, ORDER BY ni LIMIT.
select nombre, presupuesto
from departamento
where presupuesto <= all (
	select presupuesto
    from departamento
);

-- 6. Devuelve los nombres de los departamentos que tienen empleados
-- asociados. (Utilizando ALL o ANY).
select nombre
from departamento
where codigo = any (
	select codigo_departamento
    from empleado
);

-- 7. Devuelve los nombres de los departamentos que no tienen empleados
-- asociados. (Utilizando ALL o ANY)
select nombre
from departamento
where codigo <> all (
	select codigo_departamento
    from empleado
);

-- 1.2.7.3 Subconsultas con IN y NOT IN
-- 8. Devuelve los nombres de los departamentos que tienen empleados
-- asociados. (Utilizando IN o NOT IN).
select nombre
from departamento
where codigo in (
	select codigo_departamento
    from empleado
);

-- 9. Devuelve los nombres de los departamentos que no tienen empleados
-- asociados. (Utilizando IN o NOT IN).
select nombre
from departamento
where codigo not in (
	select codigo_departamento
    from empleado
);

-- 1.2.7.4 Subconsultas con EXISTS y NOT EXISTS
-- 10.Devuelve los nombres de los departamentos que tienen empleados
-- asociados. (Utilizando EXISTS o NOT EXISTS).
select nombre
from departamento d
where exists (
	select *
    from empleado
    where codigo_departamento = d.codigo
);

-- 11. Devuelve los nombres de los departamentos que tienen empleados
-- asociados. (Utilizando EXISTS o NOT EXISTS).
select nombre
from departamento d
where not exists (
	select *
    from empleado
    where codigo_departamento = d.codigo
);






