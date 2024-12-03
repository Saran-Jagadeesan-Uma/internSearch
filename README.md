# README for InternSearch Project

## Project Overview

The **InternSearch** project is a web application designed to facilitate the connection between students and internship opportunities. It provides features for users to create profiles, apply for jobs, and manage their application history. Additionally, the application includes an admin dashboard for managing job postings.

## Technical Specifications

### Frontend
- **Framework**: React.js (version 18.3.1)
- **Styling**: CSS
- **Libraries**:
  - **Axios**: For making HTTP requests.
  - **Formik**: For handling forms and validation.
  - **Yup**: For schema validation of form inputs.
  - **React Router DOM**: For client-side routing.
  - **React Icons**: For incorporating icons.
  - **React Toastify**: For displaying notifications.
  - **JWT Decode**: For decoding JSON Web Tokens.

### Backend
- **Framework**: Node.js with Express.js
- **Database**: MySQL
- **Libraries**:
  - **Body-parser**: For parsing incoming request bodies.
  - **CORS**: For enabling Cross-Origin Resource Sharing.
  - **Bcryptjs**: For hashing passwords securely.
  - **JSON Web Token (JWT)**: For user authentication.

## Prerequisites

Before you begin, ensure you have the following software installed on your computer:

1. **Node.js**: Download and install Node.js from the [Node.js Download Page](https://nodejs.org/).
2. **MySQL**: Download and install MySQL from the [MySQL Download Page](https://dev.mysql.com/downloads/mysql/).

## Installation Instructions

To set up the project on your local machine, follow these steps:

1. **Donwload the zip and extract it**: Download the zip file from the repository and extract it to a directory of your choice and navigate to its directory in terminal.
    - cd path/to/internSearch
2. **Set Up the Backend**:
   Navigate to the server directory:
   - cd server
   - npm install
3. **Create a .env file in the server**:
   Create a `.env` file in the `server` directory with the following content:
   - DB_HOST="127.0.0.1"
   - DB_USER="Enter Your MySql Username here"
   - DB_PASS="Enter Your MySQL Password here"
   - DB_NAME="Internship_Tracking_Application"
   - JWT_SECRET="super_super_secret"
4. **Start the backend server**:
   - node app.js
5. **Set Up the Frontend**:
   Open a new terminal window and navigate to the frontend directory:
   cd frontend
   npm install
   npm start
6. **Access the Application**:
   The application should now be running at http://localhost:3000
  
  
## Directory Structure
- **frontend**: Contains all the frontend code and assets.
- **server**: Contains all the backend code and database configurations.
- **public**: Contains static files for the frontend.
- **src**: Contains React components, styles, and other assets.

## Usage
- **User Registration**: Users can register to create their profiles.
- **Job Application**: Users can apply for internships and track their application history.
- **Admin Dashboard**: Admins can manage job postings.

## Contributors
1. Vaibhav Thalanki - https://github.com/Vaibhav-Thalanki
2. Saran Jagadeesan Uma - https://github.com/Saran-Jagadeesan-Uma

 