const express = require('express');
const { MongoClient } = require('mongodb');
const app = express();
const port = process.env.PORT || 3000;

const mongoUri = process.env.MONGO_URI || 'mongodb://localhost:27017/test';
let client;

app.get('/', async (req, res) => {
  try {
    if (!client) {
      client = new MongoClient(mongoUri);
      await client.connect();
    }
    const db = client.db('test');
    const count = await db.collection('visits').countDocuments();
    res.send(`Hello! Visits collection has ${count} documents.`);
  } catch (err) {
    console.error(err);
    res.status(500).send('DB error: ' + err.message);
  }
});

app.listen(port, () => console.log(`App listening on ${port}`));
