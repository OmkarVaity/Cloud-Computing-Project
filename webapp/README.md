# Webapp

## Environment Setup: 
Before running the application, make sure to setup .env file with following variables:

DB_HOST=localhost
DB_USER=your_postgres_username
DB_PASSWORD=your_postgres_password
DB_DATABASE=your_database_name
DB_PORT=5432
PORT=3000

## Build Instructions

### 1. Clone the Repository: 
git clone https://github.com/vaityomkar/webapp.git
cd webapp

### 2. Install Dependencies: 
npm install 

### 3. Configure PostgreSQL DB:
Make sure postgresql is running and db is setup. 

### 4. Start the Application: 
npm start

### 5. Access the Application: 
http://localhost:3000/healthz
localhost:3000/v1/user/self
localhost:3000/v1/user

### 6. Run Tests
npm test  
  


    