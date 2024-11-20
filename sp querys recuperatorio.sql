-- Ejercicio A
-- Obtener los nombres de las guias que asistieron a “Tercer Grado” (resolver con sub consultas)
select g.nombre
from guias g 
join visitaxguia vg on g.idGuia = vg.idGuia
where vg.idVisita in (
	select idVisita
    from visitas
    where grado = '7°'
);

-- Listar las ciudades (localidades descripción) que nos reservaron en este mes 
-- (resolver con sub consultas).
select l.descripcion
from localidades l
join escuelas e on l.idLocalidad = e.idLocalidad
where e.idEscuela in (
	select idEscuela
    from reservas
    where fechaReserva between '14-11-01' and '24-11-30'
);

-- Escribir una sentencia MySQL para mostrar un ranking de las 10 guias que mas visitas asistieron. 
-- Mostrar el nombre de la guía y la cantidad de visitas que realizaron en total. 
-- NOTA: incluir las guias que no tengan visitas asignadas con el valor 0.
select g.nombre, count(vg.idVisitaXGuia) as cantidad_visitas
from guias g 
left join visitaxguia vg on g.idGuia = vg.idGuia
group by g.nombre
order by count(vg.idVisitaXGuia) desc
limit 10;

-- Mostrar las 3 tipos de visitas que mas se visitaron y las 3 tipos de visitas menos se visitaron, 
-- en una sola consulta.
(
	select tv.descripcion, count(v.idVisita)
	from tipovisita tv
	left join visitas v on tv.idTipoVisita = v.idTipoVisita
	group by tv.descripcion
	order by count(v.idVisita) desc
	limit 3
) union all (
	select tv.descripcion, count(v.idVisita)
	from tipovisita tv
	left join visitas v on tv.idTipoVisita = v.idTipoVisita
	group by tv.descripcion
	order by count(v.idTipoVisita) asc
	limit 3
)

-- Realizar un store procedure que de de alta una escuela y devuelva el codigo identificador del mismo
-- forma fácil
delimiter//
	create procedure altaEscuela(PidEscuela int, Pnombre varchar(50), Pdomicilio varchar(50), 
										PidLocalidad int, out identificador int)
	begin
		insert into escuelas(idEscuela, nombre, domicilio,idLocalidad)
        values
        (PidEscuela, Pnombre, Pdomicilio, PidLocalidad)
        set identificador = last_insert_id()
	end //
delimiter ;

-- forma con verificación
delimiter//
	create procedure altaEscuelaConVerificacion(PidEscuela int, Pnombre varchar(50), 
								Pdomicilio varchar(50), PidLocalidad int, out identificador int)
	begin
		declare aux int default 0
        select e.idEscuela into idEscuela
        from escuelas as e
        where e.nombre = Pnombre
        
        if (aux <> 0) then
			insert into escuelas(idEscuela, nombre, domicilio,idLocalidad)
			values
			(PidEscuela, Pnombre, Pdomicilio, PidLocalidad)
			set identificador = last_insert_id()
		end if 
	end //
delimiter ;

-- cambio de dato con procedure
delimiter //
	create procedure cambioEscuela(Pid int, PnombreAtributo varchar(50), PnuevoNombre varchar(50))
	begin
		update escuelas set PnombreAtributo = PnuevoNombre where  idEscuela = Pid;
    end //
delimiter ;

-- eliminacion de dato con procedure
delimiter //
	create procedure bajaEscuela(Pid int)
    begin
		delete from escuelas where idEscuela = Pid;
    end //
delimiter ;