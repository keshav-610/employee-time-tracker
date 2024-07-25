<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<style>
    body {
        font-family: "DM Sans", sans-serif;
        font-optical-sizing: auto;
        font-weight: 600;
        font-style: normal;
        background-color: #f0f2f5;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        color: #333;
    }
    .header {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        padding: 20px;
        background-color: #ffffff;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        display: flex;
        justify-content: space-evenly;
        align-items: center;
        z-index: 1000; 
    }
    .header h2 {
        margin: 0;
        font-size: 2em;
    }
    .header h2 a {
        text-decoration: none;
        color: #007BFF;
    }
    .header h2 a:hover {
        color: #0056b3;
    }
    .form-container {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        width: 80%;
        max-width: 400px;
        margin-top: 100px;
    }
    .form-container h2 {
        font-size: 1.5em;
        margin-bottom: 15px;
        color: #333;
    }
    form label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        color: #333;
    }
    form input[type="text"],
    form input[type="password"] {
        width: calc(100% - 20px);
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-family: "DM Sans", sans-serif;
        font-optical-sizing: auto;
        font-weight: 600;
        font-style: normal;
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
        transition: background-color 0.3s ease;
    }
    form input[type="submit"]:hover {
        background-color: #333;
    }
    p {
        text-align: center;
        font-size: 1em;
        margin-top: 10px;
        color: #666;
    }
</style>
</head>
<body>
    <div class="header">
        <h2><a href="employee.jsp">Sign Up</a></h2>
        <h2>Login</h2>
    </div>
    <div class="form-container account-login">
        <h2>Account Login</h2>
        <form action="login" method="post">
            <label for="employee-id">Enter your Employee ID</label>
            <input type="text" id="employee-id" name="employee-id" autocomplete="off" required/><br>       
                        
            <label for="employee-password">Enter your Account Password</label>
            <input type="password" id="employee-password" name="employee-password" autocomplete="off" required/><br>
            
            <input type="submit" value="Login"/>
        </form>
    </div>
</body>
</html>
