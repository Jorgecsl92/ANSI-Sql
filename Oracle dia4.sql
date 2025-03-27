-- EJERCICIO DE CONSULTAS DE COMBINACION
-- 1.Seleccionar el apellido, oficio, salario, numero de departamento y su nombre de todos los empleados cuyo salario sea mayor de 300000
select emp.apellido, emp.oficio, emp.salario, emp.dept_no, dept.dnombre
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by emp.apellido, emp.oficio, emp.salario, emp.dept_no, dept.dnombre
having emp.salario > 300000;


-- 2.Mostrar todos los nombres de Hospital con sus nombres de salas correspondientes
select hospital.nombre as nombre_hospital, sala.nombre as nombre_sala
from hospital
inner join sala
on hospital.hospital_cod = sala.hospital_cod
group by hospital.nombre, sala.nombre;


-- 3.Calcular cuántos trabajadores de la empresa hay en cada ciudad
select count (emp.emp_no) as empleados, dept.loc
from emp
right join dept
on emp.dept_no = dept.dept_no 
group by dept.loc;


-- 4.Visualizar cuantas personas realizan cada oficio en cada departamento mostrando el nombre del departamento.
select count (emp.emp_no) as empleados, emp.oficio, dept.dnombre
from emp
right join dept
on emp.dept_no = dept.dept_no
group by emp.oficio, dept.dnombre;


-- 5.Contar cuantas salas hay en cada hospital, mostrando el nombre de las salas y el nombre del hospital
select count (sala.sala_cod) as salas, sala.nombre as nombresala, hospital.nombre as nombrehospi
from sala
inner join hospital
on sala.hospital_cod = hospital.hospital_cod
group by sala.nombre, hospital.nombre;


-- 6. Queremos saber cuántos trabajadores se dieron de alta entre el año 1997 y 1998 y en qué departamento
select count (emp.emp_no) as altas, dept.dnombre
from emp
inner join dept 
on emp.dept_no = dept.dept_no
where emp.fecha_alt between '01/01/1997' and '01/01/1998'
group by dept.dnombre;


-- 7. Buscar aquellas ciudades con cuatro o más personas trabajando.
select count (emp.emp_no) as personas, dept.loc
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by dept.loc
having count(emp.emp_no) > 4;


-- 8. Calcular la media salarial por ciudad. Mostrar solamente la media para Madrid y Sevilla.
select avg(emp.salario) as mediasalarios, dept.loc as ciudad
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by dept.loc
having dept.loc in ('MADRID', 'SEVILLA');


-- 9. Mostrar los doctores junto con el nombre de hospital en el que ejercen, la dirección y el teléfono del mismo
select doctor.apellido as doctores, hospital.nombre, hospital.direccion, hospital.telefono
from doctor
inner join hospital 
on doctor.hospital_cod = hospital.hospital_cod
group by doctor.apellido, hospital.nombre, hospital.direccion, hospital.telefono;


-- 10. Mostrar los nombres de los hospitales junto con el mejor salario de los empleados de la plantilla de cada hospital
select hospital.nombre, max(plantilla.salario) as salariomaximo
from hospital
inner join plantilla
on hospital.hospital_cod = plantilla.hospital_cod
group by hospital.nombre;


-- 11. Visualizar el Apellido, función y turno de los empleados de la plantilla junto con el nombre de la sala y el nombre del hospital con el teléfono
-- por cada tabla un join y un on
select plantilla.apellido, plantilla.funcion, plantilla.turno, sala.nombre as nombresala, hospital.nombre as nombrehospital, hospital.telefono
from plantilla
inner join hospital
on plantilla.hospital_cod = hospital.hospital_cod
inner join sala
on hospital.hospital_cod = sala.hospital_cod
and plantilla.sala_cod = sala.sala_cod;


-- 12. Visualizar el máximo salario, mínimo salario de los Directores dependiendo de la ciudad en la que trabajen. Indicar el número total de directores por ciudad.
select count(emp.emp_no) as directores, dept.loc as ciudad, max(emp.salario) as salariomaximo, min(emp.salario) as salariominimo
from emp
inner join dept
on emp.dept_no = dept.dept_no
where oficio = 'DIRECTOR'
group by dept.loc;


-- 13. Averiguar la combinación de que salas podría haber por cada uno de los hospitales.
select sala.nombre as nombresala, hospital.nombre as nombrehospital
from sala
cross join hospital;

-- SUBCONSULTAS
-- Son consultas que necesita del resultado de otra consulta para poder ser ejecutadas. No som autonomas, necesita de algun valor.
-- No importa el nivel de anidamiento de subconsultas, aunque pueden ralentizar la respuesta.
-- Generan bloqueos en consultas selec, lo que tambine ralentiza las respuestas.
-- VISUALIZAR LOS DATOS DEL EMPLEADO QUE MAS COBRA DE LA EMPRESA (EMP)
select max(salario) from emp;
--650000
select * 
from emp 
where salario = 650000;
-- SE EJECUTAN LAS DOS CONSULTAS A LA VEZ Y, SE ANIDA EL RESULTADO DE UNA CONSULTA CON LA IGUALDAD DE LA RESPUESTA DE OTRA CONSULTA
-- LAS SUNCONSULTAS VAN ENTRE PARENTESIS
select * 
from emp
where salario=(select max(salario) from emp);
-- MOSTRAR LOS EMPLEADOS QUE TIENE EN EL MISMO OFICIO QUE EL EMPLEADO gil
select *
from emp
where oficio= 
(select oficio from emp where apellido='gil');
-- MOSTRAR LOS EMPLEADOS QUE TIENE EN EL MISMO OFICIO QUE EL EMPLEADO gil Y QUE COBRE MENOS QUE jimenez
select *
from emp
where oficio = (select oficio from emp where apellido='gil')
and salario <(select salario from emp where apellido='jimenez');
-- MOSTRAR LOS EMPLEADOS QUE TIENE EN EL MISMO OFICIO QUE EL EMPLEADO gil Y el mismo oficio de jimenez
-- SI UNA SUBCONSULTA DEVUELVE MAS DE UN VALOR, SE UTILIZA EL OPERADOR in
select *
from emp
where oficio in (select oficio from emp where apellido='gil' or apellido='jimenez');
-- POR SUPESTO, PODEMOS UTILIZAR SUBCONSULTAS PARA OTRAS TABLAS (NORMALMENTE SI NO TIENEN RELACION ENTRE SI MEDIANTE UNA FOREIGN KEY)
-- MOSTRAR EL APELLIDO Y EL OFICIO DE LOS EMPLEADOS DEL DEPARTAMENTO DE MADRID
select apellido, oficio from emp where dept_no =
(select dept_no from dept where loc='MADRID'); -- INCORRECTA

select emp.apellido, emp.oficio
from emp
inner join dept
on emp.dept_no=dept.dept_no
where dept.loc='MADRID'; -- CORRECTA, EFICIENCIA COMPLETA

-- CONSULTAS union
-- MUESTRAN, EN UN MISMO CURSOR, UN MISMO CONJUNTO DE RESULTADOS. ESTAS CONSULTAS SE UTILIZAN COMO CONCEPTO, NO COMO RELACION.
-- DEBEMOS SEGUIR TRES REGLAS:
-- 1. LA PRIMERA CONSULTA ES LA JEFA
-- 2. TODAS LAS CONSULTAS DEBEN TENER EL MISMO NUMERO DE COLUMNAS
-- 3. TODAS LAS COLUMNAS DENEN TENER EL MISMO TIPO DE DATO ENTRE SI
-- EN NUESTTRA BASE DE DATOS, TENEMOS DATOS DE PERSONAS EN DIFERENTES TABLAS EMP, PLANTILLA Y DOCTOR
select apellido, oficio, salario from emp
union
select apellido, funcion, salario from plantilla
union
select apellido, especialidad, salario from doctor;

-- POR SUPUESTO PODEMOS ORDENAR SIN PROBLEMAS
select apellido, oficio, salario as sueldo from emp
union
select apellido, funcion, salario from plantilla
union
select apellido, especialidad, salario from doctor
order by 3; -- SE UTILIZA SIEMPRE EL NUMERANDO EN EL order by, YA QUE SI PONEMOS UN ALIAS NO FUNCIONA

-- PODEMOS FILTRAR LOS DATOS DE LA CONSULTA
-- MOSTRAR LOS DATOS DE LAS PERSONAS QUE COBREN MENOS DE 300000
select apellido, oficio, salario as sueldo from emp
where salario < 300000
union
select apellido, funcion, salario from plantilla
where salario < 300000
union
select apellido, especialidad, salario from doctor
where salario < 300000 -- where SE TIENE QUE PONER EN CADA CONSULTA, CADA where es independiente A CADA union
order by 1;

-- union ELIMINA LOS RESULTADOS REPETIDOS
select apellido, oficio from emp
union -- SI QUEREMOS REPETIDOS DEBEMOS UTILIZAR union all
select apellido, oficio from emp;



