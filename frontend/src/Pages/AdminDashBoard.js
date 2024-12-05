import React, { useEffect, useState } from 'react';
import './AdminDashBoard.css';
import axios from 'axios';
import { jwtDecode } from 'jwt-decode';

const AdminDashboard = () => {
    const [postings, setPostings] = useState([]);
    const [editingPosting, setEditingPosting] = useState(null);
    const [formData, setFormData] = useState({
        location: '',
        term: '',
        type: '',
        pay: '',
        companyName: '',
        roleName: '',
        createdBy: '',
        industry: '',
        description: ''
    });

    useEffect(() => {
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
            if (editingPosting) {
                await axios.put(`http://localhost:4000/postings/${editingPosting}`, formData);
                alert('Job posting updated successfully!');
                setEditingPosting(null);
            } else {
                await axios.post('http://localhost:4000/postings/create', formData);
                alert('Job posting created successfully!');
            }
            
            setFormData({
                location: '',
                term: '',
                type: '',
                pay: '',
                companyName: '',
                roleName: '',
                createdBy: formData.createdBy,
                industry: '',
                description: ''
            });
            fetchPostings();
        } catch (error) {
            console.error('Error saving posting:', error);
            alert('Failed to save job posting');
        }
    };

    const handleEditPosting = (posting) => {
        setEditingPosting(posting.POST_ID);
        setFormData({
            location: posting.LOCATION,
            term: posting.TERM,
            type: posting.TYPE,
            pay: posting.PAY,
            companyName: posting.COMPANY_NAME,
            roleName: posting.ROLE_NAME,
            createdBy: formData.createdBy,
            industry: posting.INDUSTRY,
            description: posting.DESCRIPTION
        });
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

    const cancelEdit = () => {
        setEditingPosting(null);
        setFormData({
            location: '',
            term: '',
            type: '',
            pay: '',
            companyName: '',
            roleName: '',
            createdBy: formData.createdBy,
            industry: '',
            description: ''
        });
    };

    return (
        <div className="admin-dashboard">
            <h1>Admin Dashboard</h1>
            <div className="dashboard-container">
                <div className="form-container">
                    <h2>{editingPosting ? 'Edit Job Posting' : 'Create New Job Posting'}</h2>
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
                        <textarea
                            name="description"
                            placeholder="Description"
                            value={formData.description}
                            onChange={handleChange}
                            required
                        />
                        <input
                            type="text"
                            name="industry"
                            placeholder="Industry" 
                            value={formData.industry}
                            onChange={handleChange}
                            required
                        />
                        <button type="submit">
                            {editingPosting ? 'Update Posting' : 'Create Job Posting'}
                        </button>
                        {editingPosting && (
                            <button type="button" onClick={cancelEdit}>
                                Cancel Edit
                            </button>
                        )}
                    </form>
                </div>

                <div className="job-postings-container">
                    <h2>Existing Job Postings</h2>
                    <div className="job-postings-scroll">
                        {postings.map(posting => (
                            <div className="job-posting-card" key={posting.POST_ID}>
                                <h3>{posting.ROLE_NAME} at {posting.COMPANY_NAME}</h3>
                                <p><strong>Location:</strong> {posting.LOCATION}</p>
                                <p><strong>Term:</strong> {posting.TERM}</p>
                                <p><strong>Pay:</strong> ${posting.PAY}</p>
                                <p><strong>Description:</strong> {posting.DESCRIPTION}</p>
                                <div className="job-posting-actions">
                                    <button onClick={() => handleEditPosting(posting)}>Edit Posting</button>
                                    <button onClick={() => handleDelete(posting.POST_ID)}>Delete Posting</button>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default AdminDashboard;