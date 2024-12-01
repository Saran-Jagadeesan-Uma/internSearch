import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { IoIosNotifications } from "react-icons/io";
import { MdWorkHistory } from "react-icons/md";
import { CiUser } from "react-icons/ci";
import "./Nav.css";

const Nav = ({ handleInputChange, query }) => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.clear(); // Clear all local storage data
    navigate("/login"); // Redirect to login page
  };

  return (
    <nav>
      {/* Logo Container */}
      <div className="logo-container">
        <Link to="/home">
          <h2>InternSearch</h2>
        </Link>
      </div>

      {/* Main Navigation Section */}
      <section>
        {/* Search Input */}
        <div className="nav-container">
          <input
            className="search-input"
            type="text"
            onChange={handleInputChange}
            value={query}
            placeholder="Enter your search"
          />
        </div>

        {/* Profile and Icons Section */}
        <div className="profile-container">
          <Link to="/notifications" className="nav-link">
            <IoIosNotifications className="nav-icons" />
          </Link>
          <Link to="/applicationHistory" className="nav-link">
            <MdWorkHistory className="nav-icons" />
          </Link>
          <Link to="/profile" className="nav-link">
            <CiUser className="nav-icons" />
          </Link>
          <button className="logout-button" onClick={handleLogout}>
            Logout
          </button>
        </div>
      </section>
    </nav>
  );
};

export default Nav;
