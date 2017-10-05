var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var db_config = require('../config/connect-db');
var conn = mysql.createConnection(db_config);

var knex = require('knex')({
    client: 'mysql',
    connection: db_config
});

router.get('/knex', (req, res) => {

    knex.select().table('command').then((raw) => {
        res.json(raw);
    });

});



router.get('/', function(req, res, next) {
    res.send('API is OK.');
});

router.get('/sql', (req, res) => {

    /*
    var sql = "select * from command where cstatus='on'";
    conn.query(sql, (err, result) => {
        if (err) throw err;
        res.json(result);
    });
    */
    knex('command').where('cstatus', 'on').then((raw) => {
        res.json(raw);
    });

});

router.post('/send/:table', (req, res) => {
    var table = req.params.table;
    var data = req.body;
    var sql = 'replace  into ' + table + ' set ?';

    conn.query(sql, [data], (err) => {
        if (err) throw err;
        res.json({ 'status': 'ok' });
    });
});

module.exports = router;