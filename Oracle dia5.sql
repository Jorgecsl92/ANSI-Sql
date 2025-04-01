-- SELECT TO SELECT
-- ES UNA CONSULTA SOBRE UN CURSOR (select). CUANDO HACEMOS UN select, EN REALIDAD ESTAMOS RECUPERANDO DATOS DE UNA TABLA.
-- ESTE TIPO DE CONSULTAS NOS PERMITEN RECUPERAR DATOS DE UN SELECT YA REALIZADO, LOS where Y DEMAS SE HACEN SOBRE EL CURSOR.
-- SINTAXIS:
select * from
(select TABLA1.CAMPO1 as alias, TABLA1.CAMPO2 from TABLA1
union
select TABLA2.CAMPO1, TABLA.CAMPO2 from TABLA2) CONSULTA
where CONSULTA.alias = 'valor';
-- QUEREMOS MOSTRAR LOS DATOS DE TODAS LAS PERSONAS DE MI BBDD (emp, doctor, plantilla). SOLAMENTE QUEREMOS LOS QUE COBREN MENOS DE 300000
select * from
(select APELLIDO, OFICIO, SALARIO as sueldo from emp
union 
select APELLIDO, FUNCION, SALARIO from PLANTILLA
union
select APELLIDO, ESPECIALIDAD, SALARIO from doctor) consulta
where consulta.sueldo < 300000; 

-- CONSULTA A NIVEL FILA
-- SON CONSULTAS DREADAS OARA DAR FORMA A LA SALIDA DE SALIDA DE DATOS.
-- NO MODIFICAN LOS DATOS DE LA TABLAM LOS MUESTRAN DE OOTRA FORMA SEGUN LO NECESITE.
-- VAN CON PREGUNTAS EN LA CONSULTA
--SINTAXIS:
select CAMPO1, CAMPO2, case CAMPO3
    when 'dato1' then 'valor1'
    when 'dato2' then 'valor2'
    else 'valor3'
end as alias
from TABLA;
-- MOSTRAR LOS APELLIDO DE LA PLANTILLA, PERO CON SU TURNO QUE SE VEA BIEN (MAÑANA, TARDE, NOCHE)
select * from PLANTILLA;
select APELLIDO, FUNCION, case TURNO
    when 'T' then 'TARDE'
    when 'M' then 'MAÑANA'
    when 'N' then 'NOCHE'
end as HORARIO
from PLANTILLA;

-- EVALUAR POR UN OPERADOR (RANGO, MAYOR O MENOR, DISTINTO)
select CAMPO1, CAMPO2, case
    when CAPO3 <= 800 then 'RESULTADO1'
    when CAMPO3 > 800 then 'RESULTADO2'
    else 'RESULTADO3'
end as FORMATO
from TABLA;
-- SALARIOS DE LA PLANTLLA
select APELLIDO, FUNCION, SALARIO, case
    when SALARIO >= 250000 then 'SALARIO CORRECTO'
    when SALARIO >= 170000 and SALARIO < 250000 then 'MEDIA SALARIAL'
    else 'BECARIO'
end as RANGO_SALARIAL
from PLANTILLA;
-- 1.MOSTRA LA SUMA SALARIAL DE LOS EMPLEADOS POR SU NOMBRE DE DEPARTAMENTO
-- 2.MOSTRAR LA SUMA SALARIAL DE LOS DOCTORES POR SU HOSPITAL
-- 3.ME GUSTARIA VER TODO JUNTO EN UNA MISMA CONSULTA
-- 1.MOSTRA LA SUMA SALARIAL DE LOS EMPLEADOS POR SU NOMBRE DE DEPARTAMENTO
select * from dept;
select * from emp;
select sum(emp.salario) as salario, dept.dnombre as departamento
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by dept.dnombre;
-- 2.MOSTRAR LA SUMA SALARIAL DE LOS DOCTORES POR SU HOSPITAL
select * from doctor;
select * from hospital;
select sum(doctor.salario) as salario, hospital.nombre as hospital
from doctor
inner join hospital
on doctor.hospital_cod = hospital.hospital_cod
group by hospital.nombre;
-- 3. ME GUSTARIA VER TODO JUNTO EN UNA MISMA CONSULTA
select sum(emp.salario) as salario, dept.dnombre 
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by dept.dnombre
union
select sum(doctor.salario), hospital.nombre 
from doctor
inner join hospital
on doctor.hospital_cod = hospital.hospital_cod
group by hospital.nombre;

-- CONSULTAS DE ACCION
-- SON CONSULTAS PARA MODDIFICAR LOS REGISTROS DE LA BASE DE DATOS. 
-- EN ORACLE, LAS CONSULTAS DE ACCION SON TRANSACCIONALES, ES DECIR, SE ALMACENAN DE FORMA TEMPORAL POR SESION
-- PARA DESHACER LOS CAMBIOS O PARA HACELOS PERMANENTES TENENMOS DOS PALABRAS
-- commit: HACE LOS CAMBIOS PERMANENTES
-- rollback: DESHACE LOS CAMIOS REALIZADOS
-- 1. INSERTO 2 REGSITROS REALIZADOS
-- 2. commit PERMANENTE
-- 3. INSERTO OTRO REGISTRO NUEVO (3)
-- 4. rollback: SOLAMENTE QUITA EL PUNTO 3
-- TENEMOS TRES TIPOS DE CONSULTAS DE ACCION
-- insert: INSERTA UN NUEVO REGISTRO EN UNA TABLA
-- update: MODIFICA UNO O VARIOS REGISTROS DE LA TABLA
-- delete: ELIMINA UNO O VARIOS REGISTROS DE UNA TABLA
-- INSERT
-- CADA REGISTRO A INSERTAR ES UNA INSTRUCCION inser, ES DECIR, SI QUEREMOS INSERTAR 5 REGISTROS, SON 5 insert
-- TENEMOS DOS TIPOS DE  SINTAXIS:
-- 1. INSERTAR LOS DATOS DE LA TABLA: DEBEMOS INDICAR TODAS LAS COLUMNAS/CAMPOS DE LA TABLA Y EN EL MISMO ORDEN QUE ESTEN EN LA PROPIA TABLA.
-- insert into TABLA values (valor1, valor2, valor3, valor4);
select * from dept;
insert into dept values (50, 'ORACLE', 'BERNABEU');
commit;
insert into dept values (53, 'BORRAR', 'BORRAR');
rollback;
-- 2. INSERTAR SOLAMENTE ALGUNOS DATOS DE LA TABLA: DEBEMOS INDICAR EL NOMBRE DE LAS COLUMNAS QUE DESEAMOS INSERTAR Y LOS VALORES IRAN EN DICHO ORDEN, LA TABLA NO TIENE ANDA QUE VER.
-- insert into TABLA(campo3, campo7) values (valor3, valor7);
-- INSERTAR UN NUEVO DEPARTAMENTO EN ALMERIA
select * from dept;
insert into dept(dept_no, loc) values (55, 'ALMERIA');
-- LAS SUBCONSULTAS SON SUPER UTILES SI ESTAMOS EN CONSULTAS DE ACCION.
-- NECESITAMOS UN DEPARTAMENTO DE SIDRA EN GIJON.
-- GENERAR EL SIGUIENTE NUMERO DISPONIBLE EN LA CONSULTA DE ACCION
select max(dept_no) +1 from dept;
insert into dept values ((select max(dept_no) +1 from dept), 'SIDRA', 'GIJON');
rollback;
-- DELETE
-- ELIMINA UNA O VARIAS FILAS DE UNA TABLA. SI NO EXISTE NADA PARA ELIMINAR, NO HACE NADA 
-- SINTAXIS:
-- delete from tabla
-- LA SINTAXIS ANTERIOR ELIMINA TODOS LOS REGISTROS DE LA TABLA
-- OPCIONAL, INCLUYE where
-- ELIMINAR EL DEPARTAMENTO DE ORACLE
select * from dept;
delete from dept where dnombre='ORACLE';
rollback;
-- IMPRESCINDIBLE UTILIZAR SUBCONSULTAS PARA delete
-- ELIMINAR TODOS LOS EMPLEADOS DE GRANADA
delete from emp where dept_no = (select dept_no from dept where loc='GRANADA');
rollback;
-- UPDATE
-- MODIFICA UNA O VARIAS FILAS DE UNA TABLA. PUEDE MODIFICAR VARIAS COLUMNAS A LA VEZ
-- SINTAXIS:
-- update TABLA set campo1=valor1, campo2=valor2
-- ESTA CONSULTA MODIFICA TODAS LAS FILAS DE LA TABLA. ES CONVENIENTE UTILIZAR where
-- MODIFICAR EL SALARIO DE LA PLANTILLA DEL TURNO DE NOCHE, TODOS COBRARAN 315000
update PLANTILLA set SALARIO=315000
where TURNO='N';
select * from plantilla  where turno='N';
-- MODIFICAR LA CIUDAD Y EL NOMBRE DEL DEPARTAMENTO 10. SE LLAMARA CUENTAS Y NOS VAMOS A TOLEDO
update dept set loc='TOLEDO', dnombre='CUENTAS'
where dept_no=10;
select * from dept;
-- PODEMOS MANTENER EL VALOR DE UNA COLUMNA Y ASIGNAR "ALGO" CON OPERACIONES MATEMATICAS.
-- INCREMENTAR EN 1 EL SALARIO DE TODOS LOS EMPLEADOS
update emp set salario=salario + 1;
-- PODEMOS UTILIZAR SUBCONSULTAS, SI LAS SUBCONSULTAS ESTAN EN EL SET, SOLAMENTE DEBEN DEBOLVER UN DATO
select * from emp;
-- ARROYO ESTA ENVIDIOSO DE SALA, PONER EL MISMO SALARIO A ARROYO QUE SALA
update emp set SALARIO=(select SALARIO from emp where APELLIDO='sala')
where APELLIDO='arroyo';
-- LOS CATALANES ESTAN SUBIDITOS Y LES BAJAMOS EL SUELDO A LA MITAD
-- PONER A LA MITAD EL SALARIO DE LOS EMPLEADOS DE BARCELONA
update emp set salario=salario / 2
where dept_no=(select dept_no from dept where loc= 'BARCELONA');
select * from emp;
rollback;

-- CONSULTAS DE ACCION

-- 1. Dar de alta con fecha actual al empleado José Escriche Barrera como programador perteneciente al departamento de producción.  
-- Tendrá un salario base de 70000 pts/mes y no cobrará comisión. 
select * from emp;
select * from dept;
insert into emp(emp_no, apellido, oficio, fecha_alt, salario, dept_no) values (7070, 'escriche', 'programador', '31/03/25', 70000, 40);

-- 2. Se quiere dar de alta un departamento de informática situado en Fuenlabrada (Madrid).
select * from dept;
insert into dept(dept_no, dnombre, loc) values(60, 'INFORMATICA', 'MADRID');

-- 3. El departamento de ventas, por motivos peseteros, se traslada a Teruel, realizar dicha modificación.
select * from dept;
update dept set loc='TERUEL'
where dept_no=30;

-- 4.  En el departamento anterior (ventas), se dan de alta dos empleados: Julián Romeral y Luis Alonso. 
-- Su salario base es el menor que cobre un empleado, y cobrarán una comisión del 15% de dicho salario.
select * from dept;
select * from emp;
select min(salario) from emp
where oficio='EMPLEADO';
select min(salario)*15/100 = COMISION from emp
where oficio='EMPLEADO';
insert into emp(emp_no, apellido, oficio, fecha_alt, salario, comision, dept_no) values(7001, 'romeral', 'EMPLEADO', '31/03/25', (select min(salario) from emp where oficio='EMPLEADO'),(select min(salario)*15/100 from emp where oficio='EMPLEADO')
, (select dept_no from dept where dnombre='VENTAS') ,30);
insert into emp(emp_no, apellido, oficio, fecha_alt, salario, comision, dept_no) values(7002, 'alonso', 'EMPLEADO', '31/03/25', (select min(salario) from emp where oficio='EMPLEADO'),(select min(salario)*15/100 from emp where oficio='EMPLEADO')
, (SELECT DEPT_NO FROM DEPT WHERE DNOMBRE='VENTAS') ,30);
-- 5. Modificar la comisión de los empleados de la empresa, de forma que todos tengan un incremento del 10% del salario.
update emp
set comision = salario*10/100;

-- 6. Incrementar un 5% el salario de los interinos de la plantilla que trabajen en el turno de noche.
update plantilla set salario = salario*5/100
where funcion = 'INTERINO' and turno ='N';

-- 7. Incrementar en 5000 Pts. el salario de los empleados del departamento de ventas y del presidente, tomando en cuenta los que se dieron de alta antes que el presidente de la empresa.
update emp set salario=salario+5000
where oficio='PRESIDENTE' or dept_no=(select dept_no from dept where dnombre='VENTAS') and fecha_alt<(select fecha_alt from emp where oficio='PRESIDENTE');

-- 8. El empleado Sanchez ha pasado por la derecha a un compañero.  
-- Debe cobrar de comisión 12.000 ptas más que el empleado Arroyo y su sueldo se ha incrementado un 10% respecto a su compañero.
update emp set comision = (select comision + 12000 from emp where upper(apellido) = 'ARROYO'), salario = (select salario * 1.10 from emp where upper(apellido) = 'ARROYO') 
where upper(apellido) = 'SANCHA';

-- 9. Se tienen que desplazar cien camas del Hospital SAN CARLOS para un Hospital de Venezuela.  
-- Actualizar el número de camas del Hospital SAN CARLOS.
update hospital
set num_cama=num_cama-100
where nombre='san carlos';

-- 10. Subir el salario y la comisión en 100000 pesetas y veinticinco mil pesetas respectivamente a los empleados que se dieron de alta en este año.
update emp
set salario= salario+100000, comision=comision+25000
where fecha_alt>='01/01/2011';

-- 11. Ha llegado un nuevo doctor a la Paz.  Su apellido es House y su especialidad es Diagnostico. Introducir el siguiente número de doctor disponible.
insert into doctor values ((select hospital_cod from hospital where nombre='la paz'), (select max(doctor_no) + 1 from doctor), 'House', 'Diagnostico');

-- 12. Borrar todos los empleados dados de alta entre las fechas 01/01/80 y 31/12/82.
delete from emp
where fecha_alt between '01/01/1980' and '31/12/1982';

-- 13. Modificar el salario de los empleados trabajen en la paz y estén destinados a Psiquiatría. Subirles el sueldo 20000 Ptas. más que al señor Amigo R.
update doctor set salario = (select salario+20000 from plantilla where apellido='amigo r.')
where hospital_cod = (select hospital_cod from hospital where nombre='la paz') and especialidad='Psiquiatria';

-- 14. Insertar un empleado con valores null (por ejemplo la comisión o el oficio), y después borrarlo buscando como valor dicho valor null creado.
insert into emp (apellido, salario, comision, dept_no) values ('gutierrez', 225000, null, 10);

delete from emp
where oficio is null and comision is null and apellido='gutierrez';

-- 15. Borrar los empleados cuyo nombre de departamento sea producción.
delete from emp
where dept_no = (select dept_no from dept where dnombre='PRODUCCION');

-- 16. Borrar todos los registros de la tabla Emp sin delete.
delete from emp;

truncate table emp;

-- 17. Volver a ejecutar los SCRIPTS de BBDD para dejar la base de datos intacta para el siguiente módulo.
