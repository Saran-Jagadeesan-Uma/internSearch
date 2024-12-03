import React, { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import axios from 'axios'; 
import { jwtDecode } from 'jwt-decode'; 
import "./AdminProfile.css";

const AdminProfile = () => {
    const location = useLocation();
    const isFromAdmin = location.state?.fromAdmin;

    const [adminData, setAdminData] = useState({
        username: '',
        role: '',
        accessLevel: '',
        department: ''
    });
    useEffect(() => {
        const fetchAdminData = async () => {
            try {
                const token = localStorage.getItem('token');
                if (!token) throw new Error('No token found');
    
                const decoded = jwtDecode(token);
                const username = decoded?.username;
    
                const response = await axios.get(`http://localhost:4000/admin/${username}`);
                setAdminData(response.data);
            } catch (error) {
                console.error('Error fetching admin data:', error);
            }
        };
    
        fetchAdminData();
    }, []);

    return (
        <div className="admin-profile-container">
            <h1>Admin Profile Page</h1>
            {isFromAdmin}
            <div className="admin-profile-fields">
                <div className="admin-profile-field">
                    <label htmlFor="username">Username:</label>
                    <input type="text" id="username" value={adminData.username} readOnly />
                </div>
                <div className="admin-profile-field">
                    <label htmlFor="role">Role:</label>
                    <input type="text" id="role" value={adminData.role} readOnly />
                </div>
                <div className="admin-profile-field">
                    <label htmlFor="accessLevel">Access Level:</label>
                    <input type="text" id="accessLevel" value={adminData.accessLevel} readOnly />
                </div>
                <div className="admin-profile-field">
                    <label htmlFor="department">Department:</label>
                    <input type="text" id="department" value={adminData.department} readOnly />
                </div>
            </div>
        </div>
    );
};

export default AdminProfile;