use simulacro_parcial;

/*
Ejercicio A
*/
/*
1) Obtener los nombres de las guias que asistieron a “Tercer Grado” (resolver con sub consultas)
*/

/*COMO LO RESOLVÍ*/
select nombre
from guias
where idGuia = (
	select idGuia
    from visitaxguia
    where idVisita = (
		select idVisita
        from visitas
        where grado = "3ro"
	)
);

/*EJEMPLO DE RESOLUCIÓN*/
select * 
from visitaxguias as vxg
join guias as g
on vxg.idGuia = g.idGuia
where vxg.idVisita in (
	select idVisita
	from visitas
	where grado = "3ro"
);

/*OTRA FORMA DE RESOLUCIÓN*/
select nombre
from guias as g
join visitaxguia as vxg
on g.idGuia = vxg.idGuia
where vxg.idVisita = (
	select idVisita
    from visitas
    where grado = "4°"
);

select *
from visitaxguia as vxg
join guias as g
on vxg.idGuia = g.idGuia
where vxg.idVisita in (
	select idVisita
	from visitas
	where grado = "3ro"
);

/*
2) Listar las ciudades (localidades descripción) que nos reservaron en este mes (resolver con sub
consultas).
*/

/*COMO LO RESOLVÍ*/
select descripcion
from localidades
where idLocalidad = (
	select idLocalidad
    from escuelas
    where idEscuela = (
		select idEscuela
        from reservas
        where fechaReserva between "2024-10-01" and "2024-10-31"
    )
);

/*OTRA FORMA DE Resolucion*/
select descripcion
from localidades as l
join escuelas as e
on l.idLocalidad = e.idLocalidad
where e.idEscuela in (
	select idEscuela
    from reservas
    where fechaReserva between "2024-11-01" and "2024-11-30"
);

/*
3)
 Escribir una sentencia MySQL para mostrar un ranking de las 10 guias que mas visitas asistieron.
Mostrar el nombre de la guía y la cantidad de visitas que realizaron en total. NOTA: incluir las guias
que no tengan visitas asignadas con el valor 0.
*/

select g.nombre, count(vxg.idGuia) as num_vxg
from guias g
left join visitaxguia vxg 
on g.idGuia = vxg.idGuia
group by g.idGuia, g.nombre
order by num_vxg desc
limit 10;

select *
from guias
where idGuia in (2);

/*
Ejercicio B
4) Mostrar las 3 tipos de visitas que mas se visitaron y las 3 tipos de visitas menos se visitaron,
en una sola consulta
*/

(select tv.descripcion, count(idVisita) as visitasHechas
from tipovisita tv
left join visitas v
on tv.idTipoVisita = v.idVisita
group by tv.descripcion
order by visitasHechas desc
limit 3)	
union all
(select tv.descripcion, count(idVisita) as visitasHechas
from tipovisita tv
left join visitas v
on tv.idTipoVisita = v.idVisita
group by tv.descripcion
order by visitasHechas asc
limit 3)

/*
Ejercicio C
5) Realizar un store procedure que de de alta una escuela y devuelva el codigo identificador del mismo
*/

delimiter //
create procedure altaEscuela(Pnombre varchar(50),Pdomicilio varchar(50),PidLocalidad int, out IdNuevaEscuela int) 
begin 
	insert into escuelas(nombre,domicilio,idLocalidad) values
    (Pnombre,Pdomicilio,PidLocalidad);
	set IdNuevaEscuela = last_insert_id();
end //
delimiter ;

drop procedure altaEscuela;

call altaEscuela('Escuela de Mentira 7','Boulevard Imaginario 422',3,@NuevoId);

select @NuevoId;

select * from escuelas;

/*
Realizar un store procedure que actualice el apellido de la guia cuyo ID es el 4 con el valor
“Rodriguez”
*/

delimiter //
create procedure cambiarApellidoPorId(PnuevoApellido varchar(50),PidGuia varchar(50))
begin
	update guias
    set apellido = PnuevoApellido
    where idGuia = PidGuia;
end //
delimiter ;

drop procedure cambiarApellidoPorId;

call cambiarApellidoPorId('Gómez',4);
select * from guias;

/*
MAS EJERCICIOS
1) Obtener los nombres de los colegios que llevaron estudiantes de “4to ” (resolver con sub
consultas)
*/
select e.nombre 
from escuelas e
join reservas r
on e.idEscuela = r.idEscuela
where r.idReserva = (
	select idReserva
    from visitas
    where grado = '4°'
);
    