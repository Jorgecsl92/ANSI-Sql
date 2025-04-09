-- FUNCIONES DE ORACLE
select * from emp where lower(oficio)='analista';
update emp set oficio='analista' where emp_no=7902;

--ESTAMOS PONIENDO VALORES ESTATICOS: 'analista'
-- TAMBIEN PODRIAMOS INCLUIR VALORES DINAMICOS, POR LO QUE TENDRIAMOS QUE CONVERTIR LAS DOS COMPARACIONES
select * from emp where upper (OFICIO)=upper('&dato');

-- EN ORACLE TENEMOS LA POSIBILIDAD DE CONCATENAR TEXTOS EN UNA SOLA COLUMNA (CAMPO CALCULADO)
-- SE UTILIZA EL SIMBOLO || PARA CONCATENAR
-- QUEREMOS MOSTRAR, EN UNA SOLA COLUMNA EL APELLIDO Y OFICIO DE LOS EMPLEADOS
select apellido || ' ' || oficio as descripcion from emp;

-- LA FUNCION INITCAP MUESTRA CADA PALABRA DE UNA FRAE CON LA PRIMERA LETRA EN MAYUSCULAS
select initcap(oficio) as initc from emp;
select initcap (apellido || ' ' || oficio) as descripcion from emp;
select concat ('Nuestro empleado ES.....', apellido) as resultado from emp;

-- substr RECUPERA UNA SUBCADENA DE UN TEXTO
select substr ('FLORERO', 2, 4) as dato from dual; -- COJE LA SEGUNDA LETRA DE LA PALABRA HASTA LA CUARTA LETRA
select substr ('FLORERO', 4) as dato from dual; -- COJE TODAS LAS LETRAS DESDE LA CUARTA LETRA EN ADELANTE 

-- MOSTRAR LOS EMPLEADOS CUYO EMPLEADO APELLIDO COMIENZA CON S
select * from emp where apellido like 's%'; -- MENOS EFICIENTE
select substr(apellido, 1, 1) as UNAletra from emp;
select * from emp where substr(apellido, 1, 1)='s'; -- MAS EFICIENTE

-- DIME EL NUMERO DE CARACTERES QUE TIENE UNA CADENA
select length('libro') as longitud from dual;

-- MOSTRAR LOS EMPLEADOS CUYO APELLIDO SEA DE 4 LETRAS
select * from emp where apellido like '____'; -- MENOS EFICIENTE
select * from emp where length(apellido)=4; -- MAS EFICIENTE

-- instr BUSCA UN TEXTO Y DEVUELVE SU POSICION
select instr('BENITO', 'NI') as POSICION from dual;
select instr('ORACLE MOLA', ' ') as POSICION from dual;

-- SI DESEAMOS VALIDAR UN MAIL
select * from dual where instr('m@ail', '@') > 0;

-- AÑADE CARACTERES
select * from emp;
select ldap(dept_no, 5, '$') from emp; -- POR LA IZQUIERDA
select rdap(dept_no, 5, '$') from emp; -- POR LA DERECHA

-- FUNCIONES MATEMATICAS
-- round REDONDEA EL NUMERO DE DECIMALES QUE LE DIGAMOS
select round (45.923) as redondeo from dual; -- SI NO ESPECIFICAMOS REDONDEA AL ALZA
select round (45.423) as redondeo from dual; -- SI NO ESPECIFICAMOS REDONDEA AL BAJA
select round (45.923, 2) as redondeo from dual;
select round (45.423, 2) as redondeo from dual;

-- trunc 
select trunc (45.923) as redondeo from dual; 
select trunc (45.423) as redondeo from dual; 
select trunc (45.923, 2) as redondeo from dual;
select trunc (45.423, 2) as redondeo from dual;

-- mod DEVUELVE EL RESTO DE LA DIVISION ENTRE DOS NUMEROS (RESTO)
-- AVERIGUA SI NUMERO ES PAR
select mod(9, 2) as resto from dual;
select mod(8, 2) as restp from dual;

-- MOSTRAR LOS EMPLEAOS CUYO SALARIO SE PAR
update emp set salario = salario + 1 where dept_no=20;
select * from emp where mod(SALARIO, 2) = 0;

-- TENEMOS UNA FUNCION PARA AVERIGUAR LA FECHA ACTUAL DE HOY EN EL SERVIDOR: sysdate
select sysdate as fecha_actual from dual;
select sysdate + 350 as fecha from dual; -- SUMA EL NUMERO DE DIAS

-- FUNCIONES DE FECHA
-- months_between  DEVUELVE LAS FECHAS COMPRENDIDAS ENTRE DOS FECHAS ESPECIFICAS
-- MOSTRAR CUANTOS MESES LLEVAN LOS EMPLEADOS DADOS DE ALTA EN LA EMPRESA
select apellido, months_between(sysdate, fecha_alt) as meses from emp;

-- AGREGAMOS A LA FECHA ACTUAL, 5 MESES
select add_moths(sysdate, 5) as dentro5 from dual;

-- MOSTRAR CUANDO ES EL PROXIMO LUNES
select next_day(sysdate, 'LUNES') as proximoLUNES from dual;
select next_day(sysdate, 'martes') as proximoLUNES from dual;

-- last day
select last_day(sysdate) as finmes from dual;

-- EMPLEADOS REDONDEADOS LA FECHA AL MES
select apellido, fecha_alt, round(fecha_alt, 'MM') as roundmes from emp;
select apellido, fecha_alt, round(fecha_alt, 'YY') as roundyear from emp;

-- trunc fecha
select apellido, fecha_alt, trunc(fecha_alt, 'MM') as truncmes from emp;
select apellido, fecha_alt, trunc(fecha_alt, 'YY') as truncmes from emp;

-- to_char CONVIERTE VALORES DE FECHA O NUMERICOS EN TEXTO
select apellido, fecha_alt, to_char(fecha_alt, 'MM-DD-YYYY') as formato from emp;
select apellido, fecha_alt, to_char(fecha_alt, 'MM@DD@YYYY') as formato from emp;
select to_char(sysdate, 'day month') as nombremes from dual;

-- FORMATO A NUMEROS
select to_char(7458, '0000L') as zero from dual;
select to_char(7458, '0000$') as zero from dual;
select to_char (sysdate, 'HH24:MI:SS') as hora_sistema from dual;

-- SI DESEAMOS INCLUIR TEXTO ENTRE to_char Y LOS FORMATOS SE REALIZA CON " " DENTRO DE LAS SIMPLES
select to_char(sysdate, '" Hoy es " DD " de " MONTH') as formato from dual;
select to_char(sysdate, '" Hoy es " DD " de " MONTH', 'nls_date_language=german') as formato from dual; -- PARA QUE NOS LO DE EN OTRO IDIOMA

-- FUNCIONES DE CONVERSION
select '08/04/2025' + 2 as fecha from dual; -- NOS DA ERROR
select to_date('08/04/2025') + 2 as fecha from dual;
select to_number('12') +2 as resultado from dual; -- SI VIENE EN FORMATO TEXTO LO CONVERTIMOS A NUMERO

-- nvl SIRVE PARA EVITAR LOS NULOS Y SUSTITUIR. SI ENCUENTRA UN NULO, LO SUSTITUYE, SINO, MUESTRA EL VALOR
select * from emp;

-- MOSTRAR APELLIDO, SALARIO Y COMISION DE TODOS LOS EMPLEADOS
select apellido, salario, comision from emp;

-- PODEMOS INDICAR QUE EN LUGAR DE PONER null, ESCRIBA OTRO VALOR.
-- EL VALOR DEBE SER CORRESPONDIENTE AL TIPO DE DATO DE LA COLUMNA
select apellido, salario, nvl(comision, -1) as comision from emp;

-- MOSTRAR APELLIDO, SALARIO + COMISION DE TODOS LOS EMPLEADOS
select apellido, salario + nvl(comision, 0) as total from emp;

-- MOSTRAR EL TURNO EN PALABRA ('MAÑANA', 'TARDE' O 'NOCHE') DE LA PLANTILLA
select apellido, turno from plantilla;
select apellido, decode(turno, 'M', 'mañana', 'n', 'noche') as turno from plantilla;

-- QUIERO SABER LA FECHA DEL PROXIMO MIERCOLES QUE JUEGA EL MADRID. 
select next_day(sysdate, 'miércoles') as champions from dual;

-- ahora quiero ver la fecha completa; quiero ver: El Miercoles 11 de abril juega el Madrid
select to_char(next_day(sysdate + 2, 'miércoles') + 2, '" El dia" day dd " juega el Madrid"') as champions from dual;

