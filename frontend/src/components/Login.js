import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import axios from 'axios';
import { useAuth } from '../AuthContext';
import './FormStyles.css'; 

const Login = () => {
    const [credentials, setCredentials] = useState({
        username: '',
        password: ''
    });
    const [message, setMessage] = useState({ text: '', type: '' });
    const navigate = useNavigate();
    const { login } = useAuth();

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
            navigate(response.data.isAdmin ? '/admin' : '/home'); 
        } catch (err) {
            setMessage({ text: err.response?.data?.message || 'Login failed. Please check your credentials.', type: 'error' });
        }
    };

    return (
        <div className="background">
            <div className="form-container">
                <h2 className="form-title">Welcome Back!</h2>
                <form onSubmit={handleSubmit}>
                    <div className="input-group">
                        <input
                            type="text"
                            name="username"
                            placeholder="Username"
                            value={credentials.username}
                            onChange={handleChange}
                            required
                            className="input-field"
                        />
                    </div>
                    <div className="input-group">
                        <input
                            type="password"
                            name="password"
                            placeholder="Password"
                            value={credentials.password}
                            onChange={handleChange}
                            required
                            className="input-field"
                        />
                    </div>
                    <button type="submit" className="submit-button">Login</button>
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
        </div>
    );
};

export default Login;