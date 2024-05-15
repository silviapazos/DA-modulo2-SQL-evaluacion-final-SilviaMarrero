USE sakila; 

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. 

SELECT title
FROM film; 

-- Compruebo que no haya duplicados con DISTINCT: se utiliza para seleccionar valores únicos de una columna
SELECT DISTINCT title
FROM film; 


-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".  

SELECT title, rating
FROM film
WHERE rating = "PG-13";


-- 3.Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. -----------------------------------------------

SELECT title, description AS descripción 
FROM film 
WHERE description LIKE '%amazing%'; 


-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. 

SELECT title, length
FROM film
WHERE length > 120;


-- 5. Recupera los nombres de todos los actores.

SELECT first_name, last_name      -- Tambien se podia haber hecho un CONCATE
FROM actor;  


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. 

SELECT first_name, last_name
FROM actor 
WHERE last_name = "Gibson";           -- Se podia haber utilizado un LIKE '%Gibson%'


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. 

SELECT actor_id, CONCAT(first_name," ", last_name) AS Nombre
FROM actor
WHERE actor_id BETWEEN 10 AND 20; 


-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title, rating 
FROM film 
WHERE rating NOT IN ('R', 'PG-13'); 



-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento. 

SELECT rating, COUNT(title) AS numero_peliculas
FROM film
GROUP BY rating; 

-- COMPRUEBO
SELECT *
FROM film
WHERE rating = "PG-13";            -- Escogemos por ejemplo esta clasificacion, pero podiamos haber escogido cualquier otra para comprobarlo



-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
--     su nombre y apellido junto con la cantidad de películas alquiladas. 

-- Se utiliza la función agregada COUNT que junto al GROUP BY nos dará la columna de cantidad de peliculas alquiladas por cada cliente

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS "nº peliculas alquiladas por cliente"          
FROM customer
INNER JOIN rental ON customer.customer_id = rental.customer_id               -- Usamos INNER JOIN porque necesitamos datos de 2 tablas
GROUP BY customer.customer_id; 

-- COMPRUEBO
SELECT customer_id, rental_id
FROM rental
WHERE customer_id = "6";                 -- Ejemplo: me trae 28 rows por lo que concuerda con el resultado anterior

  
  
-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT category.name AS "Category Name", COUNT(rental.rental_id)                               -- Para extraer el rental_id necesitaré llegar a la tabla que lo contiene
FROM category                                                                                  -- Desde category -> category id
INNER JOIN film_category ON category.category_id = film_category.category_id                   -- Tenemos que extraer film_id porque lo necesitamos para -> inventory_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id                              
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id                              -- Con inventory_id ya llegamos a la tabla rental
GROUP BY category.name ;



-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating, AVG(length) AS "Duracion media"               -- Para extraer el promedio para cada calsificacion, emplearemos la funcion avanzada AVG junto con el GROUP BY
FROM film
GROUP BY rating;



-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". 

SELECT first_name, last_name, film.title
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id            -- Necesitaremos varios JOIN para llegar desde la tabla actor--> tabla film para extraer title
INNER JOIN film ON film.film_id = film_actor.film_id
WHERE film.title = "Indian Love";



-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title, description
FROM film
WHERE description REGEXP 'dog' OR 'cat';            -- Usamoa REGEX para encontrar estos patrones



-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor 

-- USAREMOS -> LEFT JOIN:  se devuelven todos los registros de actores (tabla left) independientemente de si están asociadas a alguna pelicula (tabla right). 
-- Hay que agrupar por actor para calcular el numero total de peliculas que ha hecho cada uno.

SELECT actor.actor_id, CONCAT(actor.first_name, " " ,actor.last_name) AS "Nombre actor/actriz", COUNT(film_actor.film_id) AS "Nº peliculas"
FROM actor 
LEFT JOIN film_Actor ON actor.actor_id = film_actor.actor_id          -- Habrá actores que salgan en varias peliculas y por tanto se repitan en esta tabla, por lo que hago GROUP BY 
GROUP BY CONCAT(actor.first_name, " " ,actor.last_name);

-- Otra forma de hacerlo ------------
SELECT actor.actor_id, CONCAT(actor.first_name, " " ,actor.last_name) AS "Nombre actor/actriz", COUNT(film_actor.film_id) AS "Nº peliculas"
FROM actor 
RIGHT JOIN film_Actor ON actor.actor_id = film_actor.actor_id
GROUP BY CONCAT(actor.first_name, " " ,actor.last_name)
HAVING COUNT(film_actor.film_id) = 0;                         -- Con Numero de peliculas = 0 no hay ninguna pelicula por lo que la lista sale vacia



-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title, release_year 
FROM film 
WHERE release_year BETWEEN 2005 AND 2010; 



-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family" 

SELECT film.title AS "Film Title", category.name AS "Category"
FROM film 
INNER JOIN film_category ON film.film_id = film_category.film_id                  -- Necesito category_id para llegar a category name, por lo que necesito unos varias tablas
INNER JOIN category ON category.category_id = film_category.category_id
WHERE category.name = "Family";



-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. 

SELECT CONCAT(actor.first_name, " ", actor.last_name) AS "Nombre actor/actriz", COUNT(film_actor.film_id) AS "Número de peliculas" 
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY CONCAT(actor.first_name, " ", actor.last_name)
HAVING COUNT(film_actor.film_id) > 10;


-- COMPRUEBO
SELECT actor_id
FROM film_actor 
WHERE actor_id = 4;             -- Ejemplo: extrae 22 rows, por tanto mayor a 10



-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT film.title, film.rating, film.length 
FROM film 
WHERE film.rating = "R" AND film.length > 120;                -- Usaremos AND para añadir 2 condiciones al WHERE 



-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
--     minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT  category.name AS "Nombre categoría", AVG(film.length) AS "Duración media"
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film.film_id = film_category.film_id
GROUP BY category.name
HAVING AVG(film.length) > 120; 


-- 21 Encuentra los actores que han actuado en al menos 5 películas y
-- muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT CONCAT(actor.first_name, " ", actor.last_name) AS "Nombre actor/actriz", COUNT(film_actor.film_id) AS "Número de peliculas" 
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY CONCAT(actor.first_name, " ", actor.last_name)
HAVING COUNT(film_actor.film_id) >= 5;




-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una
-- subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
-- las películas correspondientes.

-- ESTE DA 955 
WITH duracion_alquiler AS(                                                                                   -- Creo tabla de duracion del alquiler >5 dias, para usar en consulta principal
                         SELECT rental_id, inventory_id, datediff(return_date, rental_date) AS dias_alquiler
                         FROM rental 
                         WHERE datediff(return_date,rental_date) >5)                                        -- DATEDIFF: es una funcion que sirve para calcular diferencia entre fechas

SELECT DISTINCT(film.title)                                                                                 -- He optado por poner DISTINCT porque las peliculas de repetian, 
FROM film                                                                                                   -- dado que cada cada film_id tiene varios inventory_id, tienen varias veces en el inventario la misma pelicula
INNER JOIN inventory ON inventory.film_id = film.film_id                                                    -- Hasta aqui lo que me da son las peliculas en film que estan en inventario disponibles ahora mismo
INNER JOIN duracion_alquiler AS dua  ON inventory.inventory_id = dua.inventory_id                           -- Aqui selecciono las pelis que estan en inventario y cuya duracion >5
WHERE dua.dias_alquiler > 5;                                                                                -- doble check




-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la
	-- categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en
	-- películas de la categoría "Horror" y luego exclúyelos de la lista de actores 
    
   
-- ACTORES QUE PARTICIPAN EN PELIS DE "HORROR"							
    
WITH peliculas_horror AS (                                                                                 -- Creo la tabla de peliculas de horror para usarla en la consulta principal
						  SELECT category.name AS "nombre_categoria", film_category.film_id                -- ya filtrado y añadiendo el film_id que tambien lo necesitaré despues para unir con la tabla "actor"
						  FROM category                                                                    
						  INNER JOIN film_category ON category.category_id = film_category.category_id
						  WHERE name = "Horror")         -- Peliculas categoria horror


SELECT first_name,last_name, H.nombre_categoria                         -- La consulta principal me va a traer los nombres de los actores que participan en pelis de "horror"
FROM actor 
INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
INNER JOIN peliculas_horror AS H ON H.film_id = film_actor.film_id;    -- film_id de peliculas_horror son las peliculas de categoria horror, por lo que aqui estoy extrayendo directamente las pelis de horror que corresponden a estos actores



-- TODOS LOS ACTORES, DE LOS QUE SE HA ELIMINADO LOS ACTORES DE PELICULAS DE "HORROR"

WITH categorias AS ( 
						  SELECT category.name AS "nombre_categoria", film_category.film_id               -- Creo esta tabla con todos los id de peliculas y su respectiva categoria
						  FROM category
						  INNER JOIN film_category ON category.category_id = film_category.category_id
						  )


SELECT first_name,last_name, categorias.nombre_categoria              -- Salen todos los actores junto a todas las categorias en las que ha trabajado
FROM actor 
INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
INNER JOIN categorias ON categorias.film_id = film_actor.film_id      -- Hago el JOIN con la tabla creada en la CTE
WHERE actor.actor_id NOT IN(  
                            SELECT fa.actor_id                        -- SUBCONSULTA: Son los actores que participan en peliculas de categoria "horror"
                            FROM film_actor AS fa
                            INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
                            INNER JOIN category ON category.category_id = fc.category_id 
                            WHERE  category.name = "Horror"); 
                            
                            
                          
                          
						   
-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT film.title, c.name AS nombre_categoria , film.length
FROM film
INNER JOIN film_category AS fc ON fc.film_id = film.film_id 
INNER JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = "Comedy" AND  film.length > 180; 



-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.


WITH pareja_actores AS (
                        SELECT fa1.actor_id AS actor1, fa2.actor_id AS actor2, COUNT(*) AS pelis_juntos
                        FROM film_actor AS fa1 
                        JOIN film_actor AS fa2 ON fa1.film_id =fa2.film_id           -- LLamamos a la misma tabla con otro nombre, como si fuera una distinta para volver a extraer nombres de actores
                        GROUP BY fa1.actor_id , fa2.actor_id                         -- Agrupamos por parejas, son un pack
                        HAVING fa1.actor_id <> fa2.actor_id                          -- Evitamos que haya actores haciendo "match" con ellos mismo, pue sno tiene sentido
                        )
                        
SELECT CONCAT(a1.first_name, a1.last_name) AS ACTOR_1, CONCAT(a2.first_name, a2.last_name) AS ACTOR_2, pa.pelis_juntos
FROM pareja_actores AS pa                          -- Llamamos a la nueva tabla creada
JOIN actor AS a1 ON a1.actor_id = pa.actor1        -- Juntamos con la tabla actores para extraer el nombre, de momento solo tenemos el id
JOIN actor AS a2 ON a2.actor_id = pa.actor2;       -- Creamos nueva tabla de actor y juntamos, para sacar nombres al segundo actor
 



