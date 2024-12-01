import "./Product.css";
import React, { useState } from "react";
import JobModal from "../jobModal/jobModal";

const Products = ({ jobs }) => {
  const [selectedJob, setSelectedJob] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  const openModal = (job) => {
    setSelectedJob(job);
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
    setSelectedJob(null);
  };

  return (
    <div className="job-board">
      {jobs.map((job, index) => (
        <div className="job-card" key={index}>
          <h2 className="company-name">{job.COMPANY_NAME}</h2>
          <p className="job-position">{job.ROLE_NAME}</p>
          <p className="job-deadline">Deadline: {new Date(job.DEADLINE).toISOString().split('T')[0]}</p>
          <button className="view-button" onClick={() => openModal(job)}>View</button>
        </div>
      ))}
      
    <JobModal job={selectedJob} isOpen={isModalOpen} closeModal={closeModal} />
    </div>
  )
};

export default Products;
