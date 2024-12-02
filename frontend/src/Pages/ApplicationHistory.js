import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { jwtDecode } from 'jwt-decode';
import './ApplicationHistory.css';

export default function ApplicationHistory() {
  const [applications, setApplications] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const fetchApplicationHistory = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) throw new Error('No token found');

      const decoded = jwtDecode(token);
      const USERNAME = decoded?.username;
      if (!USERNAME) throw new Error('Invalid token');
      
      const response = await axios.get(`http://localhost:4000/users/history/${USERNAME}`);
      setApplications(response.data); 
      
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchApplicationHistory();
  }, []); // Empty dependency array

  const handleWithdraw = async (postId) => {
    try {
      const token = localStorage.getItem('token');
      const decoded = jwtDecode(token);
      const USERNAME = decoded?.username;

      const confirmWithdraw = window.confirm('Are you sure you want to withdraw this application?');
      
      if (confirmWithdraw) {
        await axios.delete('http://localhost:4000/users/history/delete', {
          data: { 
            postId: postId, 
            username: USERNAME 
          }
        });

        // Refresh the application list after successful withdrawal
        fetchApplicationHistory();
      }
    } catch (err) {
      console.error('Error withdrawing application:', err);
      alert('Failed to withdraw application. Please try again.');
    }
  };

  if (loading) {
    return <div className="history-loading">Loading...</div>;
  }

  if (error) {
    return <div className="history-error">Error: {error}</div>;
  }

  return (
    <div className="history-container">
      <h1 className="history-title">Application History</h1>
      {applications.length === 0 ? (
        <p className="history-empty-state">No applications found.</p>
      ) : (
        <ul className="history-list">
          {applications.map((application) => (
            <li key={application.POST_ID} className="history-list-item">
              <div className="history-item-details">
                <div className="history-item-row">
                  <strong>Job ID:</strong> {application.POST_ID}
                </div>
                <div className="history-item-row">
                  <strong>Application Date:</strong> {formatDate(application.APPLICATION_DATE)}
                </div>
                <div className="history-item-row">
                  <strong>Status:</strong> {application.APPLICATION_STATUS}
                </div>
                <div className="history-item-actions">
                  <button 
                    className="history-withdraw-btn"
                    onClick={() => handleWithdraw(application.POST_ID)}
                  >
                    Withdraw
                  </button>
                </div>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}