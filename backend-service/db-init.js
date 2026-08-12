const fs = require("fs");
const mysql = require("mysql2/promise");

async function initializeDatabase() {
  let connection;

  try {
    connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      port: Number(process.env.DB_PORT || 3306),
      multipleStatements: true
    });

    console.log("Connected to RDS");

    const sql = fs.readFileSync("./database.sql", "utf8");

    await connection.query(sql);

    console.log("Database schema initialized successfully");
  } catch (error) {
    console.error("Database initialization failed:");
    console.error(error);

    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

initializeDatabase();