// src/Pages/AdminDashboard.js
import React, { useEffect, useState } from 'react';
import './AdminDashBoard.css'; // CSS for styling
import axios from 'axios';

const AdminDashboard = () => {
    const [applications, setApplications] = useState([]);
    const [formData, setFormData] = useState({
        id: '',
        title: '',
        description: '',
    });
    const [isEditing, setIsEditing] = useState(false);

    useEffect(() => {
        fetchApplications();
    }, []);

    const fetchApplications = async () => {
        try {
            const response = await axios.get('http://localhost:4000/applications');
            setApplications(response.data);
        } catch (error) {
            console.error('Error fetching applications:', error);
        }
    };

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (isEditing) {
            await updateApplication();
        } else {
            await createApplication();
        }
    };

    const createApplication = async () => {
        try {
            await axios.post('http://localhost:4000/applications', formData);
            fetchApplications();
            resetForm();
        } catch (error) {
            console.error('Error creating application:', error);
        }
    };

    const updateApplication = async () => {
        try {
            await axios.put(`http://localhost:4000/applications/${formData.id}`, formData);
            fetchApplications();
            resetForm();
        } catch (error) {
            console.error('Error updating application:', error);
        }
    };

    const deleteApplication = async (id) => {
        try {
            await axios.delete(`http://localhost:4000/applications/${id}`);
            fetchApplications();
        } catch (error) {
            console.error('Error deleting application:', error);
        }
    };

    const editApplication = (application) => {
        setFormData(application);
        setIsEditing(true);
    };

    const resetForm = () => {
        setFormData({ id: '', title: '', description: '' });
        setIsEditing(false);
    };

    return (
        <div className="admin-dashboard">
            <h1>Admin Dashboard</h1>
            <form onSubmit={handleSubmit} className="admin-form">
                <input
                    type="text"
                    name="title"
                    placeholder="Application Title"
                    value={formData.title}
                    onChange={handleChange}
                    required
                />
                <textarea
                    name="description"
                    placeholder="Application Description"
                    value={formData.description}
                    onChange={handleChange}
                    required
                />
                <button type="submit">{isEditing ? 'Update Application' : 'Create Application'}</button>
                {isEditing && <button type="button" onClick={resetForm}>Cancel</button>}
            </form>

            <h2>Existing Applications</h2>
            <ul className="application-list">
                {applications.map((application) => (
                    <li key={application.id} className="application-item">
                        <h3>{application.title}</h3>
                        <p>{application.description}</p>
                        <button onClick={() => editApplication(application)}>Edit</button>
                        <button onClick={() => deleteApplication(application.id)}>Delete</button>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default AdminDashboard;