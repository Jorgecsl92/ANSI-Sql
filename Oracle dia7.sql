-- CREACION DE TABLAS
-- SINTAXIS:
drop table PRUEBA; -- ELIMINA UNA TABLA DEFINITIVAMENTE.
delete from PRUEBA; -- ELIMINA LOS DATOS QUE COTIENE UNA TABLA
create table PRUEBA ( 
    identificador integer,
    texto1 varchar2(10),
    textochar char(5)
);

describe PRUEBA;
select * from PRUEBA;
insert into PRUEBA values (1, 'abcdesdfgh', 'aeiou');
insert into PRUEBA values (1, 'A', 'A');
insert into PRUEBA values (1, 'A', 'ASDFGH'); -- DA ERROR PORQUE SE PASA DEL LIMITE DE CARACTERES.

rollback; -- NO ELIMINAMOS LA TABLA, SOLO LOS DATOS INTRDUCIDOS.

-- LA TABLA PRUEBA  CONTINEN UN REGISTRO
-- AGREGAMOS UNA NUEVA COLUMNA DE TIPO TEXTO LLAMADA NUEVA
alter table PRUEBA
add (NUEVA varchar2(3)); -- AL REALIZAR UN alter table, HACE UN commit O rollback AUTOMATICAMENTE.
-- AGREGAMOS OTRA COLUMNA DE TIPO TEXTO LLAMADA SIN NULOS Y NO ADMITIRA null
alter table PRUEBA
add (SINNULOS varchar2(7) not null); -- NO PODEMOS AGRAGAR UNA COLUMNA not null EN UNA TABLA QUE YA CONTIENE DATOS.

alter table PRUEBA
drop column SINNULOS; -- PARA ELIMINAR LA COLUMNA

alter table PRUEBA
modify (NUEVA float); -- MODIFICAMOS EL TIPO DE DATO DE UNA COLUMNA

rename PRUEBA to EXAMEN; -- RENOMBRA LA TABLA
describe EXAMEN;

truncate table EXAMEN; -- ELIMINA TODA LA INFORMACION QUE CONTIENE LA TABLA. ES MAS RAPIDO QUE UN delete.

comment on table EXAMEN -- AÑADE UN COMENTARIO
is 'que dia tan chungo';

select * from user_tab_comments where table_name='EXAMEN'; -- VEMOS LOS COMENTARIOS DE MI USUARIO
select * from all_tab_comments where table_name='EXAMEN'; -- -- VEMOS LOS COMENTARIOS DE TODOS LOS USUARIOS

select * from user_tables; --  CONSULTAS LAS TABLAS QUE SON PROPIEDAD DEL USUARIO
select * from all_tables; -- CONDSULTA LAS TABLAS DE TODOS LOS USUARIOS

select distinct object_type from user_objects; -- MUESTRA TODOS LOS TIPOS DE OBJETOS CREADOS POR EL USUARIO
select * from cat; --MUESTRA TODOS LOS OBJETOS CREADOS POR EL USUARIO
-------------------------------
rename EXAMEN to PRUEBA;
describe PRUEBA;
select * from PRUEBA;
alter table PRUEBA
drop column NUEVA; 
-- AÑADIMOS  UNA NUEVA COLUMNA LLAMADA TEST
alter table PRUEBA
add (test int);
-- AÑADIMOS OTRA COLUMNA, PERO QUE CONTENDRA VALORES POR DEFECTO
alter table PRUEBA
add (defecto int default -1);

insert into PRUEBA
(identificador, texto1, textochar)
values
(2, 'AA', 'AA');

insert into PRUEBA
(identificador, texto1, textochar, defecto)
values
(3, 'BB', 'BB', 21);

insert into PRUEBA
(identificador, texto1, textochar, defecto)
values
(4, 'CC', 'CC', null);
-------------------------------
-- CREACION DE RESTRICCIONES
-- INCLUIMOS UNA RESTRICCION primary key EN EL CAMPO dept_no DE DEPARTAMENTOS PARA QUE NO PUEDA ADMITIR NULOS
alter table dept
add constraint PK_DEPT
primary key(dept_no);

delete from dept where dept_no=10;
commit;
-- TODAS LAS RESTRICCIONES DEL USUARIO SE ENCEUNTRAN EN EL DICCIONARIO 
-- USER_CONSTRAINTS
select * from user_constraints;
-- INTENTAMOS INSERTAR UN DEPARTAMENTO REPETIDO
insert into dept values (10, 'REPE', 'REPE');
select * from dept;
-- ELIMINAMOS LA RESTRICCION DE primary key de DEPARTAMENTOS
alter table dept
drop constraint PK_DEPT; -- AL REALIZAR ESTO, PODEMOS INSERTAR  UN DEPARTAMENTO REPETIDO

----------------EMPLEADOS---------------------
-- CREAMOS EN EMPLEADOS UNA primary key PARA EL CAMPO emp_no
alter table emp
add constraint PK_EMP
primary key (EMP_NO);

select * from emp;

-- CREAMOS UNA RESTRICCION PARA COMPROBAR QUE EL SALARIO SIEMPRE SEA POSITIVO
-- CHK_TABLA_CAMPO
alter table emp
add constraint chk_emp_salario
check (salario >= 0);

-- PONEMOS UN VALOR NEGATIVO A UN EMPLEADO
update emp set SALARIO = -1000 where emp_no=7782; -- NO PODEMOS PONER VALORES NEGATIVOS DEBIDO AL CHECK QUE REALIZAMOS EN EL APARTADO ANTERIOR
select * from emp;

alter table emp
drop constraint chk_emp_salario; -- AL REALIZAR EL BORRADO EL CHECK NOS PERMITIRA PONER VALORES NEGATIVOS 

rollback;

---------ENFERMO-------------
select * from ENFERMO;
-- pk
alter table ENFERMO
add constraint PK_ENFERMO
primary key (INSCRIPCION);
-- unique PARA EL DATO DE NSS, SEGURIDAD SOCIAL
alter table enfermo
add constraint u_enfermo_nss
unique (nss);

-- NO PODEMOS REPETIR pk
insert into enfermo values (10995, 'Nuevo', 'Calle nueva', '01/01/2000', 'F', '123');
-- NO PODEMOS REPETIR unique
insert into enfermo values (10999, 'Nuevo', 'Calle nueva', '01/01/2000', 'F', '280862482');
-- NULOS EN pk? NO
insert into enfermo values (10995, 'Nuevo', 'Calle nueva', '01/01/2000', 'F', '123');
-- NULOS EN unique?? POR SUPUESTO SE LA COLUMNA LO ADMITE
insert into enfermo values (12346, 'Nuevo null', 'Calle nueva', '01/01/2000', 'F', null);

insert into enfermo values (11995, 'Langui M.', 'Goya 20', '16/05/1956', 'M', '280862482');

delete from enfermo where nss is null;
-- ELIMINAMOS LAS DOS RESTRICCIONES ANTERIORES
alter table enfermo
drop constraint pk_enfermo;
alter table enfermo
drop constraint u_enfermo_nss;

-- CREAMOS UNA primary key DE DOS COLUMNAS
alter table enfermo
add constraint pk_enfermo
primary key(inscripcion, nss); -- AHORA UNO DE LOS DOS COLUMNAS TIENE QUE MANTENER EL MISMO DATO Y LA OTRA SE PUEDE DUPLICAR. NO PERMITE LA DUPLICIDAD EN AMBAS COLUMNAS
-- INTENTAMOS CREAR UN REGISTRO CON DOS DATOS IGUALES DE INSCRIPCION Y NSS
insert into enfermo values (11995, 'Languia M.', 'Goya 20', '16/05/1956', 'M', '280862482');

-----------------------FOREING KEY-------------------------
-- CREAMOS UNA RELACION ENTRE EMPLEADOS Y DEPARTAMENTOS
-- EL CAMPO DE RELACION ES dep_no
select * from emp;

insert into DEPT values (10, 'CONTABILIDAD', 'ELCHE'); -- CREAMOS LA FILA 10 PARA QUE COINCIDA CON LOS DATOS DE LA TABLA

alter table emp
add constraint PK_EMP
primary key (EMP_NO); -- ESTABLECEMOS LA primary key

--DEPT_NO DE DEPARTAMENTOS PARA QUE NO PUEDA ADMITIR NULOS
alter table DEPT
add constraint PK_DEPT
primary key (DEPT_NO);

alter table emp
add constraint fk_emp_dept
foreign key (dept_no)
references dept (dept_no); -- ESTABLECEMOS LA foreing key

-- INSERTAMOS UN EMPLEADO EN UN DEPARTAMENTO QUE NO EXISTE
insert into emp values (1111, 'NUEVO', 'EMPLEADO', 7902, '02/04/2025', 1, 1, null);
select * from emp;
select * from dept;
describe emp;
rollback;

-- VAMOS A PROBAR LA ELIMINACION EN CASCADA Y set null EN CASCADA
select * from emp;

delete from dept where dept_no=10;
alter table emp
drop constraint fk_emp_dept;

alter table emp
add constraint fk_emp_dept
foreign key (dept_no)
references dept (dept_no)
on delete cascade; -- NUNCA SE USA delete cascade. ¡¡¡¡¡¡¡PROHIBIDISIMO!!!!!!!

alter table emp
add constraint fk_emp_dept
foreign key (dept_no)
references dept (dept_no)
on delete set null; -- OPCION PREFERIDA CON RESPECTO A LA ANTERIOR
