// src/App.js
import { BrowserRouter as Router, Routes, Route, Navigate, useLocation } from "react-router-dom";
import { AuthProvider } from './AuthContext';
import PrivateRoute from './PrivateRoute';
import AdminNav from "./Navigation/AdminNav";
import Profile from "./Pages/Profile";
import ApplicationHistory from "./Pages/ApplicationHistory";
import HomePage from "./Pages/HomePage";
import Login from "./components/Login";
import Register from "./components/Register";
import AdminDashboard from "./Pages/AdminDashBoard";
import AdminProfile from "./Pages/AdminProfile"; // Import the new AdminProfile component
import Navigation from "./Navigation/Nav";
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
                    <Route path="/profile" element={<ProfileWrapper />} />
                    <Route path="/applicationHistory" element={
                        <PrivateRoute>
                            <Navigation />
                            <div className="home-content"><ApplicationHistory /></div>
                        </PrivateRoute>
                    } />
                    <Route path="/admin" element={
                        <PrivateRoute>
                            <AdminNav />
                            <div className="home-content"><AdminDashboard /></div>
                        </PrivateRoute>
                    } />
                    <Route path="/admin/profile" element={
                        <PrivateRoute>
                            <AdminNav />
                            <div className="home-content"><AdminProfile /></div>
                        </PrivateRoute>
                    } /> {/* New Route for Admin Profile */}
                    <Route path="/login" element={<Login />} /> 
                    <Route path="/register" element={<Register />} />
                </Routes>
            </Router>
        </AuthProvider>
    );
}

const ProfileWrapper = () => {
    const location = useLocation();
    const isAdmin = location.state?.fromAdmin; // Check if the navigation is from admin

    return (
        <PrivateRoute>
            {isAdmin ? <AdminNav /> : <Navigation />} {/* Conditional Navigation */}
            <div className="home-content"><Profile /></div>
        </PrivateRoute>
    );
};

export default App;