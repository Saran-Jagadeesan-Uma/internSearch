import React, { useState } from 'react';
import axios from 'axios';

const AdminDashboard = () => {
    const [jobDetails, setJobDetails] = useState({
        companyName: '',
        roleName: '',
        term: '',
        type: '',
        location: '',
        minGPA: '',
        pay: '',
        deadline: '',
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setJobDetails({ ...jobDetails, [name]: value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        const token = localStorage.getItem('token');

        try {
            const response = await axios.post('http://localhost:4000/postings/publish', jobDetails, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            alert(response.data.message);
        } catch (error) {
            alert('Failed to publish job posting: ' + error.response.data.message);
        }
    };

    return (
        <div>
            <h1>Admin Dashboard</h1>
            <form onSubmit={handleSubmit}>
                <input type="text" name="companyName" placeholder="Company Name" onChange={handleChange} required />
                <input type="text" name="roleName" placeholder="Role Name" onChange={handleChange} required />
                <input type="text" name="term" placeholder="Term" onChange={handleChange} required />
                <input type="text" name="type" placeholder="Type" onChange={handleChange} required />
                <input type="text" name="location" placeholder="Location" onChange={handleChange} required />
                <input type="number" name="minGPA" placeholder="Minimum GPA" onChange={handleChange} required />
                <input type="number" name="pay" placeholder="Pay" onChange={handleChange} required />
                <input type="date" name="deadline" placeholder="Deadline" onChange={handleChange} required />
                <button type="submit">Publish Job Posting</button>
            </form>
        </div>
    );
};

export default AdminDashboard;