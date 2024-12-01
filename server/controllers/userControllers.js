const db = require('../db'); 
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const loginUser = async(req,res)=>{
    const { username, password } = req.body;
    
    db.query('SELECT * FROM AppUser WHERE USERNAME = ?', [username], async (err, results) => {
        
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(400).json({ message: 'Invalid username or password' });

        const user = results[0];
        
        const isMatch = await bcrypt.compare(password, user.PASSWORD);
        
        if (!isMatch && password!=user.PASSWORD) return res.status(400).json({ message: 'Invalid username or password' });

        // Create JWT token
        const token = jwt.sign({ username: user.USERNAME }, process.env.JWT_SECRET, { expiresIn: '1h' });
        return res.json({ token,username });
    });
}

const userAppInfo = async(req,res)=>{
    const { username } = req.params;
    db.query("CALL GetApplicantInfo(?)", [username], async (err, results) => {
        
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(400).json({ message: 'Invalid username or password' });
                
        const user = results[0][0];
    
        return res.json(user);
    });
    
}

const registerUser = async(req,res)=>{
    const { username, password, first_name, last_name, email } = req.body;
    try {
        
        db.query('SELECT * FROM AppUser  WHERE USERNAME = ?', [username], async (err, results) => {
            if (err) return res.status(500).json({ error: err.message });
            if (results.length > 0) return res.status(400).json({ message: 'Username already exists' });

            // Hash password
            const hashedPassword = await bcrypt.hash(password, 10);

            // Insert new user
            db.query('INSERT INTO AppUser  (USERNAME, PASSWORD, FIRST_NAME, LAST_NAME, EMAIL) VALUES (?, ?, ?, ?, ?)', 
                [username, hashedPassword, first_name, last_name, email], (err, results) => {
                    if (err) return res.status(500).json({ error: err.message });
                    return res.status(201).json({ message: 'User  registered successfully' , username, email});
                });
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}

module.exports = {
    registerUser,
    loginUser,
    userAppInfo
}