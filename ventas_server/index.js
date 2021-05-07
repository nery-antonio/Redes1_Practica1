const cors = require("cors");
const express = require("express");
var bodyParser = require('body-parser')
var app = express();


const app = express().use(cors());
var jsonParser = bodyParser.json()

// viewed at http://localhost:3000

app.get('/libros', jsonParser, async function (req, res) {
    const libros = await db_pool.query(`SELECT * FROM libro;`);
    response = {
        code: 200,
        data: libros
    }
    res.send(response)
});

app.post('/producto', jsonParser, async function (req, res) {
    const { nombre, autor } = req.body;

    const new_producto = {
        nombre,
        autor
    }

    response = {}

    db_pool.query('INSERT INTO libro set ?', [new_producto]);
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
    const venta = await db_pool.query(`SELECT * FROM venta;`);
    response = {
        code: 200,
        data: venta
    }
    res.send(response)
});

app.listen(3000);