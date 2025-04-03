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
    Cod_colegio integer primary key,
    Nombre varchar2(20) not null,
    Localidad varchar2(15),
    Provincia varchar2(15),
    Ano_Construccion date,
    Coste_Construccion integer,
    Cod_Region integer,
    Unico integer unique
);
    
-- Crear la tabla PROFESORES
create table PROFESORES ( 
    Cod_Profe integer primary key,
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

-- Crear la tabla REGIONES 
create table PROFESORES ( 
    Cod_Region integer primary key,
    Regiones varchar2(20) not null
);

-- Crear la tabla ALUMNOS
create table ALUMNOS ( 
    DNI varchar(9) primary key,
    Nombre varchar2(20) not null,
    Apellidos varchar2(20),
    Fecha_Ingreso date,
    Fecha_nac date,
    Localidad varchar2(15),
    Provincia varchar2(15),
    Cod_Colegio integer
);

--Crear una nueva relación entre el campo Cod_Region de la tabla REGIONES y Cod_Region de la tabla colegios.
alter table COLEGIOS
add constraint fk_colegios_regiones
foreign key (Cod_Region)
references Regiones (Cod_Region);

-- Añadir el campo Sexo, Fecha de nacimiento y Estado Civil a la tabla Profesores.
alter table PROFESORES
add Sexo varchar2(9)
add Fecha_nac date,
add Estado_Civil varchar2(10)
;

-- Eliminar el campo Edad de la tabla Profesores.
delete from PROFESORES
drop column Edad;

-- Añadir el campo Sexo, Dirección y Estado Civil a la tabla Alumnos.
alter table ALUMNOS
add Sexo varchar2(9)
add Direccion varchar(30),
add Estado_Civil varchar2(10)
;

-- Borrar la relación existente entre la tabla profesores y Colegios.
alter table PROFESORES
add constraint fk_profesores_colegios
foreign key (Cod_Colegio)
references Colegio (Cod_Colegio);

alter table PROFESORES
drop constraint fk_profesores_colegios;

-- Crear de nuevo la relación borrada en el ejercicio anterior que tenga eliminación en cascada.
alter table PROFESORES 
add constraint fk_profesores_colegios
foreign key (Cod_Colegio)
references Colegio (Cod_Colegio)
delete on cascade;

-- Agregar un valor por defecto con la fecha actual al campo Fecha_Ingreso de la tabla alumnos.
alter table Alumnos
modify (Fecha_Ingreso date default '03/04/25');

-- Queremos rellenar los datos de las tablas creadas, para ello vamos a introducir a tres alumnos en los colegios. Los datos son los siguientes:
-- Ana Ortiz Ortega Provincia: Madrid Localidad: Madrid 
-- Javier Chuko Palomo Provincia: Alicante Localidad: Arenales del sol
-- Miguel Torres Tormo Provincia: Barcelona Localidad: Llobregat
insert into ALUMNOS (DNI, Nombre, Apellido, Localidad, Provincia) values('123456789A', 'Ana', 'Ortiz Ortega', 'Madrid', 'Madrid');  
insert into ALUMNOS (DNI, Nombre, Apellido, Localidad, Provincia) values('123456789B', 'Javier', 'Chuko Plomo', 'Arenales del sol','Alicante'); 
insert into ALUMNOS (DNI, Nombre, Apellido, Localidad, Provincia) values('123456789C', 'Miguel', 'Torres Tormo', 'Llobregat', 'Barcelona');
-- Rellenar las tablas convenientemente con datos relacionales.  

-- Ejemplo: Region: Comunidad Valenciana

-- 3 datos como mínimo en cada tabla.

-- Borrar la tabla Regiones.  ¿Qué ocurre?. ¿Cómo lo solucionamos?

-- Borrar todas las tablas. 

