const mysql = require('mysql2');

const connection =  mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '011602',
    database: 'Newspaper'
})

module.exports = connection;