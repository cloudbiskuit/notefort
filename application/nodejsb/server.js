// server.js for nodejsb
const express = require('express');
const mysql = require('mysql2');
const amqp = require('amqplib');

const app = express();
app.use(express.json());

const PORT = 5000;

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
  console.log('Connected successfully to MySQL database mysqlb');
});

// Health check endpoint: Respond with 200 OK if healthy
app.get('/api/health', (req, res) => {
  res.status(200).send('OK');
});

// RabbitMQ consumption and MySQL insertion
(async () => {
  try {
    const connection = await amqp.connect(RABBITMQ_URL);
    const channel = await connection.createChannel();
    console.log('Connected successfullyto RabbitMQ');

    // Ensure the queue exists
    const queue = 'message_queue';
    await channel.assertQueue(queue);

    // Consume messages from the queue
    channel.consume(queue, (msg) => {
      if (msg !== null) {
        const message = JSON.parse(msg.content.toString());
        console.log('Received successfully message:', message);

        const { id, msg: msgContent } = message;
        db.query(
          'INSERT INTO main (ida, msgcp) VALUES (?, ?)',
          [id, msgContent],
          (err) => {
            if (err) {
              console.error('Error inserting record:', err);
            } else {
              console.log('Record successfully inserted into mysqlb:', { ida: id, msgcp: msgContent });
            }
          }
        );

        channel.ack(msg);
      }
    });
  } catch (err) {
    console.error('Error connecting to RabbitMQ:', err);
    process.exit(1);
  }
})();

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

// Start the server
app.listen(PORT, () => {
  console.log(`nodejsb successfully started on port ${PORT}`);
});
