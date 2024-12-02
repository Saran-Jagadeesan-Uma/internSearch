import React, { useEffect, useState } from 'react';
import './AdminDashBoard.css';
import axios from 'axios';
import { jwtDecode } from 'jwt-decode';

const AdminDashboard = () => {
    const [postings, setPostings] = useState([]);
    const [formData, setFormData] = useState({
        location: '',
        term: '',
        type: '',
        pay: '',
        companyName: '',
        roleName: '',
        createdBy: ''
    });

    useEffect(() => {
        // Fetch the username from the token when component mounts
        const token = localStorage.getItem('token');
        if (token) {
            const decoded = jwtDecode(token);
            setFormData(prev => ({ ...prev, createdBy: decoded.username }));
        }
        fetchPostings();
    }, []);

    const fetchPostings = async () => {
        try {
            const response = await axios.get('http://localhost:4000/postings/all');
            setPostings(response.data);
        } catch (error) {
            console.error('Error fetching postings:', error);
        }
    };

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await axios.post('http://localhost:4000/postings/create', formData);
            // Reset form and refresh postings
            setFormData({
                location: '',
                term: '',
                type: '',
                pay: '',
                companyName: '',
                roleName: '',
                createdBy: formData.createdBy // Keep the createdBy
            });
            fetchPostings();
            alert('Job posting created successfully!');
        } catch (error) {
            console.error('Error creating posting:', error);
            alert('Failed to create job posting');
        }
    };

    const handleDelete = async (postId) => {
        try {
            await axios.delete(`http://localhost:4000/postings/${postId}`);
            fetchPostings();
            alert('Job posting deleted successfully!');
        } catch (error) {
            console.error('Error deleting posting:', error);
            alert('Failed to delete job posting');
        }
    };

    return (
        <div className="admin-dashboard">
            <h1>Admin Dashboard</h1>
            <form onSubmit={handleSubmit} className="admin-form">
                <input
                    type="text"
                    name="location"
                    placeholder="Location"
                    value={formData.location}
                    onChange={handleChange}
                    required
                />
                <select
                    name="term"
                    value={formData.term}
                    onChange={handleChange}
                    required
                >
                    <option value="">Select Term</option>
                    <option value="Fall">Fall</option>
                    <option value="Spring">Spring</option>
                    <option value="Summer">Summer</option>
                    <option value="Winter">Winter</option>
                </select>
                <input
                    type="text"
                    name="type"
                    placeholder="Job Type"
                    value={formData.type}
                    onChange={handleChange}
                    required
                />
                <input
                    type="number"
                    name="pay"
                    placeholder="Pay Rate"
                    value={formData.pay}
                    onChange={handleChange}
                    step="0.01"
                    required
                />
                <input
                    type="text"
                    name="companyName"
                    placeholder="Company Name"
                    value={formData.companyName}
                    onChange={handleChange}
                    required
                />
                <input
                    type="text"
                    name="roleName"
                    placeholder="Role Name"
                    value={formData.roleName}
                    onChange={handleChange}
                    required
                />
                <button type="submit">Create Job Posting</button>
            </form>

            <h2 > Job Postings</h2>
            <ul>
                {postings.map(posting => (
                    <li key={posting.POST_ID}>
                        <h3>{posting.ROLE_NAME} at {posting.COMPANY_NAME}</h3>
                        <p>Location: {posting.LOCATION}</p>
                        <p>Term: {posting.TERM}</p>
                        <p>Pay: ${posting.PAY}</p>
                        <button onClick={() => handleDelete(posting.POST_ID)}>Delete Posting</button>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default AdminDashboard;