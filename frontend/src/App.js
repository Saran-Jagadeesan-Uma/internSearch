import { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route,Navigate } from "react-router-dom";
import { AuthProvider } from './AuthContext';
import PrivateRoute from './PrivateRoute';
import Navigation from "./Navigation/Nav";
import Jobs from "./Jobs/Jobs";
import Sidebar from "./Sidebar/Sidebar";
import Profile from "./Pages/Profile";
import ApplicationHistory from "./Pages/ApplicationHistory";
import Login from "./components/Login"
import "./index.css";
import Register from "./components/Register";

function App() {
  const [jobs, setJobs] = useState([]);
  const [filteredJobs, setFilteredJobs] = useState([]);
  const [filters, setFilters] = useState({
    keywords: "",
    role: "",
    term: ""
  });

  const fetchJobs = async () => {
    try {
      const response = await fetch("http://localhost:4000/postings/allPostings", {
        method: "GET"
      });

      if (!response.ok) throw new Error("Failed to fetch jobs");

      const data = await response.json();
      setJobs(data);
      setFilteredJobs(data); 
    } catch (err) {
      console.error(err.message);
    }
  };

  const applyFilters = () => {
    let updatedJobs = jobs;

    if (filters.keywords && filters.keywords!=="") {
      updatedJobs = updatedJobs.filter(
        (job) => {
          console.log(filters.keywords.toLowerCase(),job.COMPANY_NAME,job.COMPANY_NAME.toLowerCase().includes(filters.keywords.toLowerCase()) ); 
          return job.COMPANY_NAME.toLowerCase().includes(filters.keywords.toLowerCase()) 
        }
      );
    }

    if (filters.role && filters.role!=="") {
      updatedJobs = updatedJobs.filter((job) =>
        job.ROLE_NAME.toLowerCase().includes(filters.role.toLowerCase())
      );
    }

    if (filters.term && filters.term!=="") {
      updatedJobs = updatedJobs.filter((job) =>
        job.TERM.toLowerCase().includes(filters.term.toLowerCase())
      );
    }

    setFilteredJobs(updatedJobs);
  };

  const handleKeywordChange = (event) => {
    let filter_name = "keywords"
    setFilters((prev) => ({ ...prev, [filter_name]: event.target.value }));
  };

  const onFilterChange = (event) => {
    console.log(event);
    
    if (event.target.name === 'job-role') {
      let name = "role"
      if (event.target.value === 'All'){
        event.target.value=""
      }
      setFilters((prev) => ({ ...prev, [name]: event.target.value }));
    } else {
       let name = "term"
       if (event.target.value === 'All'){
        event.target.value=""
      }
      setFilters((prev) => ({ ...prev, [name]: event.target.value }));
    }
  }

  useEffect(() => {
    fetchJobs();
  }, []);

  useEffect(() => {
    applyFilters();
  }, [filters, jobs]);

  
  return (
    <AuthProvider>
    <Router>
      <Routes>
      <Route path="/" element={<Navigate to="/home" />} />
        <Route
          path="/home"
          element={
            <PrivateRoute>
            <Navigation query={filters.keywords} handleInputChange={handleKeywordChange} />
            <div className="home-content">
              <Sidebar onFilterChange={onFilterChange} />
              <Jobs jobs={filteredJobs} />
            </div> 
            </PrivateRoute>
          }
        />
        <Route path="/profile" element={
          <PrivateRoute>
          <Navigation />
          <div className="home-content"><Profile /></div>
          </PrivateRoute>
          } />
        <Route path="/applicationHistory" element={
          <PrivateRoute>
          <Navigation  />
          <div className="home-content"><ApplicationHistory /></div>
          </PrivateRoute>
          } />
        
          <Route path="/login" element={<Login />} /> 
          <Route path="/register" element={<Register />}/>
        
      </Routes>
    </Router>
    </AuthProvider>
  );
}

export default App;
