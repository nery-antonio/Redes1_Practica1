## Topologia 2

##### Maquinas virtuales

Antes de  armar la topologia, vamos a crear las maquinas virtuales y asociarlas al GNS3. Para eso primero se crean adaptadores  de red para poder usarlas en la maquinas virtuales.  Para crearlas hay que dirigirse a **edit** y luego **Preferences**. Saldrá una ventana emergente y en la sidebar de la izquierda seleccionamos **VMware**. Ahora nos dirigimos a la opción de **Advanced local settings**, salen las opciones para crear los adaptadores y seleccionamos la cantidad de adaptadores que queremos, en este caso se necesita 3 por lo que seleccionamos **vmnet2** a **vmnet4** y por ultimo se da en aplicar, aceptar y listo, ya la tenemos listas.

<img src="C:\Users\Diego Caballeros\Documents\Redes1\Laboratorio\Proyecto\Documentacion\Imagenes\Img20.png" alt="Img20" style="zoom: 50%;" />

Ahora hay que hacer las maquinas virtuales, para esta topología se necesitan 3 maquinas. La imagenes utilizadas son **Antix Linux y Xubuntu**. Para la creación de estas maquinas no se requiere alguna configuración en especial, por lo que se dejaron con las configuración por default. Después de ser creadas se asocia a cada maquina virtual un Adaptador de Red de las que creamos anteriormente

<img src="C:\Users\Diego Caballeros\Documents\Redes1\Laboratorio\Proyecto\Documentacion\Imagenes\Img8.png" alt="Img8" style="zoom: 50%;" />

Por ultimo hay que vincular las maquinas virtual con GNS3 para poder utilizarlas en la topología, para eso hay que dirigirse a **edit** y luego **Preferences**, ahora se elige la opción **VMware VMs**. 

<img src=".\Imagenes\Img6.png" alt="Img6" style="zoom:50%;" />

Para agregarlas le damos en ***New***  y saldrá una ventana emergente donde aparecerán todas las maquinas virtuales que tenemos en VMware, seleccionamos las que creamos y le damos en **finish** 

<img src=".\Imagenes\Img7.png" alt="Img7" style="zoom:50%;" />

Por ultimo nos sale todas las características que tiene nuestra maquina virtual y para guardar los cambios le damos Apply y ok. Listo ahora están disponibles para poder usarse en nuestra topología.

<img src=".\Imagenes\Img9.png" alt="Img9" style="zoom:50%;" />

Ahora que tenemos lista nuestras maquinas virtuales en GNS3 continuamos con armar la topologia,  quedando de la siguiente forma:

<img src=".\Imagenes\12.png" alt="12"  />

##### Configuracion VTP (EthernetSwitch1)

Ahora hay con las configuraciones primero se comenzara a crear un ***VTP*** . Primero se empieza con el **EthernetSwitch1** quien sera el que este en modo server. Los comandos a utilizar son los siguientes:

```bash
conf t
vtp domain redes1gp10
vtp password redes1gp10
vtp mode server
end

sh vtp status
```

<img src=".\Imagenes\1.png" alt="1" style="zoom:80%;" />

Ahora sigue crear las respectivas VLAN de cada area, las cuales con las siguientes:

| VLAN |      AREA       |
| :--: | :-------------: |
|  10  | Recursos Huanos |
|  20  |  Contabilidad   |
|  30  |     Ventas      |
|  40  |   Informatica   |

```bash
conf t
vlan 10
name RHUMANOS
exit
vlan 20
name CONTABILIDAD
exit
vlan 30
name VENTAS
exit
vlan 40
name INFORMATICA
end
```

<img src=".\Imagenes\2.png" alt="2" style="zoom:90%;" />

Por ultimo se modificar los puertos que se estan usando a modo **Trunk** con el siguiente codigo

```bash
conf t
int <puerto>
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,40,1002-1005
exit
```

<img src=".\Imagenes\3.png" alt="3" style="zoom:80%;" />

Para guardar los cambios

```powershell
copy running-config startup-config
```

##### Configuracion EthernetSwitch 2, 3, 4

Para los otros EthernetSwitch solo se debe configurar un VTP en modo cliente y los puertos en uso en modo truncal. Para configurar el modo VTP es el siguiente codigo:

```powershell
conf t
vtp domain redes1gp10
vtp password redes1gp10
vtp mode client
end
```

<img src=".\Imagenes\4.png" alt="4" style="zoom:80%;" />

Ahora ha modificar los puertos que se estan usando a modo **Trunk** con el siguiente codigo

```bash
conf t
int <puerto>
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,40,1002-1005
exit
```

<img src=".\Imagenes\3.png" alt="3" style="zoom:80%;" />

Para poder asegurarse que funciono se puede usar el siguiente comando:

```bash
sh vtp status
```

<img src=".\Imagenes\5.png" alt="5" style="zoom:80%;" />

Para guardar los cambios

```powershell
copy running-config startup-config
```

##### Portchannel

Ahora hay que configurar varios puertos para que sean uno solo (portchannel) entre los EthernetSwitch 1, 2, 3, 4 . Para eso se utiliza el siguiente codigo:

```bash
conf t
int range f1/<rango>
channel-group <numero que pertenece> mode on
exit
```

<img src=".\Imagenes\6.png" alt="6" style="zoom:90%;" />

Para guardar los cambios

```powershell
copy running-config startup-config
```

##### Configurar Router

Antes de configurar hay que el calculo de las subredes con medio del **VLSM** para poder satisfacer las necesidades de la  empresa. La red disponible es ***192.168.110.0/24***  y los resultados son los siguientes:

|     Area     | VLAN |  Direccion de  red  |     Mascara     | Primera Asignable |    Broadcast    | Host Necesarios | Cantidad Host |
| :----------: | :--: | :-----------------: | :-------------: | :---------------: | :-------------: | :-------------: | :-----------: |
|    Ventas    |  30  |  192.168.110.0 /25  | 255.255.255.128 |   192.168.110.1   | 192.168.110.127 |       123       |      126      |
| Informatica  |  40  | 192.168.110.128 /26 | 255.255.255.192 |  192.168.110.129  | 192.168.110.191 |       37        |      62       |
|     RRHH     |  10  | 192.168.110.192 /27 | 255.255.255.224 |  192.168.110.193  | 192.168.110.223 |       21        |      30       |
| Contabilidad |  20  | 192.168.110.224 /28 | 255.255.255.240 |  192.168.110.225  | 192.168.110.239 |        8        |      14       |

Ahora toca configurar el router, primero se configurar las sub interfaces y se configuran en modo Trunk, con los siguientes comandos:

```bash
# ------------- VENTAS
conf t
int f0/1.1
encapsulation dot1q 30
ip address 192.168.110.1 255.255.255.128 192.168.110.127
exit
```

<img src=".\Imagenes\7.png" alt="7" style="zoom:95%;" />

```bash
# ------------- INFORMATICA
int f0/1.2
encapsulation dot1q 40
ip address 192.168.110.129 255.255.255.192
exit

```

<img src=".\Imagenes\8.png" alt="8" style="zoom:90%;" />

```bash
# ------------- RHUMANOS
int f0/1.3
encapsulation dot1q 10
ip address 192.168.110.193 255.255.255.224
exit
```

![9](.\Imagenes\9.png)

```bash
# ------------- CONTABILIDAD
int f0/1.4
encapsulation dot1q 20
ip address 192.168.110.225 255.255.255.240
exit
```

![10](.\Imagenes\10.png)



```bash
int f0/1.1
ip dhcp pool venta
network 192.168.110.0 255.255.255.128
default-route 192.168.110.1
exit
```

<img src=".\Imagenes\11.png" alt="11" style="zoom:90%;" />

Para  verificar que todo salio correctamente se puede usar el siguiente comando

```powershell
show ip dhcp pool
```

Para guardar los cambios

```powershell
copy running-config startup-config
```



##### Configurar los Switch

Ahora toca configurar los puertos de los switch, los que esten conectados con otro switch deben quedar en modo Truncal y los que esten conectados a una maquina en modo Access

<img src="C:\Users\Diego Caballeros\Documents\Redes1\Laboratorio\Proyecto\Documentacion\Imagenes\13.png" alt="13" style="zoom:80%;" />

##### Obtener IP automaticamente

Por ultimo hay que obtener una ip automaticamente en las computadoras, para esto se utiliza el siguiente comando

```bash
ip dhcp
save
```

