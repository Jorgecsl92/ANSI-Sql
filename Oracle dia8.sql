-- CREACION DE SECUENCIAS PARA DEPARTAMENTOS
create sequence seq_dept
increment by 10
start with 40; 

-- UNA SECUENCIA NO SE PUEDE MODIFICAR, SOLO ELIMINAR.
drop sequence seq_dept;

-- TODAVIA NO HEMOS UTILIZADO LA SECUENCIA
select seq_dept.nextval as SIGUIENTE from DUAL;

-- NO PODEMOS ACCEDER A CURRVAL HASTA QUE NO HEMOS EJECUTADO NEXTVAL
select seq_dept.currval as ACTUAL from dual;

-- SI LO QUEREMOS PARA insert DEBEMOS LLAMARLO DE FORMA EXPLICITA.
insert into dept values (seq_dept.nextval, 'NUEVO', 'NUEVO');
select * from dept order by dept_no;
commit;
delete from dept where dept_no > 40;

-- UNA SECUENCIA NO ESTA ASOCIADA A UNA TABLA
insert into hospital values (seq_dept.nextval, 'El Carmen', 'Calle Pex', '12345', 125);
select * from dept order by dept_no;

----- PRACTICA -----
-- NECESITAMOS LAS SIGUIENTES CARACTERISTICAS DENTRO DE NUESTRA BASE DE DATOS hospital
-- pk EN HOSPITAL
select * from hospital;
alter table PK_HOSPITAL
add constraint 
primary key (HOSPITAL_COD);

-- pk en DOCTOR
select * from doctor;
alter table PK_DOCTOR
add constraint 
primary key (DOCTOR_NO);

-- NECESITO RELACIONAR DOCTOR CON HOSPITAL
alter table DOCTOR
add constraint fk_doctor_hospital
foreign key (hospital_cod)
references hospital (hospital_cod);

-- LAS PERSONAS DE LA PLANTILLA SOLAMENTE PUEDEN TRABAJAR EN TURNOS DE MAÑANA, TARDE O NOCHE (M, T, N).
alter table PLANTILLA
add constraint chk_PLANTILLA_TURNO
check (turno in ('T', 'M', 'N'));

------------------ESTRUCTURA DE LAS TABLAS------------------------
-- Crear la tabla COLEGIOS 
create table COLEGIOS ( 
    Cod_colegio integer not null,
    Nombre varchar2(20) not null,
    Localidad varchar2(15),
    Provincia varchar2(15),
    Ano_Construccion date,
    Coste_Construccion integer,
    Cod_Region integer,
    Unico integer 
);
--RESTRICCIONES DE COLEGIOS
--PK
alter table colegios
add constraint PK_COLEGIOS
primary key (Cod_colegio);
--UNIQUE
alter table colegios
add constraint U_COLEGIOS_UNICO
unique (unico);

 --SECUENCIA PARA MANEJAR INSERCION DE COLEGIOS
create sequence seq_colegios
increment by 1
start with 1;

-- Crear la tabla PROFESORES
create table PROFESORES ( 
    Cod_Profe integer not null,
    Nombre varchar2(20) not null,
    Apellido1 varchar2(20),
    Apellido2 varchar2(20),
    DNI varchar2(9),
    Edad integer,
    Localidad varchar2(15),
    Provincia varchar2(15),
    Salario integer,
    Cod_Colegio integer
);

--RESTRICCIONES TABLA PROFESORES
--PK
alter table profesores
add constraint PK_PROFESORES
primary key (cod_profe);

--UNIQUE
alter table profesores
add constraint U_PROFESORES_DNI
unique (dni);

--CHECK FORMATO DNI (LONGITUD)
alter table profesores
add constraint CK_PROFESORES_DNI
check (length(dni) = 9);

--FOREIGN KEY PROFESORES COLEGIOS
alter table PROFESORES
add constraint fk_profesores_colegios
foreign key (Cod_Colegio)
references Colegios (Cod_Colegio);

-- Crear la tabla REGIONES 
create table REGIONES ( 
    Cod_Region integer not null,
    Regiones varchar2(20) not null
);

--RESTRICCIONES DE REGIONES
alter table regiones
add constraint PK_REGIONES  
primary key (cod_region);

--SECUENCIA PARA REGIONES
create sequence seq_regiones
increment by 1
start with 1;

-- Crear la tabla ALUMNOS
create table ALUMNOS ( 
    DNI varchar(9) not null,
    Nombre varchar2(20) not null,
    Apellidos varchar2(20),
    Fecha_Ingreso date,
    Fecha_nac date,
    Localidad varchar2(15),
    Provincia varchar2(15),
    Cod_Colegio integer
);

--RESTRICCIONES ALUMNOS
--PK
alter table alumnos
add constraint PK_ALUMNOS
primary key (dni);

--FOREIGN KEY ALUMNOS
alter table alumnos
add constraint FK_COLEGIOS_ALUMNOS
foreign key (cod_colegio)
references Colegio (cod_colegio);

--Crear una nueva relación entre el campo Cod_Region de la tabla REGIONES y Cod_Region de la tabla colegios.
alter table COLEGIOS
add constraint fk_colegios_regiones
foreign key (Cod_Region)
references Regiones (Cod_Region);

-- Añadir el campo Sexo, Fecha de nacimiento y Estado Civil a la tabla Profesores.
alter table PROFESORES
add Sexo varchar2(9)
add Fecha_nac date
add Estado_Civil varchar2(10)
;

-- Eliminar el campo Edad de la tabla Profesores.
alter table PROFESORES 
drop column Edad;

-- Añadir el campo Sexo, Dirección y Estado Civil a la tabla Alumnos.
alter table ALUMNOS
add Sexo varchar2(9)
add Direccion varchar(30)
add Estado_Civil varchar2(10)
;

-- Borrar la relación existente entre la tabla profesores y Colegios.
alter table PROFESORES
drop constraint fk_profesores_colegios;

-- Crear de nuevo la relación borrada en el ejercicio anterior que tenga eliminación en cascada.
alter table PROFESORES 
add constraint fk_profesores_colegios
foreign key (Cod_Colegio)
references Colegio (Cod_Colegio)
on delete cascade;

-- Agregar un valor por defecto con la fecha actual al campo Fecha_Ingreso de la tabla alumnos.
alter table Alumnos
modify (Fecha_Ingreso date default sysdate);

-- Queremos rellenar los datos de las tablas creadas, para ello vamos a introducir a tres alumnos en los colegios. Los datos son los siguientes:
-- Alumnos:
-- Ana Ortiz Ortega Provincia: Madrid Localidad: Madrid 
-- Javier Chuko Palomo Provincia: Alicante Localidad: Arenales del sol
-- Miguel Torres Tormo Provincia: Barcelona Localidad: Llobregat
-- Rellenar las tablas convenientemente con datos relacionales.  
-- Ejemplo: Region: Comunidad Valenciana
-- 3 datos como mínimo en cada tabla.
--PRIMERO LAS REGIONES Y DESPUES EL COLEGIO

select * from regiones;
insert into regiones values (seq_regiones.nextval, 'MADRID');
insert into regiones values (seq_regiones.nextval, 'Comunidad Valenciana');
insert into regiones values (seq_regiones.nextval, 'Cataluña');

--PRIMERO DEBEMOS TENER UN COLEGIO Y DESPUES EL ALUMNO
select * from colegios;
insert into colegios values (seq_colegios.nextval, 'Buen consejo', 'Madrid', 'Madrid', '01/01/1956', 150000, 1, 1);

insert into colegios values (seq_colegios.nextval, 'Carmelitas', 'Alicante', 'Alicante', '01/01/1901', 250000, 2, 2);

insert into colegios values (seq_colegios.nextval, 'CP Cataluña', 'Llobregat', 'Barcelona', '01/01/1915', 250000, 3, 3);

insert into alumnos values ('12345678X', 'Ana', 'Ortiz Ortega', sysdate, '01/01/1995', 'MADRID', 'MADRID',2, 'F', 'SOLTERA', 'Calle Pez');
insert into alumnos values ('12345677Z', 'Javier', 'Chuko Palomo', sysdate, '01/01/1988', 'ARENALES DEL SOL', 'ALICANTE',3, 'M', 'DIVORCIADO', 'Calle Salmon');
insert into alumnos values ('2345677Z', 'Miguel', 'Torres Tormo', sysdate, '01/01/2001', 'Llobregat', 'BARCELONA',4, 'M', 'SOLTERO', 'Calle Delfin');

--DEBEMOS CAMBIAR EL TIPO DE DATO DE LOCALIDAD PARA QUE ADMITA MAS CARACTERES
alter table alumnos
modify (localidad varchar2(50));
select * from alumnos;

--INSERTAMOS PROFESORES
SELECT * FROM PROFESORES;
INSERT INTO PROFESORES VALUES (1, 'Alejandro', 'Ramiro', 'Gutierrez', '12345678W', 'Parla', 'Madrid', 45000, 2, 'M', 'CASADO', sysdate);

INSERT INTO PROFESORES VALUES (2, 'Alejandra', 'Marian', 'Lopez', '97845678W', 'Parla', 'Madrid', 45000, 2, 'F', 'CASADA', sysdate);

INSERT INTO PROFESORES VALUES (3, 'Julia', 'Arroyo', 'Garrigos', '37845678W', 'Calpe', 'Alicante', 65000, 3, 'F', 'SOLTERO', sysdate);

-- Borrar la tabla Regiones. ¿Qué ocurre?. ¿Cómo lo solucionamos?
--BORRAR LA TABLA REGIONES
DROP TABLE REGIONES;

--NO PODEMOS REALIZAR EL BORRADO PORQUE LA PRIMARY KEY DE LA TABLA REGIONES
--ESTA RELACIONADA CON FOREIGN KEY DE OTRA TABLA
--1) ELIMINANDO LA RESTRICCION FOREIGN KEY PODEMOS BORRAR REGIONES
alter table colegios
drop constraint FK_REGIONES_COLEGIOS;

--YA TENEMOS LIBRE LA TABLA REGIONES Y PODEMOS ELIMINARLA
DROP TABLE REGIONES;

--2) ELIMINANDO PRIMERO LA TABLA DONDE ESTE LA FOREIGN KEY LUEGO ELIMINANDO
--LA TABLA REGIONES
--PRIMERO SE ELIMINAN FOREIGN KEY Y DESPUES LAS PRIMARY
DROP TABLE ALUMNOS;
DROP TABLE PROFESORES;
DROP TABLE COLEGIOS;
DROP TABLE REGIONES;

--3) ELIMINAR LA TABLA REGIONES Y SUS RESTRICCIONES EN LA MISMA INSTRUCCION
DROP TABLE REGIONES CASCADE CONSTRAINTS;
