// import Category from "./Category/Category";
// import Price from "./Price/Price";
// import Colors from "./Colors/Colors";
// import {Link} from "react-router-dom";
// import "./Sidebar.css";

// const Sidebar = ({ handleChange }) => {
//   return (
//     <>
//       <section className="sidebar">
//         <Category handleChange={handleChange} />
//         <Price handleChange={handleChange} />
//         <Colors handleChange={handleChange} />
//       </section>
//     </>
//   );
// };

// export default Sidebar;

import React, { useState } from "react";
import "./Sidebar.css";

const Sidebar = ({ onFilterChange }) => {
  const [selectedRole, setSelectedRole] = useState("");
  const [selectedTerm, setSelectedTerm] = useState("");

  // Hardcoded job roles
  const roles = [
    "All",
    "Data Analyst Intern",
    "Environmental Intern",
    "Software Engineer",
    "Software Intern"
  ];

  //Hardcoded job terms
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
        <h4 className="filter-title">Job Role</h4>
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
              id={`role-${term}`}
              name="job-term"
              value={term}
              checked={selectedTerm === term}
              onChange={handleTermChange}
            />
            <label htmlFor={`role-${term}`} className="radio-label">
              {term}
            </label>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Sidebar;
