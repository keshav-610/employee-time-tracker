<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sign up</title>
<style>
 body {
        font-family: Arial, sans-serif;
        background-color: #f0f2f5;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
        color: #333;
    }
    .header {
        display: flex;
        justify-content: space-evenly;
        width: 100%;
    }
    h2 {
        font-size: 2em;
        margin-bottom: 20px;
        text-align: center;
    }
    h2 a {
        text-decoration: none;
        color: #007BFF;
    }
    h2 a:hover {
        color: #0056b3;
    }
    form {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        width: 80%;
        max-width: 400px;
        text-align: left;
    }
    form label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
    }
    form input[type="number"] {
        width: calc(100% - 22px);
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px; 
    }
    form input[type="text"],
    form input[type="email"] {
        width: calc(100% - 22px);
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    form input[type="submit"] {
        width: 100%;
        background-color: #000;
        color: white;
        border: none;
        padding: 10px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 1em;
    }
    form input[type="submit"]:hover {
        background-color: #2f302f;
    }
    .status-message {
        margin: 10px 0;
        padding: 10px;
        border-radius: 5px;
        font-weight: bold;
    }
    .status-success {
        color: #28a745;
        background-color: #d4edda;
    }
    .status-error {
        color: #dc3545;
        background-color: #f8d7da;
    }
</style>
</head>
<body>
    <div class="header">
        <h2>Sign Up</h2>
        <h2><a href="login.jsp">Login</a></h2>
    </div>
    <form action="register" method="post">
        <label>Name</label>
        <input type="text" name="name" required /><br><br>
        
        <label>Age</label>
        <input type="number" name="age" required /><br><br>
        
        <label>Role</label>
        <input type="text" name="employee_role" required /><br><br>
        
        <label>Phone Number</label>
        <input type="text" name="phone_number" required /><br><br>
        
        <!-- Display status message here -->
        <% 
            String status = (String) request.getAttribute("status");
            if (status != null && !status.isEmpty()) {
                String statusClass = status.contains("Exception") ? "status-error" : "status-success";
        %>
            <div class="status-message <%= statusClass %>">
                <%= status %>
            </div>
        <% 
            } 
        %>
        
        <label>Email</label>
        <input type="email" name="email" required /><br><br>
        
        <input type="submit" value="Register"/>
    </form>
</body>
</html>
