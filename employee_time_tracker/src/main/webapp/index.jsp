<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Time Tracker</title>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #e9ecef;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
        color: #495057;
    }
    h2 {
        font-size: 2.5em;
        margin-bottom: 20px;
        color: #343a40;
        font-weight: 600;
    }
    a {
        display: inline-block;
        margin: 10px;
        padding: 15px 25px;
        text-decoration: none;
        color: #fff;
        background-color: #007bff;
        border-radius: 8px;
        font-size: 1.1em;
        font-weight: 500;
        transition: background-color 0.3s ease, transform 0.3s ease;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    a:hover {
        background-color: #0056b3;
        transform: translateY(-2px);
    }
    .container {
        text-align: center;
        background-color: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        width: 80%;
        max-width: 500px;
    }
</style>
</head>
<body>
    <div class="container">
        <h2>Task Tracker</h2>
        <a href="admin_login.jsp">Admin</a>
        <a href="employee.jsp">Employee</a>
    </div>
</body>
</html>
