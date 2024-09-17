-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-09-2024 a las 17:13:03
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bibioteca`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarTelefonoDireccionSocio` (IN `socioNumero` INT, IN `nuevoTelefono` VARCHAR(10), IN `nuevaDireccion` VARCHAR(255))   BEGIN
    UPDATE biblioteca.tbl_socio
    SET soc_telefono = nuevoTelefono,
        soc_direccion = nuevaDireccion
    WHERE soc_numero = socioNumero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarTelefonoYDireccionSocio` (IN `p_soc_numero` INT, IN `p_nuevo_telefono` VARCHAR(10), IN `p_nueva_direccion` VARCHAR(255))   BEGIN
    UPDATE biblioteca.tbl_socio
    SET soc_telefono = p_nuevo_telefono,
        soc_direccion = p_nueva_direccion
    WHERE soc_numero = p_soc_numero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarLibroPorNombre` (IN `p_nombre` VARCHAR(255))   BEGIN
    SELECT
        lib_isbn,
        lib_titulo,
        lib_genero,
        lib_numeroPaginas,
        lib_diasPrestamo
    FROM
        biblioteca.tbl_libro
    WHERE
        lib_titulo LIKE CONCAT('%', p_nombre, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarPorNombreDelLibro` (IN `p_nombreLibro` VARCHAR(100))   BEGIN
    SELECT 
        l.lib_isbn,
        l.lib_titulo,
        l.lib_genero,
        l.lib_numeroPaginas,
        l.lib_diasPrestamo
    FROM 
        biblioteca.tbl_libro AS l
    WHERE 
        l.lib_titulo LIKE CONCAT('%', p_nombreLibro, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarLibro` (IN `p_lib_isbn` BIGINT)   BEGIN
    -- Verificar dependencias
    DECLARE v_dependencias INT;

    SELECT COUNT(*) INTO v_dependencias
    FROM biblioteca.tbl_prestamo
    WHERE lib_copiaISBN = p_lib_isbn;

    IF v_dependencias = 0 THEN
        DELETE FROM biblioteca.tbl_libro
        WHERE lib_isbn = p_lib_isbn;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar el libro porque tiene dependencias';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLibrosPrestamo` ()   BEGIN
    SELECT l.*, s.*
    FROM libro l
    INNER JOIN prestamo p ON l.libro_id = p.libro_id
    INNER JOIN socio s ON p.socio_id = s.socio_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLibrosWithTipoAutores` ()   BEGIN
    SELECT
        l.lib_isbn,
        l.lib_titulo,
        l.lib_genero,
        l.lib_numeroPaginas,
        l.lib_diasPrestamo,
        t.copiaAutor,
        t.tipo_autor
    FROM
        biblioteca.tbl_libro l
    LEFT JOIN
        biblioteca.tbl_tipoautores t ON l.lib_isbn = t.copiaISBN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductoWithEntradas` ()   BEGIN
    SELECT
        p.productoID,
        p.nombrePro,
        p.precioPro,
        p.cantidadTotalPro,
        e.entradaID,
        e.fechaEntrada,
        e.cantidadEntrada
    FROM
        biblioteca.producto p
    LEFT JOIN
        biblioteca.entrada e ON p.productoID = e.productoID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSocioPrestamo` ()   BEGIN
    SELECT s.*, p.*
    FROM socio s
    LEFT JOIN prestamo p ON s.socio_id = p.socio_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSocioWithAudit` ()   BEGIN
    SELECT
        s.soc_numero,
        s.soc_nombre,
        s.soc_apellido,
        s.soc_direccion,
        s.soc_telefono,
        a.id_audi,
        a.socNombre_anterior,
        a.socApellido_anterior,
        a.socDireccion_anterior,
        a.socTelefono_anterior,
        a.socNombre_nuevo,
        a.socApellido_nuevo,
        a.socDireccion_nuevo,
        a.socTelefono_nuevo,
        a.audi_fechaModificacion,
        a.audi_usuario,
        a.audi_accion
    FROM
        biblioteca.tbl_socio s
    LEFT JOIN
        biblioteca.audi_socio a ON s.soc_numero = a.socNumero_audi;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSocioWithPrestamos` ()   BEGIN
    SELECT
        s.soc_numero,
        s.soc_nombre,
        s.soc_apellido,
        s.soc_direccion,
        s.soc_telefono,
        p.pres_id,
        p.pres_fechaPrestamo,
        p.pres_fechaDevolucion,
        p.lib_copiaISBN
    FROM
        biblioteca.tbl_socio s
    LEFT JOIN
        biblioteca.tbl_prestamo p ON s.soc_numero = p.soc_copiaNumero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_leftjoin` ()   SELECT*FROM tbl_socio
LEFT JOIN tbl_prestamo
ON soc_numero=soc_copiaNumero$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_listaAutores` ()   SELECT aut_codigo,aut_apellido
FROM tbl_autor
ORDER BY aut_apellido DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tipoAutor` (`variable` VARCHAR(20))   SELECT aut_apellido as 'Autor', tipoAutor
FROM tbl_autor
INNER JOIN tbl_tipoautores
ON aut_codigo=copiaAutor
WHERE tipoAutor=variable$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tipo_autor` (`variable` VARCHAR(20))   SELECT aut_apellido as 'Autor', tipo_autor
FROM tbl_autor
INNER JOIN tbl_tipoautores
ON aut_codigo=copiaAutor
WHERE tipo_autor=variable$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_libro` (`c1_isbn` BIGINT(20), `c2_titulo` VARCHAR(255), `c3_genero` VARCHAR(20), `c4_paginas` INT(11), `c5diaspres` TINYINT(4))   INSERT INTO
tbl_libro(lib_isbn,lib_titulo,lib_genero,lib_numeroPaginas,lib_diasPrestamo)
VALUES (c1_isbn,c2_titulo,c3_genero, c4_paginas,c5diaspres)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerSociosConPrestamos` ()   BEGIN
    SELECT 
        s.soc_numero, 
        s.soc_nombre, 
        s.soc_apellido, 
        s.soc_direccion, 
        s.soc_telefono,
        p.pres_id,
        p.pres_fechaPrestamo,
        p.pres_fechaDevolucion,
        p.soc_copiaNumero,
        p.lib_copiaISBN
    FROM 
        biblioteca.tbl_socio AS s
    LEFT JOIN 
        biblioteca.tbl_prestamo AS p
    ON 
        s.soc_numero = p.soc_copiaNumero;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `CantidadDeSociosRegistrados` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE v_cantidad INT;

    SELECT COUNT(*) INTO v_cantidad
    FROM biblioteca.tbl_socio;

    RETURN v_cantidad;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `CantidadSociosRegistrados` () RETURNS INT(11)  BEGIN
    DECLARE totalSocios INT;
    SELECT COUNT(*) INTO totalSocios FROM biblioteca.tbl_socio;
    RETURN totalSocios;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ContarSocios` () RETURNS INT(11)  BEGIN
    DECLARE totalSocios INT;

    SELECT COUNT(*) INTO totalSocios FROM socios;

    RETURN totalSocios;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `DiasEnPrestamo` (`idlibro` BIGINT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE v_dias INT;

    SELECT DATEDIFF(p.pres_fechaDevolucion, p.pres_fechaPrestamo) INTO v_dias
    FROM biblioteca.tbl_prestamo p
    WHERE p.lib_copiaISBN = idlibro
    LIMIT 1;

    RETURN v_dias;
END$$

DELIMITER ;

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
(2, 1, 'Ana', 'Ruiz', 'Calle Primavera 123, Ciudad Jardín, Barcelona', '9123456780', 'Ana', 'Ruiz', 'Nueva dirección', '1234567890', '2024-08-01 08:06:21', 'root@local', 'Actualización'),
(3, 1, 'Ana', 'Ruiz', 'Nueva dirección', '1234567890', 'Ana', 'Ruiz', 'Nueva Dirección, Ciudad, País', '1234567890', '2024-08-01 09:22:22', 'root@local', 'Actualización');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrada`
--

CREATE TABLE `entrada` (
  `entradaID` int(11) NOT NULL,
  `fechaEntrada` date NOT NULL,
  `cantidadEntrada` int(11) NOT NULL,
  `productoID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `entrada`
--

INSERT INTO `entrada` (`entradaID`, `fechaEntrada`, `cantidadEntrada`, `productoID`) VALUES
(1, '2020-10-06', 10, 1),
(2, '2020-10-06', 13, 1),
(3, '2020-10-06', 50, 2);

--
-- Disparadores `entrada`
--
DELIMITER $$
CREATE TRIGGER `entrada_producto` BEFORE INSERT ON `entrada` FOR EACH ROW BEGIN
    UPDATE Producto 
    SET cantidadTotalPro=Producto.cantidadTotalPro+new.cantidadEntrada
    WHERE new.productoID=Producto.productoID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `productoID` int(11) NOT NULL,
  `nombrePro` varchar(30) NOT NULL,
  `precioPro` int(11) NOT NULL,
  `cantidadTotalPro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`productoID`, `nombrePro`, `precioPro`, `cantidadTotalPro`) VALUES
(1, 'Panela', 200, 23),
(2, 'Pastas doria familiar', 3500, 50);

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
(98, 'Smith', '1974-12-21', '2018-07-21'),
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
(9999999999, 'El Enigma de los Espejos Rotos', 'romance', 156, 7),
(9788426721006, 'sql', 'ingenieria', 384, 15);

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
('pres1', '2023-01-15', '2023-01-20', 1, 1234567890),
('pres2', '2023-02-03', '2023-02-04', 2, 9999999999),
('pres3', '2023-04-09', '2023-04-11', 6, 2718281828),
('pres4', '2023-06-14', '2023-06-15', 9, 8888888888),
('pres5', '2023-07-02', '2023-07-09', 10, 5555555555),
('pres6', '2023-08-19', '2023-08-26', 12, 5555555555),
('pres7', '2023-10-24', '2023-10-27', 3, 1357924680),
('pres8', '2023-11-11', '2023-11-12', 4, 9999999999);

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
(0, '', '', '', ''),
(1, 'Ana', 'Ruiz', 'Nueva Dirección, Ciudad, País', '1234567890'),
(2, 'Andrés Felipe', 'Galindo Luna', 'Avenida del Sol 456, Pueblo Nuevo, Madrid', '2123456789'),
(3, 'Juan', 'González', 'Calle Principal 789, Villa Flores, Valencia', '2012345678'),
(4, 'María', 'Rodríguez', 'Carrera del Río 321, El Pueblo, Sevilla', '3012345678'),
(5, 'Pedro', 'Martínez', 'Calle del Bosque 654, Los Pinos, Málaga', '1234567812'),
(6, 'Ana', 'López', 'Avenida Central 987, Villa Hermosa, Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Calle de la Luna 234, El Prado, Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Carrera del Mar 567, Playa Azul, Palma de Mallorca', '1312345678'),
(9, 'Luis', 'Hernández', 'Avenida de la Montaña 890, Monte Verde, Granada', '6101234567'),
(10, 'Andrea', 'García', 'Calle del Sol 432, La Colina, Zaragoza', '1112345678'),
(11, 'Alejandro', 'Torres', 'Carrera del Oeste 765, Ciudad Nueva, Murcia', '4951234567'),
(12, 'Sofia', 'Morales', 'Avenida del Mar 098, Costa Brava, Gijón', '5512345678');

--
-- Disparadores `tbl_socio`
--
DELIMITER $$
CREATE TRIGGER `socios_after_delete` AFTER DELETE ON `tbl_socio` FOR EACH ROW BEGIN
    INSERT INTO audi_socio (
        socNumero_audi,
        socNombre_anterior,
        socApellido_anterior,
        socDireccion_anterior,
        socTelefono_anterior,
        audi_fechaModificacion,
        audi_usuario,
        audi_accion
    )
    VALUES (
        OLD.soc_numero,
        OLD.soc_nombre,
        OLD.soc_apellido,
        OLD.soc_direccion,
        OLD.soc_telefono,
        NOW(),
        CURRENT_USER(),
        'Registro eliminado'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socios_before_update` BEFORE UPDATE ON `tbl_socio` FOR EACH ROW BEGIN
    INSERT INTO audi_socio (
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
        audi_accion
    )
    VALUES (
        OLD.soc_numero,
        OLD.soc_nombre,
        OLD.soc_apellido,
        OLD.soc_direccion,
        OLD.soc_telefono,
        NEW.soc_nombre,
        NEW.soc_apellido,
        NEW.soc_direccion,
        NEW.soc_telefono,
        NOW(),
        CURRENT_USER(),
        'Actualización'
    );
END
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
(9999999999, 98, 'Autor'),
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

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  ADD PRIMARY KEY (`id_audi`),
  ADD KEY `idx_socNumero_audi` (`socNumero_audi`),
  ADD KEY `idx_audi_usuario` (`audi_usuario`);

--
-- Indices de la tabla `entrada`
--
ALTER TABLE `entrada`
  ADD PRIMARY KEY (`entradaID`),
  ADD KEY `productoID` (`productoID`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`productoID`);

--
-- Indices de la tabla `tbl_autor`
--
ALTER TABLE `tbl_autor`
  ADD PRIMARY KEY (`aut_codigo`);

--
-- Indices de la tabla `tbl_libro`
--
ALTER TABLE `tbl_libro`
  ADD PRIMARY KEY (`lib_isbn`);

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
-- AUTO_INCREMENT de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  MODIFY `id_audi` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `entrada`
--
ALTER TABLE `entrada`
  ADD CONSTRAINT `entrada_ibfk_1` FOREIGN KEY (`productoID`) REFERENCES `producto` (`productoID`);

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
