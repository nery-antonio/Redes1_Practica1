const cors = require("cors");
const express = require("express");
var bodyParser = require('body-parser')


const app = express().use(cors());
var jsonParser = bodyParser.json()

const db_pool = require('./database');
// viewed at http://localhost:3000

app.get('/producto', jsonParser, async function (req, res) {
    const producto = await db_pool.query(`SELECT nombre_producto , autor   FROM producto;`);
    response = {
        code: 200,
        data: producto
    }
    res.send(response)
});

app.post('/producto', jsonParser, async function (req, res) {
    const { nombre, autor } = req.body;

    const new_producto = {
        nombre_producto: nombre,
        autor: autor
    }

    console.log(new_producto)

    response = {}

    db_pool.query('INSERT INTO producto set ?', [new_producto]);
    response = {
        code: 200,
        message: `Producto ${nombre} agregado`
    }

    res.send(response)
});

app.get('/vendedores', jsonParser, async function (req, res) {
    const vendedor = await db_pool.query(`SELECT * FROM vendedor;`);
    response = {
        code: 200,
        data: vendedor
    }
    res.send(response)
});


app.get('/ventas', jsonParser, async function (req, res) {
    const venta = await db_pool.query(`select concat(ven.nombre,' ' ,ven.apellido)as vendedor, v.fecha, v.producto from vendedor ven, venta v where ven.id_vendedor = v.id_vendedor;`);
    response = {
        code: 200,
        data: venta
    }
    res.send(response)
});

app.listen(3000);