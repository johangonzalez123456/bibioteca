-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-08-2024 a las 15:39:04
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `biblioteca`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ACTU_SOCIO` (`id` INT, `telefono` VARCHAR(10), `direccion` VARCHAR(255))   BEGIN
UPDATE tbl_socio
SET tbl_socio.soc_telefono=telefono, tbl_socio.soc_direccion=direccion
WHERE tbl_socio.soc_numero=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_libro` (`id` BIGINT(20))   DELETE FROM tbl_libro WHERE tbl_libro.lib_isbn=id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_1leftjoin` ()   SELECT*FROM tbl_socio
LEFT JOIN tbl_prestamo
ON soc_numero=soc_copiaNumero$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_2innerjoin` ()   SELECT soc_copiaNumero,soc_numero,pres_id,soc_nombre,soc_apellido,lib_isbn,lib_titulo,lib_copiaISBN
FROM tbl_socio
INNER JOIN tbl_prestamo
ON tbl_prestamo.soc_copiaNumero=tbl_socio.soc_numero
INNER JOIN tbl_libro
ON tbl_prestamo.lib_copiaISBN=tbl_libro.lib_isbn$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_listaAutoresejem1` ()   SELECT aut_codigo,aut_apellido
FROM tbl_autor
ORDER BY aut_apellido DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tipoAutorejem2` (`variable` VARCHAR(20))   SELECT aut_apellido as 'Autor', tipo_autor
FROM tbl_autor
INNER JOIN tbl_tipoautores
ON aut_codigo=copiaAutor
WHERE tipo_autor=variable$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_socio` (`s1_numero` INT(11), `s1_nombre` VARCHAR(45), `s1_apellido` VARCHAR(45), `s1_direccion` VARCHAR(255), `s1_telefono` VARCHAR(10))   INSERT INTO tbl_socio(soc_numero,soc_nombre, soc_apellido, soc_direccion, soc_telefono)
VALUES (s1_numero, s1_nombre, s1_apellido, s1_direccion , s1_telefono)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_libroejem3` (`c1_isbn` BIGINT(20), `c2_titulo` VARCHAR(255), `c3_genero` VARCHAR(20), `c4_paginas` INT(11), `c5diaspres` TINYINT(4))   INSERT INTO
tbl_libro(lib_isbn,lib_titulo,lib_genero,lib_numeroPaginas,lib_diasPrestamo)
VALUES (c1_isbn,c2_titulo,c3_genero, c4_paginas,c5diaspres)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_book` (IN `nombre` VARCHAR(255))   SELECT *
FROM tbl_libro
WHERE lib_titulo=nombre$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `count1_socio` () RETURNS INT(11) DETERMINISTIC BEGIN
DECLARE cantidad INT;
SELECT COUNT(*) INTO cantidad
FROM tbl_socio;
RETURN cantidad;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `count_days_prestamo` (`id` BIGINT(20)) RETURNS INT(11) DETERMINISTIC BEGIN
DECLARE dias INT;
SELECT DATEDIFF(pres_fechaDevolucion,pres_fechaPrestamo) INTO dias
FROM tbl_prestamo
WHERE lib_copiaISBN=id;
RETURN dias;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aprendiz`
--

CREATE TABLE `aprendiz` (
  `id_aprendiz` int(11) NOT NULL,
  `apr_nombre` varchar(20) DEFAULT NULL,
  `apr_apellido` varchar(20) DEFAULT NULL,
  `apr_correo` varchar(20) DEFAULT NULL,
  `apr_ubicacion` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `aprendiz`
--

INSERT INTO `aprendiz` (`id_aprendiz`, `apr_nombre`, `apr_apellido`, `apr_correo`, `apr_ubicacion`) VALUES
(1, 'Juan', 'Perez', 'juan.perez@example.c', 'Ciudad A'),
(2, 'Maria', 'Gomez', 'maria.gomez@example.', 'Ciudad B'),
(3, 'Pedro', 'Lopez', 'pedro.lopez@example.', 'Ciudad C'),
(4, 'Laura', 'Torres', 'laura.torres@example', 'Ciudad A'),
(5, 'Carlos', 'Rodriguez', 'carlos.rodriguez@exa', 'Ciudad B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_autor`
--

CREATE TABLE `auditoria_autor` (
  `id_audi` int(10) NOT NULL,
  `aut_codigo_audi` int(11) DEFAULT NULL,
  `aut_apellido_antes` varchar(45) DEFAULT NULL,
  `aut_nacimiento_antes` date DEFAULT NULL,
  `aut_muerte_antes` date DEFAULT NULL,
  `aut_apellido_nuevo` varchar(45) DEFAULT NULL,
  `aut_nacimiento_nuevo` date DEFAULT NULL,
  `aut_muerte_nuevo` date DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(10) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auditoria_autor`
--

INSERT INTO `auditoria_autor` (`id_audi`, `aut_codigo_audi`, `aut_apellido_antes`, `aut_nacimiento_antes`, `aut_muerte_antes`, `aut_apellido_nuevo`, `aut_nacimiento_nuevo`, `aut_muerte_nuevo`, `audi_fechaModificacion`, `audi_usuario`, `audi_accion`) VALUES
(1, 120, NULL, NULL, NULL, 'De la torre', '1996-10-09', '2020-04-21', '2024-07-31 21:49:31', 'root@local', 'Insertar datos'),
(2, 98, 'Smith', '1974-12-21', '2018-07-21', 'Smith', '1998-10-09', '2018-07-21', '2024-07-31 22:00:48', 'root@local', 'Actualizacion'),
(4, 120, NULL, NULL, NULL, 'De la torre', '1996-10-09', '2020-04-21', '2024-08-01 07:30:03', 'root@local', 'Insertar datos'),
(5, 120, 'De la torre', '2020-04-21', '1996-10-09', NULL, NULL, NULL, '2024-08-01 07:31:12', 'root@local', 'Eliminar registro');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_libro`
--

CREATE TABLE `audi_libro` (
  `id_audi` int(10) NOT NULL,
  `lib_isbn_audi` bigint(20) DEFAULT NULL,
  `lib_titulo_antes` varchar(255) DEFAULT NULL,
  `lib_genero_antes` varchar(20) DEFAULT NULL,
  `lib_numeroPaginas_antes` int(11) DEFAULT NULL,
  `lib_diasPrestamo_antes` tinyint(4) DEFAULT NULL,
  `lib_titulo_nuevo` varchar(255) DEFAULT NULL,
  `lib_genero_nuevo` varchar(20) DEFAULT NULL,
  `lib_numeroPaginas_nuevo` int(11) DEFAULT NULL,
  `lib_diasPrestamo_nuevo` tinyint(4) DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(10) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_libro`
--

INSERT INTO `audi_libro` (`id_audi`, `lib_isbn_audi`, `lib_titulo_antes`, `lib_genero_antes`, `lib_numeroPaginas_antes`, `lib_diasPrestamo_antes`, `lib_titulo_nuevo`, `lib_genero_nuevo`, `lib_numeroPaginas_nuevo`, `lib_diasPrestamo_nuevo`, `audi_fechaModificacion`, `audi_usuario`, `audi_accion`) VALUES
(1, 9788426721006, 'sql', 'Comedia', 384, 15, 'sql', 'Comedia Coreana', 384, 15, '2024-08-09 07:59:15', 'root@local', 'ACTUALIZACION'),
(2, 9788426721006, 'sql', 'Comedia Coreana', 384, 15, NULL, NULL, NULL, NULL, '2024-08-09 08:09:19', 'root@local', 'Eliminar registro');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_socio`
--

CREATE TABLE `audi_socio` (
  `id_audi` int(10) NOT NULL,
  `socNumero_audi` int(11) DEFAULT NULL,
  `socNombre_anterior` varchar(45) DEFAULT NULL,
  `socApellido_anterior` varchar(45) DEFAULT NULL,
  `socDireccion_anterior` varchar(255) DEFAULT NULL,
  `socTelefono_anterior` varchar(10) DEFAULT NULL,
  `socNombre_nuevo` varchar(45) DEFAULT NULL,
  `socApellido_nuevo` varchar(45) DEFAULT NULL,
  `socDireccion_nuevo` varchar(255) DEFAULT NULL,
  `socTelefono_nuevo` varchar(10) DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(10) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_socio`
--

INSERT INTO `audi_socio` (`id_audi`, `socNumero_audi`, `socNombre_anterior`, `socApellido_anterior`, `socDireccion_anterior`, `socTelefono_anterior`, `socNombre_nuevo`, `socApellido_nuevo`, `socDireccion_nuevo`, `socTelefono_nuevo`, `audi_fechaModificacion`, `audi_usuario`, `audi_accion`) VALUES
(1, 4, 'María', 'Rodríguez', 'Carrera del Río 321, El Pueblo, Sevilla', '3012345678', 'María', 'Rodríguez', 'Calle 72 #\r\n2', '2928088', '2024-07-31 20:06:05', 'root@local', 'Actualización'),
(2, 5, 'Pedro', 'Martínez', 'Goldner Courts Suite 359', '459305693', NULL, NULL, NULL, NULL, '2024-07-31 20:08:55', 'root@local', 'Registro eliminado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `posiciones`
--

CREATE TABLE `posiciones` (
  `id` int(11) NOT NULL,
  `grupo` char(10) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `jugados` int(11) NOT NULL,
  `ganados` int(11) NOT NULL,
  `empatados` int(11) NOT NULL,
  `perdidos` int(11) NOT NULL,
  `puntos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_autor`
--

CREATE TABLE `tbl_autor` (
  `aut_codigo` int(11) NOT NULL,
  `aut_apellido` varchar(45) NOT NULL,
  `aut_nacimiento` date NOT NULL,
  `aut_muerte` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_autor`
--

INSERT INTO `tbl_autor` (`aut_codigo`, `aut_apellido`, `aut_nacimiento`, `aut_muerte`) VALUES
(98, 'Smith', '1998-10-09', '2018-07-21'),
(123, 'Taylor', '1980-04-15', '0000-00-00'),
(234, 'Medina', '1977-06-21', '2005-09-12'),
(345, 'Wilson', '1975-08-29', '0000-00-00'),
(432, 'Miller', '1981-10-26', '0000-00-00'),
(456, 'García', '1978-09-27', '2021-12-09'),
(567, 'Davis', '1983-03-04', '2010-03-28'),
(678, 'Silva', '1986-02-02', '0000-00-00'),
(765, 'López', '1976-07-08', '2022-10-14'),
(789, 'Rodríguez', '1985-12-10', '0000-00-00'),
(890, 'Brown', '1982-11-17', '0000-00-00'),
(901, 'Soto', '1979-05-13', '2015-11-05');

--
-- Disparadores `tbl_autor`
--
DELIMITER $$
CREATE TRIGGER `autor_delete` AFTER DELETE ON `tbl_autor` FOR EACH ROW INSERT INTO auditoria_autor(
aut_codigo_audi, 
aut_apellido_antes,
aut_nacimiento_antes,
aut_muerte_antes,
audi_fechaModificacion,
audi_usuario,
audi_accion)
VALUES(
old.aut_codigo,
old.aut_apellido,
old.aut_muerte,
old.aut_nacimiento,
NOW(),
CURRENT_USER(),
'Eliminar registro')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `autor_insert` BEFORE INSERT ON `tbl_autor` FOR EACH ROW INSERT INTO auditoria_autor(
aut_codigo_audi , 
aut_apellido_nuevo,
aut_nacimiento_nuevo,
aut_muerte_nuevo,
audi_fechaModificacion,
audi_usuario,
audi_accion)
VALUES(
new.aut_codigo,
new.aut_apellido,
new.aut_nacimiento,
new.aut_muerte,
NOW(),
CURRENT_USER(),
'Insertar datos')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `autor_update` BEFORE UPDATE ON `tbl_autor` FOR EACH ROW INSERT INTO auditoria_autor(
aut_codigo_audi , 
aut_apellido_antes,
aut_nacimiento_antes,
aut_muerte_antes,
aut_apellido_nuevo,
aut_nacimiento_nuevo,
aut_muerte_nuevo,
audi_fechaModificacion,
audi_usuario,
audi_accion)
VALUES(
new.aut_codigo,
old.aut_apellido,
old.aut_nacimiento,
old.aut_muerte,
new.aut_apellido,
new.aut_nacimiento,
new.aut_muerte,
NOW(),
CURRENT_USER(),
'Actualizacion')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_libro`
--

CREATE TABLE `tbl_libro` (
  `lib_isbn` bigint(20) NOT NULL,
  `lib_titulo` varchar(255) NOT NULL,
  `lib_genero` varchar(20) NOT NULL,
  `lib_numeroPaginas` int(11) NOT NULL,
  `lib_diasPrestamo` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_libro`
--

INSERT INTO `tbl_libro` (`lib_isbn`, `lib_titulo`, `lib_genero`, `lib_numeroPaginas`, `lib_diasPrestamo`) VALUES
(1234567890, 'El Sueño de los Susurros', 'novela', 275, 7),
(1357924680, 'El Jardín de las Mariposas Perdidas', 'novela', 536, 7),
(2468135790, 'La Melodía de la Oscuridad', 'romance', 189, 7),
(2718281828, 'El Bosque de los Suspiros', 'novela', 387, 2),
(3141592653, 'El Secreto de las Estrellas Olvidadas', 'Misterio', 203, 7),
(5555555555, 'La Última Llave del Destino', 'cuento', 503, 7),
(7777777777, 'El Misterio de la Luna Plateada', 'Misterio', 422, 7),
(8642097531, 'El Reloj de Arena Infinito', 'novela', 321, 7),
(8888888888, 'La Ciudad de los Susurros', 'Misterio', 274, 1),
(9517530862, 'Las Crónicas del Eco Silencioso', 'fantasía', 448, 7),
(9876543210, 'El Laberinto de los Recuerdos', 'cuento', 412, 7),
(9999999999, 'El Enigma de los Espejos Rotos', 'romance', 156, 7);

--
-- Disparadores `tbl_libro`
--
DELIMITER $$
CREATE TRIGGER `audi_libro_delete` AFTER DELETE ON `tbl_libro` FOR EACH ROW INSERT INTO audi_libro(
    lib_isbn_audi,
    lib_titulo_antes,
    lib_genero_antes,
    lib_numeroPaginas_antes,
    lib_diasPrestamo_antes,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion)
    VALUES(
        old.lib_isbn,
        old.lib_titulo,
    	old.lib_genero,
    	old.lib_numeroPaginas,
    	old.lib_diasPrestamo,
        NOW(),
        CURRENT_USER(),
        'Eliminar registro')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audi_libro_update` BEFORE UPDATE ON `tbl_libro` FOR EACH ROW INSERT INTO audi_libro(
    lib_isbn_audi,
    lib_titulo_antes,
    lib_genero_antes,
    lib_numeroPaginas_antes,
    lib_diasPrestamo_antes,
    lib_titulo_nuevo,
    lib_genero_nuevo,
    lib_numeroPaginas_nuevo,
    lib_diasPrestamo_nuevo,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion)
    VALUES(
        new.lib_isbn,
        old.lib_titulo,
        old.lib_genero,
        old.lib_numeroPaginas,
        old.lib_diasPrestamo,
        new.lib_titulo,
        new.lib_genero,
        new.lib_numeroPaginas,
        new.lib_diasPrestamo,
    NOW(),
    CURRENT_USER(),
    'ACTUALIZACION')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_prestamo`
--

CREATE TABLE `tbl_prestamo` (
  `pres_id` varchar(20) NOT NULL,
  `pres_fechaPrestamo` date DEFAULT NULL,
  `pres_fechaDevolucion` date DEFAULT NULL,
  `soc_copiaNumero` int(11) DEFAULT NULL,
  `lib_copiaISBN` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_prestamo`
--

INSERT INTO `tbl_prestamo` (`pres_id`, `pres_fechaPrestamo`, `pres_fechaDevolucion`, `soc_copiaNumero`, `lib_copiaISBN`) VALUES
('pres3', '2023-04-09', '2024-08-11', 6, 2718281828),
('pres4', '2023-06-14', '2024-08-15', 9, 8888888888),
('pres5', '2023-07-02', '2024-08-09', 10, 5555555555),
('pres6', '2023-08-19', '2024-08-26', 12, 5555555555),
('pres7', '2023-10-24', '2024-10-27', 3, 1357924680),
('pres8', '2023-11-11', '2024-11-12', 4, 9999999999);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_socio`
--

CREATE TABLE `tbl_socio` (
  `soc_numero` int(11) NOT NULL,
  `soc_nombre` varchar(45) NOT NULL,
  `soc_apellido` varchar(45) NOT NULL,
  `soc_direccion` varchar(255) NOT NULL,
  `soc_telefono` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_socio`
--

INSERT INTO `tbl_socio` (`soc_numero`, `soc_nombre`, `soc_apellido`, `soc_direccion`, `soc_telefono`) VALUES
(1, 'Ana', 'Ruiz', 'Calle Primavera 123, Ciudad Jardín, Barcelona', '9123456780'),
(2, 'Andrés Felipe', 'Galindo Luna', 'Avenida del Sol 456, Pueblo Nuevo, Madrid', '2123456789'),
(3, 'Juan', 'González', 'Calle Principal 789, Villa Flores, Valencia', '2012345678'),
(4, 'María', 'Rodríguez', 'Calle 72 #\r\n2', '2928088'),
(6, 'Ana', 'López', 'Avenida Central 987, Villa Hermosa, Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Calle de la Luna 234, El Prado, Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Carrera del Mar 567, Playa Azul, Palma de Mallorca', '1312345678'),
(9, 'Luis', 'Hernández', 'Avenida de la Montaña 890, Monte Verde, Granada', '6101234567'),
(10, 'Andrea', 'García', 'Calle del Sol 432, La Colina, Zaragoza', '1112345678'),
(11, 'Alejandro', 'Torres', 'Carrera del Oeste 765, Ciudad Nueva, Murcia', '4951234567'),
(12, 'Sofia', 'Morales', 'Avenida del Mar 098, Costa Brava, Gijón', '5512345678'),
(14, 'Chris', 'Evans', '481 Well Suite 715', '349603056');

--
-- Disparadores `tbl_socio`
--
DELIMITER $$
CREATE TRIGGER `socios_after_delete` AFTER DELETE ON `tbl_socio` FOR EACH ROW INSERT INTO audi_socio(
socNumero_audi,
socNombre_anterior,
socApellido_anterior,
socDireccion_anterior,
socTelefono_anterior,
audi_fechaModificacion,
audi_usuario,
audi_accion)
VALUES(
old.soc_numero,
old.soc_nombre,
old.soc_apellido,
old.soc_direccion,
old.soc_telefono,
NOW(),
CURRENT_USER(),
'Registro eliminado')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socios_before_update` BEFORE UPDATE ON `tbl_socio` FOR EACH ROW INSERT INTO audi_socio(
socNumero_audi,
socNombre_anterior,
socApellido_anterior,
socDireccion_anterior,
socTelefono_anterior,
socNombre_nuevo,
socApellido_nuevo,
socDireccion_nuevo,
socTelefono_nuevo,
audi_fechaModificacion,
audi_usuario,
audi_accion)
VALUES(
new.soc_numero,
old.soc_nombre,
old.soc_apellido,
old.soc_direccion,
old.soc_telefono,
new.soc_nombre,
new.soc_apellido,
new.soc_direccion,
new.soc_telefono,
NOW(),
CURRENT_USER(),
'Actualización')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipoautores`
--

CREATE TABLE `tbl_tipoautores` (
  `copiaISBN` bigint(20) DEFAULT NULL,
  `copiaAutor` int(11) DEFAULT NULL,
  `tipo_autor` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbl_tipoautores`
--

INSERT INTO `tbl_tipoautores` (`copiaISBN`, `copiaAutor`, `tipo_autor`) VALUES
(1357924680, 123, 'Traductor'),
(1234567890, 123, 'Autor'),
(1234567890, 456, 'Coautor'),
(2718281828, 789, 'Traductor'),
(8888888888, 234, 'Autor'),
(2468135790, 234, 'Autor'),
(9876543210, 567, 'Autor'),
(1234567890, 890, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 345, 'Coautor'),
(5555555555, 678, 'Autor'),
(3141592653, 901, 'Autor'),
(9517530862, 432, 'Autor'),
(7777777777, 765, 'Autor'),
(9999999999, 98, 'Autor');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_aprendices`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_aprendices` (
`apr_nombre` varchar(20)
,`apr_correo` varchar(20)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_autores_libros`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_autores_libros` (
`lib_isbn` bigint(20)
,`lib_titulo` varchar(255)
,`aut_codigo` int(11)
,`aut_apellido` varchar(45)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_prestamos_socio`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_prestamos_socio` (
`soc_copiaNumero` int(11)
,`soc_numero` int(11)
,`pres_id` varchar(20)
,`soc_nombre` varchar(45)
,`soc_apellido` varchar(45)
,`lib_isbn` bigint(20)
,`lib_titulo` varchar(255)
,`lib_copiaISBN` bigint(20)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `view_aprendices`
--
DROP TABLE IF EXISTS `view_aprendices`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_aprendices`  AS SELECT `aprendiz`.`apr_nombre` AS `apr_nombre`, `aprendiz`.`apr_correo` AS `apr_correo` FROM `aprendiz` ORDER BY `aprendiz`.`apr_nombre` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_autores_libros`
--
DROP TABLE IF EXISTS `view_autores_libros`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_autores_libros`  AS SELECT `tbl_libro`.`lib_isbn` AS `lib_isbn`, `tbl_libro`.`lib_titulo` AS `lib_titulo`, `tbl_autor`.`aut_codigo` AS `aut_codigo`, `tbl_autor`.`aut_apellido` AS `aut_apellido` FROM (`tbl_autor` join `tbl_libro`) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_prestamos_socio`
--
DROP TABLE IF EXISTS `view_prestamos_socio`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_prestamos_socio`  AS SELECT `tbl_prestamo`.`soc_copiaNumero` AS `soc_copiaNumero`, `tbl_socio`.`soc_numero` AS `soc_numero`, `tbl_prestamo`.`pres_id` AS `pres_id`, `tbl_socio`.`soc_nombre` AS `soc_nombre`, `tbl_socio`.`soc_apellido` AS `soc_apellido`, `tbl_libro`.`lib_isbn` AS `lib_isbn`, `tbl_libro`.`lib_titulo` AS `lib_titulo`, `tbl_prestamo`.`lib_copiaISBN` AS `lib_copiaISBN` FROM ((`tbl_socio` join `tbl_prestamo`) join `tbl_libro`) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aprendiz`
--
ALTER TABLE `aprendiz`
  ADD PRIMARY KEY (`id_aprendiz`);

--
-- Indices de la tabla `auditoria_autor`
--
ALTER TABLE `auditoria_autor`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `audi_libro`
--
ALTER TABLE `audi_libro`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `posiciones`
--
ALTER TABLE `posiciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pais` (`pais`),
  ADD KEY `puntos` (`puntos`,`grupo`);

--
-- Indices de la tabla `tbl_autor`
--
ALTER TABLE `tbl_autor`
  ADD PRIMARY KEY (`aut_codigo`);

--
-- Indices de la tabla `tbl_libro`
--
ALTER TABLE `tbl_libro`
  ADD PRIMARY KEY (`lib_isbn`),
  ADD KEY `index_libro` (`lib_titulo`);

--
-- Indices de la tabla `tbl_prestamo`
--
ALTER TABLE `tbl_prestamo`
  ADD PRIMARY KEY (`pres_id`),
  ADD KEY `soc_copiaNumero` (`soc_copiaNumero`),
  ADD KEY `lib_copiaISBN` (`lib_copiaISBN`);

--
-- Indices de la tabla `tbl_socio`
--
ALTER TABLE `tbl_socio`
  ADD PRIMARY KEY (`soc_numero`);

--
-- Indices de la tabla `tbl_tipoautores`
--
ALTER TABLE `tbl_tipoautores`
  ADD KEY `copiaISBN` (`copiaISBN`),
  ADD KEY `copiaAutor` (`copiaAutor`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `aprendiz`
--
ALTER TABLE `aprendiz`
  MODIFY `id_aprendiz` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `auditoria_autor`
--
ALTER TABLE `auditoria_autor`
  MODIFY `id_audi` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `audi_libro`
--
ALTER TABLE `audi_libro`
  MODIFY `id_audi` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  MODIFY `id_audi` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `posiciones`
--
ALTER TABLE `posiciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbl_prestamo`
--
ALTER TABLE `tbl_prestamo`
  ADD CONSTRAINT `tbl_prestamo_ibfk_1` FOREIGN KEY (`soc_copiaNumero`) REFERENCES `tbl_socio` (`soc_numero`),
  ADD CONSTRAINT `tbl_prestamo_ibfk_2` FOREIGN KEY (`lib_copiaISBN`) REFERENCES `tbl_libro` (`lib_isbn`);

--
-- Filtros para la tabla `tbl_tipoautores`
--
ALTER TABLE `tbl_tipoautores`
  ADD CONSTRAINT `tbl_tipoautores_ibfk_1` FOREIGN KEY (`copiaISBN`) REFERENCES `tbl_libro` (`lib_isbn`),
  ADD CONSTRAINT `tbl_tipoautores_ibfk_2` FOREIGN KEY (`copiaAutor`) REFERENCES `tbl_autor` (`aut_codigo`);

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `minuto_eliminar_prestamos` ON SCHEDULE EVERY 1 MINUTE STARTS '2024-08-08 06:53:50' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM tbl_prestamo
    WHERE pres_fechaDevolucion <= NOW() - INTERVAL 1 YEAR;
    #datos menores a la fecha actual - 1 año
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
