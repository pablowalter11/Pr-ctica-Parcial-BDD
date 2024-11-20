use cerveceria;

/*1. Mostrar el nombre del ingrediente del que mas  cantidad haya.*/

/*COMO LO RESOLVÍ YO*/
select nombreIngrediente
from ingredientes
where idIngrediente = (
		select idIngrediente,
        count(idIngrediente) as cantidad_ingredientes,
        max(cantidad_ingredientes) as maximo
        from ingredientexreceta
        where idIngrediente = maximo
);

/*COMO LO RESOLVIÓ EL BOT*/
SELECT nombreIngrediente
FROM ingredientes
WHERE idIngrediente = (
    SELECT idIngrediente
    FROM ingredientexreceta
    GROUP BY idIngrediente
    ORDER BY COUNT(idIngrediente) DESC
    LIMIT 1
);

/*2. Mostrar las Recetas que contengan un numero igual o menor  al promedio total de ingredientes*/

/*COMO LO HAGO YO*/
select *
from recetas
where idReceta = (
	select idReceta, avg(idIngrediente)
    from ingredientexreceta
    where count(idIngrediente) <= avg(idIngrediente)
);

/*COMO LO RESOLVIÓ EL BOT*/
select r.* 
from recetas r
where (
	select count(i.idIngrediente)
    from ingredientexreceta i
    where i.idIngrediente = r.idReceta
) >= (
	select avg(cantidad_ingredientes)
    from (
		select count(idIngrediente) as cantidad_ingredientes
        from ingredientexreceta
        group by idReceta
    ) as subquery
);

/*3. Mostrar las Recetas que contengan en si,  los primeros 3 ingredientes.*/

/*COMO LO HAGO YO*/
select r.*
from recetas r
where idReceta in (
	select ixr.idReceta
    from ingredientexreceta ixr
	where ixr.idIngrediente in (
		select i.idIngrediente
        from ingredientes i
        group by idIngrediente
        order by idIngrediente asc
        limit 3
    )
);

/*COMO LO RESOLVIÓ EL BOT*/
select r.*
from recetas r
where idReceta in (
	select ixr.idReceta
    from ingredientexreceta ixr
	where ixr.idIngrediente in (
		select i.idIngrediente
        from ingredientes i
        group by idIngrediente
        order by idIngrediente asc
    )
	GROUP BY ixr.idReceta
    HAVING COUNT(ixr.idIngrediente) = 3
);

/*4. Listar las Cervezas que en su Receta contengan la mayor  cantidad de Ingredientes. 
Tomamos los 3 primeros.*/
select c.*
from cervezas c
where idCerveza = (
	select r.idCerveza 
    from recetas r
    where r.idReceta = (
		select ixr.idReceta
        from ingredientexreceta ixr
        group by count(ixr.idReceta)
        order by count(ixr.idReceta) desc
        limit 3
    )
);

/*5. Mostrar las Receta con el ID 3, junto con la cantidad de Ingredientes que posee 
y en otra columna el promedio de  ingredientes General.*/

/*6. Mostrar las Recetas que superen el Promedio de ingredientes general (Simular Having).*/