import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { useAuth } from '../AuthContext'; // Import the auth context
import './FormStyles.css';
import { Link } from "react-router-dom";

const Login = () => {
    const [credentials, setCredentials] = useState({
        username: '',
        password: ''
    });
    const [message, setMessage] = useState({ text: '', type: '' });
    const navigate = useNavigate();
    const { login } = useAuth(); // Access the login function from AuthContext

    const handleChange = (e) => {
        const { name, value } = e.target;
        setCredentials({
            ...credentials,
            [name]: value
        });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const response = await axios.post('http://localhost:4000/users/login', credentials);
            localStorage.setItem('token', response.data.token); 
            login(response.data.token); 
            
            if (response.data.isAdmin) {
                navigate('/admin'); 
            } else {
                navigate('/home'); 
            }
            
        } catch (err) {
            setMessage({ text: err.response?.data?.message || 'Login failed. Please check your credentials.', type: 'error' });
            console.error('Login Error:', err);
        }
    };
    return (
        <div className="form-container">
            <h2>Login</h2>
            <form onSubmit={handleSubmit}>
                <input
                    type="text"
                    name="username"
                    placeholder="Username"
                    value={credentials.username}
                    onChange={handleChange}
                    required
                />
                <input
                    type="password"
                    name="password"
                    placeholder="Password"
                    value={credentials.password}
                    onChange={handleChange}
                    required
                />
                <button type="submit">Login</button>
                {message.text && (
                    <div className={message.type === 'error' ? 'error-message' : 'success-message'}>
                        {message.text}
                    </div>
                )}
            </form>
            <p className='login-link-register'>
                New here? <Link to="/register">Sign Up</Link>
            </p>
        </div>
    );
};

export default Login;
