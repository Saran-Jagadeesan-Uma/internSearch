// src/Navigation/AdminNav.js
import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { CiUser  } from "react-icons/ci";
import "./AdminNav.css";

const AdminNav = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.clear(); // Clear all local storage data
    navigate("/login"); // Redirect to login page
  };

  const goToProfile = () => {
    navigate("/admin/profile", { state: { fromAdmin: true } });
  };

  return (
    <nav>
      <div className="logo-container">
        <Link to="/admin">
          <h2>Admin Dashboard</h2>
        </Link>
      </div>
      <section>
        <div className="nav-container">
          {/* Other possible nav items can go here */}
        </div>
        <div className="profile-container">
          <button className="nav-link" onClick={goToProfile}>
            <CiUser  className="nav-icons" />
          </button>
          <button className="logout-button" onClick={handleLogout}>
            Logout
          </button>
        </div>
      </section>
    </nav>
  );
};

export default AdminNav;