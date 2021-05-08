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


INSERT INTO vendedor (dpi,nombre,apellido,direccion,telefono) 
VALUES 
('3543014921929','Daryl','Conley',"8024 Vulputate Avenue",'6647-7503'),
('8360875202037','Mollie','Emerson',"744-9438 Mauris. Street",'5161-7523'),
('9181633351535','Pandora','Sears',"P.O. Box 803, 443 In Rd.",'8655-7121'),
('9212580219515','Jade','Bush',"391-5350 Quam, Rd.",'3336-9411'),
('3344090939751','Blake','Lynn',"'345-9097 Eros St.",'9424-7748'),
('9962793495920','Fiona','Erickson',"4991 Sem St.",'1990-2615'),
('8129151710374','Iris','Pace','Ap #853-5704 Pellentesque St.',"1688-7429");