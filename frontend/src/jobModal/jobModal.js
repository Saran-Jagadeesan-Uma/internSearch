import React from "react";
import Modal from "react-modal";
import "./jobModal.css"; 
import { jwtDecode } from 'jwt-decode';

Modal.setAppElement("#root"); 

const JobModal = ({ job, isOpen, closeModal }) => {
    
  if (!job) return null;

  const applyForJob = async (jobId) => {
    try {
        
        const token = localStorage.getItem('token');
        if (!token) throw new Error('No token found');
        
        const decoded = jwtDecode(token);
        const user = decoded?.username;

        const response = await fetch("http://localhost:4000/postings/applyJob", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          jobId: jobId,
          username: user
        }),
      });


      if (response.ok) {
        alert("Successfully applied for the job!");
      } else {
        const errorData = await response.json();
        alert(`Failed to apply: ${errorData.message}`);
      }
    } catch (error) {
      console.error("Error applying for job:", error);
      alert("Something went wrong. Please try again.");
    }
  };  

  return (
    <Modal isOpen={isOpen} onRequestClose={closeModal} className="modal">
      <div className="modal-content">
        <h2>{job.COMPANY_NAME}</h2>
        <p><strong>Role:</strong> {job.ROLE_NAME}</p>
        <p><strong>Term:</strong> {job.TERM}</p>
        <p><strong>Type:</strong> {job.TYPE}</p>
        <p><strong>Date Posted:</strong> {new Date(job.DATE_POSTED).toLocaleDateString()}</p>
        <p><strong>Location:</strong> {job.LOCATION}</p> 
        <p><strong>Salary:</strong> {job.PAY}</p> 
        <p><strong>Description:</strong> {job.DESCRIPTION}</p> 
        <div className="modal-actions">
          <button className="close-button" onClick={closeModal}>Close</button>
          <button className="apply-button" onClick={() => applyForJob(job.POST_ID)}>Apply</button>
        </div>
      </div>
    </Modal>
  );
};

export default JobModal;
