-- ORACLE 
-- TODO LO QUE VEREMOS A CONTINUACION SOLO NOS SIRVE EN ORACLE

-- CONSULTAS insert all
select * from dept;
insert into dept values ( (select max(dept_no) +1 from dept), 'INTO', 'INTO' );
insert into dept values ( (select max(dept_no) +1 from dept), 'INTO2', 'INTO2' );
insert into dept values ( (select max(dept_no) +1 from dept), 'INTO3', 'INTO3' );

insert all
    into dept values ((select max(dept_no) +1 from dept), 'ALL', 'ALL')
    into dept values ((select max(dept_no) +1 from dept), 'ALL2', 'ALL2')
    into dept values ((select max(dept_no) +1 from dept), 'ALL3', 'ALL3')
select * from dual; -- SIEMPRE dual PARA QUE NO SALGA REPETIDO POR LA CANTIDAD DE LINEAS QUE HAY EN LA TABLA
Rollback;

-- CREACION DE TABLAS PARA INSERCIONES
-- create ...select
-- rollback NI commit FUNCIONAN. TODO QUEDA ALMACENADO.
describe dept;
create table departamentos
as select * from dept; -- DUPLICARA LA TABLA dept DENTRO  DE departamento

create table DOCTORES_HOSPITAL
as
select DOCTOR.DOCTOR_NO as IDDOCTOR, DOCTOR.APELLIDO, HOSPITAL.NOMBRE, HOSPITAL.TELEFONO
from DOCTOR
inner join HOSPITAL
on DOCTOR.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD;

-- INSTRUCCION insert into select
-- ESTA INSTRUCCION NOS PERMITE COPIAR DATOS DE UNA TABLA ORIGEN A UNA TABLA DESTINO. LA DIFERENCIA CON create select ESTA RN QUE LA TABLA DEBE DE EXISTIR
-- SIN TABLA DE DESTINO, NO PODEMOS EJECUTAR ESTA INSTRUCCION. LA TABLA DE DESTINO TIENE QUE TENER LA MISMA ESTRUCTURA QUE LOS DATOS select DE ORIGEN.
-- LA SINTAXIS ES:
insert into DESTINO
select * from ORIGEN;
-- COPIAR LOS DATOS DE LA TABLA dept DENTRO DE LA TABLA departamentos
select * from departamentos;
insert into departamentos
select * from dept;

-- VARIABLES DE SUSTITUCION
-- SINTAXIS:
/*
select * from emp;
select &&campo1, apellido, salario, comision, dept_no
from emp
where &campo1='&dato'; 
*/
select * from emp;
select &&campo1, apellido, salario
from emp
where emp_no=&numero;

-- NATURAL JOIN
-- UN natural join TOMA LAS COLUMNAS DE IGUAL NOMBRE ENTRE DS TABLAS Y LAS UTILIZA PARA REALIZAR UN join. EL BENEFICIO ES QUE NO HAY QUE NOMBRAR LAS COLUMNAS EN EL join
-- SOLO SE UTILIZA PARA SUSTITUIR los inner join
select apellido, oficio, dnombre, loc, dept_no from emp natural join dept;
select * from emp natural join dept;

-- USING
-- PERMITE ESPECIFICAR EL CAMPO (O LOS CAMPOS) POR EL CUAL SE ENLAZARAN LAS TABLAS; LOS CAMPOS DE AMBAS TABLAS DEBEN TENER EL MISMO NOMBRE Y SER DE TIPOS COMPATIBLES
select apellido,loc,dnombre from emp inner join dept using (dept_no);

-- RECUPERACION JERARQUICA
-- PUEDE RECUPERAR DATOS BASANDOSE EN UNA RELACION JERARQUICA NATURAL ENTRE FILAS DE UNA TABLA
-- TENEMOS UN PRESIDENTE QUE ES EL JEFE DE LA EMPRESA: REY (7839)
-- MOSTRAR TODOS LOS EMPLEADOS QUE TRABAJAN PARA REY DIRECTAMENTE
select * 
from emp 
where DIR=7839;
-- NECESITO SABER LOS EMPLEADOS QUE TRABAJAN PARA negro (7698)
select * 
from emp 
where DIR=7698;

-- MOSTRAMOS LOS EMPLEADOS SUBORDINADOS A PARTIR DEL DIRECTOR jimenez (descendente)
select level as NIVEL, apellido, dir, oficio
from emp
connect by prior emp_no=dir
start with apellido='jimenez'
order by 1;

-- MOSTRAMOS LOS EMPLEADOS SUBORDINADOS A PARTIR DEL DIRECTOR jimenez (descendente) Y MUESTRA LA RELACION EXISTENTE DE MANERA VISUAL
select level as NIVEL, apellido, dir, oficio, sys_connect_by_path(apellido, '/') as RELACION
from emp
connect by prior emp_no=dir
start with apellido='jimenez'
order by 1;

-- MOSTRAMOS LOS SUPERIORES A PARTIR DEL DIRECTOR jimenez (ascendente)
select level as NIVEL, apellido, dir, oficio
from emp
connect by emp_no = prior dir
start with apellido='jimenez' order by 1;

-- ARROYO HA METIDO LA PATA, QUIERO VER A TODOS SUS JEFES EN MI DESPACHO
-- MANDA EL LISTADO, SOY REY
select level as NIVEL, apellido, oficio 
from emp
connect by emp_no= prior dir
start with apellido='arroyo'
order by 1;

-- OPERADORES DE CONJUNTOS
-- OPERADOR union
-- ES UN OPERADOR QUE COMBINA UN CONJUNTO DE RESULTADOS, POR EJEMPLO, UNA SENTENCIA select con OTRA SENTENCIA select 
-- SIRVE PARA RECUPERAR DATOS DE UNA O MÁS TABLAS SIN QUE EXISTE RELACIÓN ENTRE LAS TABLAS. 
-- NO EXISTE LÍMITE EN EL NÚMERO DE TABLAS A COMBINAR. 
-- EL NÚMERO DE COLUMNAS DE LAS CONSULTAS DEBE SER EL MISMO PARA TODAS LAS CONSULTAS 
-- LOS TIPOS DE DATOS DE LAS COLUMNAS DEBEN COINCIDIR EN TODAS LAS CONSULTAS 
-- RECOMENDABLE UTILIZAR alias PARA LAS COLUMNAS. 

-- OPERADORES intersec
-- PERMITE UNIR DOS CONSULTAS select DE MODO QUE EL RESULTADO SERÁN LAS FILAS QUE ESTÉN PRESENTES EN AMBAS CONSULTAS. 
select * from PLANTILLA where TURNO='T' 
intersect 
select * from PLANTILLA where FUNCION='ENFERMERA';
-- OPERADOR minus
-- COMBINA DOS CONSULTAS select DE FORMA QUE APARECERÁN LOS REGISTROS DEL PRIMER select QUE NO ESTÉN PRESENTES EN EL SEGUNDO. 
select * from PLANTILLA where TURNO='T' 
minus 
select * from PLANTILLA where FUNCION='ENFERMERA';

-- CREACION Y GESTION DE TABLAS
-- TABLA: unidad básica de almacenamiento compuesta de filas y columnas.
create table dept(dept_no number(9),dnombre varchar2(50),loc varchar2(50));

