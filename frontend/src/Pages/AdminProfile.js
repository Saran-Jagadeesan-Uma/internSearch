import React, { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import axios from 'axios'; // For API calls
import { jwtDecode } from 'jwt-decode'; // Corrected import as a named import
import "./AdminProfile.css"; // Import your CSS for styling

const AdminProfile = () => {
    const location = useLocation();
    const isFromAdmin = location.state?.fromAdmin; // Check if navigation is from admin

    // State to hold admin data
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

                // Fetch admin details from the server
                const response = await axios.get(`http://localhost:4000/admin/${username}`); // Adjust the endpoint as necessary
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
            {isFromAdmin && <p>This profile was accessed from the admin dashboard.</p>}
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