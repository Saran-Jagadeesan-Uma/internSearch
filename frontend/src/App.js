import { useState } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AuthProvider } from './AuthContext';
import PrivateRoute from './PrivateRoute';
import Navigation from "./Navigation/Nav";
import Products from "./Products/Products";
import products from "./db/data";
import Recommended from "./Recommended/Recommended";
import Sidebar from "./Sidebar/Sidebar";
import Card from "./components/Card";
import Profile from "./Pages/Profile";
import ApplicationHistory from "./Pages/ApplicationHistory";
import Login from "./components/Login"
import "./index.css";
import Register from "./components/Register";

function App() {
  const [selectedCategory, setSelectedCategory] = useState(null);

  // ----------- Input Filter -----------
  const [query, setQuery] = useState("");

  const handleInputChange = (event) => {
    setQuery(event.target.value);
  };

  const filteredItems = products.filter(
    (product) => product.title.toLowerCase().indexOf(query.toLowerCase()) !== -1
  );

  // ----------- Radio Filtering -----------
  const handleChange = (event) => {
    setSelectedCategory(event.target.value);
  };

  // ------------ Button Filtering -----------
  const handleClick = (event) => {
    setSelectedCategory(event.target.value);
  };

  function filteredData(products, selected, query) {
    let filteredProducts = products;

    // Filtering Input Items
    if (query) {
      filteredProducts = filteredItems;
    }

    // Applying selected filter
    if (selected) {
      filteredProducts = filteredProducts.filter(
        ({ category, color, company, newPrice, title }) =>
          category === selected ||
          color === selected ||
          company === selected ||
          newPrice === selected ||
          title === selected
      );
    }

    return filteredProducts.map(
      ({ img, title, star, reviews, prevPrice, newPrice }) => (
        <Card
          key={Math.random()}
          img={img}
          title={title}
          star={star}
          reviews={reviews}
          prevPrice={prevPrice}
          newPrice={newPrice}
        />
      )
    );
  }

  const result = filteredData(products, selectedCategory, query);

  return (
    <AuthProvider>
    <Router>
      <Routes>
        <Route
          path="/home"
          element={

            <PrivateRoute>
            <Navigation query={query} handleInputChange={handleInputChange} />
            <div className="home-content">
              <Sidebar handleChange={handleChange} />
              <Recommended handleClick={handleClick} />
              <Products result={result} />
            </div>
            </PrivateRoute>
          }
        />
        <Route path="/profile" element={
          <PrivateRoute>
          <Navigation query={query} handleInputChange={handleInputChange} />
          <div className="home-content"><Profile /></div>
          </PrivateRoute>
          } />
        <Route path="/applicationHistory" element={
          <PrivateRoute>
          <Navigation query={query} handleInputChange={handleInputChange} />
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
