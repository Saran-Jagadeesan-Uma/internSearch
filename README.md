# README for InternSearch Project

## Project Overview

The **InternSearch** project is a web application designed to facilitate the connection between students and internship opportunities. It provides features for users to create profiles, apply for jobs, and manage their application history. Additionally, the application includes an admin dashboard for managing job postings.

## Technical Specifications

### Frontend (JavaScript)
- **Framework**: React.js (version 18.3.1)
- **Styling**: CSS
- **Libraries**:
  - **Axios**: For making HTTP requests.
  - **Formik**: For handling forms and validation.
  - **Yup**: For schema validation of form inputs.
  - **React Router DOM**: For client-side routing.
  - **React Icons**: For incorporating icons.
  - **JWT Decode**: For decoding JSON Web Tokens.

### Server (JavaScript) and DB (MySQL)
- **Server Framework**: Node.js with Express.js
- **Database**: MySQL
- **Libraries**:
  - **Body-parser**: For parsing incoming request bodies.
  - **CORS**: For enabling Cross-Origin Resource Sharing.
  - **Bcryptjs**: For hashing passwords securely.
  - **JSON Web Token (JWT)**: For user authentication.
  - **mysql2**: MySQL Driver for NodeJS.



## Prerequisites

Before you begin, ensure you have the following software installed on your computer:

1. **Node.js**: Download and install Node.js from the [Node.js Download Page](https://nodejs.org/).
2. **MySQL**: Download and install MySQL from the [MySQL Download Page](https://dev.mysql.com/downloads/mysql/).

## Installation Instructions

To set up the project on your local machine, follow these steps:

1. **Download the zip and extract it**:  
 Download the zip file from the repository and extract it to a directory of your choice and navigate to its directory in terminal.  

   ```
   cd path/to/internSearch
   ```  
  
  
2. **Set Up the MySQL Database**:  
   Run the SQL script `Project_dump.sql` in MySQL Workbench to create the database for our application.


3. **Set up the server (NodeJS)**:  
   Navigate to `./server` and run the following command to install the required packages:

   ```
   npm install
   ```

   Add environment variables:
   ```
   DB_HOST="127.0.0.1"
   DB_USER=<Enter Your MySql Username here>
   DB_PASS=<Enter Your MySQL Password here>
   DB_NAME="Internship_Tracking_Application"
   JWT_SECRET="super_super_secret"
   PORT=4000
   ```
   Now, you are all set, you can run the server on port 4000 using:
   ```
   node app.js
   ```
   
4. **Set Up the Frontend (ReactJS)**:  
   Navigate to `./frontend` and run the following command to install the required packages:

   ```
   npm install
   ```

   You can now run the React App on port 3000:
   ```
   npm start
   ```

5. **Access the Application**:  
   The application should now be running at http://localhost:3000/login  



## Directory Structure
- **frontend**: Contains all the frontend code and assets.
- **server**: Contains all the backend code and database configurations.
- **ProjectCreate.sql**: Contains the SQL create statements along with dummy data insertion. (Added for reference)
- **Project_dump.sql**: Contains the dump for the database.  


---------------------
> Admin1 Login: 
```
username: "vaibhavthalanki"
password: "editor123"
```

> Admin2 Login: 
```
username: "saranj"
password: "password123"
```

## Contributors
1. Vaibhav Thalanki - https://github.com/Vaibhav-Thalanki
2. Saran Jagadeesan Uma - https://github.com/Saran-Jagadeesan-Uma

 