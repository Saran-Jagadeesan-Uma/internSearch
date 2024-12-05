import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { MdWorkHistory } from "react-icons/md";
import { CiUser } from "react-icons/ci";
import "./Nav.css";

const Nav = ({ handleInputChange, query }) => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.clear(); 
    navigate("/login");
  };

  return (
    <nav>
      <div className="logo-container">
        <Link to="/">
          <h2>InternSearch</h2>
        </Link>
      </div>

      <section>
        <div className="nav-container">
          <input
            className="search-input"
            type="text"
            onChange={handleInputChange}
            value={query}
            placeholder="Search Company.."
          />
        </div>

        <div className="profile-container">
          
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
