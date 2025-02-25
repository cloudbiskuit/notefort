// server.js for nodejsa
const express = require('express');
const mysql = require('mysql2');
const amqp = require('amqplib');

const app = express();
app.use(express.json());

const PORT = 4000;

const DB_CONFIG = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
};

const RABBITMQ_URL = `amqp://${process.env.RABBITMQ_HOST || 'rabbitmq'}`;

// Database connection
const db = mysql.createConnection(DB_CONFIG);
db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    process.exit(1);
  }
  console.log('Connected successfully to MySQL database mysqla');
});

// RabbitMQ setup
let channel;
(async () => {
  try {
    const connection = await amqp.connect(RABBITMQ_URL);
    channel = await connection.createChannel();
    console.log('Connected successfully to RabbitMQ');
  } catch (err) {
    console.error('Error connecting to RabbitMQ:', err);
    process.exit(1);
  }
})();

// Health check endpoint: Respond with 200 OK if healthy
app.get('/api/health', (req, res) => {
  res.status(200).send('OK');
});

// GET API to fetch all records
app.get('/api/records', (req, res) => {
  db.query('SELECT * FROM main', (err, results) => {
    if (err) {
      console.error('Error fetching records:', err);
      return res.status(500).send('Error fetching records');
    }
    res.json(results);
  });
});

// POST API to insert a record [and produce a RabbitMQ message]
app.post('/api/records', (req, res) => {
  const { msg } = req.body;
  if (!msg) return res.status(400).send('Message is required');

  db.query('INSERT INTO main (msg) VALUES (?)', [msg], (err, result) => {
    if (err) {
      console.error('Error inserting record:', err);
      return res.status(500).send('Error inserting record');
    }
    else {
    console.log('Record successfully inserted into mysqla:', { id: result.insertId, msg: msg });
    const message = { id: result.insertId, msg };
    channel.sendToQueue('message_queue', Buffer.from(JSON.stringify(message)));
    console.log('Message successfully sent to RabbitMQ:', message);

    res.status(201).json(message);
    }
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`nodejsa successfully started on port ${PORT}`);
});
