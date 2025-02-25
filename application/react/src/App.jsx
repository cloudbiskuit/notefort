import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [mysqlaRecords, setMysqlaRecords] = useState([]);
  const [mysqlbRecords, setMysqlbRecords] = useState([]);
  const [message, setMessage] = useState('');

  
  useEffect(() => {
    fetchRecords();
  }, []);

  const fetchRecords = async () => {
    try {
      const [mysqlaRes, mysqlbRes] = await Promise.all([
        axios.get('/nodejsa/api/records'), // Call nodejsa REST GET API to fetch records 
        axios.get('/nodejsb/api/records'), // Call nodejsb REST GET API to fetch records
      ]);
      setMysqlaRecords(mysqlaRes.data);
      setMysqlbRecords(mysqlbRes.data);
    } catch (err) {
      console.error('Error fetching records:', err);
    }
  };

  const handleInsert = async () => {
    if (!message.trim()) {
      alert('Message cannot be empty');
      return;
    }
    try {
      await axios.post('/nodejsa/api/records', { msg: message }); // Call nodejsa REST POST API to insert a record. No need to call any nodejsb REST POST API as it will be consumed from RabbitMQ.
      setMessage('');
      fetchRecords(); // Refresh records after inserting new records
    } catch (err) {
      console.error('Error inserting record:', err);
      alert('Failed to insert record');
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>NOTEFORT</h1>

        <div className="input-section">
          <input
            type="text"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            placeholder="Write your note here.."
          />
          <button onClick={handleInsert} style={{ marginLeft: '10px' }}>Insert</button>
        </div>

        <div className="records-section">
          <h2>NODEJS-A</h2>
          <ul style={{ listStyleType: 'none' }}>
            {mysqlaRecords.map((record) => (
              <li key={record.id}>
               " <strong>{record.msg}</strong> " note was saved and a copy is sent to NODEJS-B using RABBITMQ 
              </li>
            ))}
          </ul>

          <h2>NODEJS-B</h2>
          <ul style={{ listStyleType: 'none' }}>
            {mysqlbRecords.map((record) => (
              <li key={record.id}>
                " <strong>{record.msgcp}</strong> " note was received and a copy of it is saved
              </li>
            ))}
          </ul>
        </div>
      </header>
    </div>
  );
}

export default App;
