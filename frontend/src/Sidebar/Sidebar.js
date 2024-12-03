import React, { useState } from "react";
import "./Sidebar.css";

const Sidebar = ({ onFilterChange }) => {
  const [selectedRole, setSelectedRole] = useState("");
  const [selectedTerm, setSelectedTerm] = useState("");

  const roles = [
    "All",
    "Data",
    "Machine Learning",
    "Security",
    "Software",
    "Frontend",
    "Cloud"
  ];

  const terms = [
    "All",
    "Spring",
    "Summer",
    "Winter",
    "Fall"
  ]

  const handleRoleChange = (event) => {
    setSelectedRole(event.target.value);
    onFilterChange(event); 
  };

  const handleTermChange = (event) => {
    setSelectedTerm(event.target.value);
    onFilterChange(event); 
  };

  return (
    <div className="sidebar">
      <div className="filter-group">
        <h4 className="filter-title">Popular Keywords</h4>
        {roles.map((role, index) => (
          <div className="radio-group" key={index}>
            <input
              type="radio"
              id={`role-${role}`}
              name="job-role"
              value={role}
              checked={selectedRole === role}
              onChange={handleRoleChange}
            />
            <label htmlFor={`role-${role}`} className="radio-label">
              {role}
            </label>
          </div>
        ))}
      </div>
      <div className="filter-group">
        <h4 className="filter-title">Job Term</h4>
        {terms.map((term, index) => (
          <div className="radio-group" key={index}>
            <input
              type="radio"
              id={`term-${term}`}
              name="job-term"
              value={term}
              checked={selectedTerm === term}
              onChange={handleTermChange}
            />
            <label htmlFor={`term-${term}`} className="radio-label">
              {term}
            </label>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Sidebar;
