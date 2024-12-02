import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from './AuthContext';
import PrivateRoute from './PrivateRoute';
import Navigation from "./Navigation/Nav";
import Profile from "./Pages/Profile";
import ApplicationHistory from "./Pages/ApplicationHistory";
import HomePage from "./Pages/HomePage";
import Login from "./components/Login";
import Register from "./components/Register";
import AdminDashboard from "./Pages/AdminDashBoard"; // Import the Admin Dashboard
import "./index.css";

function App() {
  
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/" element={<Navigate to="/home" />} />
          <Route
            path="/home"
            element={
              <PrivateRoute>
                <HomePage />
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
              <Navigation />
              <div className="home-content"><ApplicationHistory /></div>
              <HomePage/>
            </PrivateRoute>
          } />
          <Route path="/admin" element={
            <PrivateRoute>
              <Navigation />
              <div className="home-content"><AdminDashboard /></div> {/* Admin Dashboard Route */}
            </PrivateRoute>
          } />
          <Route path="/login" element={<Login />} /> 
          <Route path="/register" element={<Register />} />
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default App;