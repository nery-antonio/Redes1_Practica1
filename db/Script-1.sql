create database proyecto_redes;

use proyecto_redes;

create table vendedor(
	id_vendedor int PRIMARY KEY NOT NULL AUTO_INCREMENT,
	dpi varchar(15) NOT NULL,
	nombre varchar(15) NOT NULL,
	apellido varchar(15) NOT NULL,
	direccion varchar(20) NOT NULL,
	telefono varchar(8) NOT NULL	
);

CREATE TABLE venta(
	id_venta int PRIMARY KEY NOT NULL AUTO_INCREMENT,
	id_vendedor int NOT NULL,
	fecha varchar(20) NOT NULL,
	producto varchar(20) NOT NULL,
	FOREIGN KEY (id_vendedor) REFERENCES vendedor(id_vendedor)
);

CREATE TABLE producto(
	id_producto int PRIMARY KEY NOT NULL AUTO_INCREMENT,
	nombre_producto varchar(20) NOT NULL,
	autor varchar(20) NOT NULL
)
