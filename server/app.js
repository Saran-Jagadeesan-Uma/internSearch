const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./db');
const userRoutes = require('./routes/userRoutes');
const postingRoutes = require('./routes/postingRoutes');
const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(bodyParser.json());


app.get('/university', (req, res) => {
    db.query('SELECT * FROM University', (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Database query error' });
        }
        res.json(results);
    });
});

app.get('/company', (req, res) => {
    db.query('SELECT * FROM Company', (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Database query error' });
        }
        res.json(results);
    });
});
app.use('/users',userRoutes);
app.use('/postings', postingRoutes)

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});