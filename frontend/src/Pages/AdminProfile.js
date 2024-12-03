import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { jwtDecode } from 'jwt-decode';
import "./AdminProfile.css";

const AdminProfile = () => {
    const [adminData, setAdminData] = useState({
        username: '',
        role: '',
        accessLevel: '',
        department: ''
    });
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchAdminData = async () => {
            try {
                const token = localStorage.getItem('token');
                if (!token) {
                    setError('No authentication token found');
                    return;
                }
    
                const decoded = jwtDecode(token);
                const username = decoded?.username;
    
                if (!username) {
                    setError('Invalid username in token');
                    return;
                }
    
                const response = await axios.get(`http://localhost:4000/users/admin/${username}`);
    
                // Log the exact structure of the response
                console.log('Response Data:', response.data);
    
                // Explicitly map the data, taking care of case sensitivity
                setAdminData({
                    username: response.data.USERNAME || response.data.username || '',
                    role: response.data.ROLE || response.data.role || '',
                    accessLevel: response.data.ACCESS_LEVEL || response.data.accessLevel || '',
                    department: response.data.DEPARTMENT || response.data.department || ''
                });
            } catch (error) {
                console.error('Complete Error Object:', error);
                setError(error.response?.data?.error || error.message || 'Failed to fetch admin data');
            }
        };
    
        fetchAdminData();
    }, []);

    if (error) {
        return <div className="admin-profile-error">{error}</div>;
    }

    return (
        <div className="admin-profile-container">
            <h1>Admin Profile Page</h1>
            <div className="admin-profile-fields">
                <div className="admin-profile-field">
                    <label htmlFor="username">Username:</label>
                    <input 
                        type="text" 
                        id="username" 
                        value={adminData.username || ''} 
                        readOnly 
                    />
                </div>
                <div className="admin-profile-field">
                    <label htmlFor="role">Role:</label>
                    <input 
                        type="text" 
                        id="role" 
                        value={adminData.role || ''} 
                        readOnly 
                    />
                </div>
                <div className="admin-profile-field">
                    <label htmlFor="accessLevel">Access Level:</label>
                    <input 
                        type="text" 
                        id="accessLevel" 
                        value={adminData.accessLevel || ''} 
                        readOnly 
                    />
                </div>
                <div className="admin-profile-field">
                    <label htmlFor="department">Department:</label>
                    <input 
                        type="text" 
                        id="department" 
                        value={adminData.department || ''} 
                        readOnly 
                    />
                </div>
            </div>
        </div>
    );
};

export default AdminProfile; // Make sure this line is present