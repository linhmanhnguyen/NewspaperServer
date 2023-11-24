const mysql = require('mysql2');

const connection =  mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'aB011602',
    database: 'Newspaper'
})

module.exports = connection;