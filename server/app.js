// app.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./db'); // import the database connection
const userRoutes = require('./routes/userRoutes')
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

// Example API endpoint to create a new applicant
// app.post('/applicants', (req, res) => {
//     const { university_name, username, gender, date_of_birth, address_street_name, address_street_num, address_town, address_state, address_zipcode, race, veteran_status, disability_status, citizenship_status, gpa } = req.body;

//     const query = 'INSERT INTO Applicant (UNIVERSITY_NAME, USERNAME, GENDER, DATE_OF_BIRTH, ADDRESS_STREET_NAME, ADDRESS_STREET_NUM, ADDRESS_TOWN, ADDRESS_STATE, ADDRESS_ZIPCODE, RACE, VETERAN_STATUS, DISABILITY_STATUS, CITIZENSHIP_STATUS, GPA) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
//     const values = [university_name, username, gender, date_of_birth, address_street_name, address_street_num, address_town, address_state, address_zipcode, race, veteran_status, disability_status, citizenship_status, gpa];

//     db.query(query, values, (err, results) => {
//         if (err) {
//             return res.status(500).json({ error: 'Failed to create applicant' });
//         }
//         res.status(201).json({ message: 'Applicant created successfully', applicantId: results.insertId });
//     });
// });

app.use('/users',userRoutes);


// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});