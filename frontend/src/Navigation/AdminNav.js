import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { CiUser  } from "react-icons/ci";
import "./AdminNav.css";

const AdminNav = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.clear();
    navigate("/login"); 
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