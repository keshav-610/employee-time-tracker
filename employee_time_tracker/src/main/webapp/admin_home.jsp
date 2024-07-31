<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Employee</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 100vh;
    }
    
    h2 {
        text-align: center;
        color: #343a40;
    }
    
    .container {
        background-color: #ffffff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        width: 100%;
        margin-top: 20px;
        max-width: 600px; 
    }
    
    .container form {
        display: flex;
        flex-direction: column;
    }
    
    .container label {
        margin-bottom: 10px;
    }
    
    .container input[type="text"],
    .container input[type="email"],
    .container input[type="number"],
    .container input[type="password"],
    .container select,
    .container input[type="submit"] {
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
        width: calc(100% - 22px);
    }
    
    .container input[type="submit"] {
        background-color: #007bff;
        color: white;
        border: none;
        cursor: pointer;
    }
    
    .container input[type="submit"]:hover {
        background-color: #0056b3;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    .list-employees{
    	width:80%
    }
    th, td {
        border: 1px solid #dee2e6;
        padding: 8px;
        text-align:center;
    }
    th {
        background-color: #343a40;
        color: #ffffff;
    }
    tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    .piechart{
    	height:500px;
    	width:500px;
    }   
    .operation{
    	display:flex;
    	justify-content:space-evenly;
    	width:100%;	
    } 
    .operation a{
    	font-size:15px;	
    	background-color:#007bff;
    	color:white;
    	padding:12px;
    	text-decoration:none;
    	border-radius:10px;
    }
    .operation a:hover{
    	background-color: #0056b3;
    }
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<h2>Welcome Admin</h2>
<hr>
<div class="container">
    <h2>Add New Employee</h2>
    <form action="admin_add_emp" method="post">
        <div>
            <label for="name">Employee Name</label>
            <input type="text" name="name" placeholder="Enter employee name" required/>
        </div>
        <div>
            <label for="age">Age</label>
            <input type="number" name="age" placeholder="Enter employee age" required/>
        </div>
        <div>
            <label for="role">Role</label>
            <input type="text" name="employee_role" placeholder="Enter employee role" required/>
        </div>
        <div>
            <label for="phone">Phone Number</label>
            <input type="text" name="phone_number" placeholder="Enter phone number" required/>
        </div>
        <div>
            <label for="email">Email</label>
            <input type="email" name="email" placeholder="Enter email" required/>
        </div>
        <input type="submit" value="Add Employee"/>
    </form>
    <%
        String status = request.getParameter("status");
        if (status != null) {
            out.print("Status: " + status);
        }
    %>
</div><br/><br/>
<div class="operation">
	<a href="admin_edit_employee.jsp">Edit Employee Details</a>
	<a href="admin_delete_employee.jsp">Delete Employee Details</a>
</div>
<h2>List of Employees</h2>
    <div class="list-employees">
        <table>
            <tr>
                <th>Employee ID</th>
                <th>Name</th>
                <th>Age</th>
                <th>Role</th>
                <th>Phone Number</th>
                <th>Email</th>
            </tr>
            <%
            try{
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con= DriverManager.getConnection("jdbc:mysql://localhost:3306/time_tracker", "root", "keshav610");
                PreparedStatement pst= con.prepareStatement("SELECT emp_id, emp_name, age, role, phone_number, email FROM employee_table");
                ResultSet rs=pst.executeQuery();
                
                while(rs.next()){
                    %>
                    <tr>
                        <td><%=rs.getInt("emp_id") %></td>
                        <td><%=rs.getString("emp_name") %></td>
                        <td><%=rs.getInt("age") %></td>
                        <td><%=rs.getString("role") %></td>
                        <td><%=rs.getString("phone_number") %></td>
                        <td><%=rs.getString("email") %></td>
                    </tr>
                    <%
                }
                 rs.close();
                 pst.close();
                 con.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
                    %>
        </table>
    </div>

<h2>Employee Work Duration Pie Chart</h2>
<div class="piechart"><canvas id="myPieChart"></canvas></div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        fetch('GetEmployeeDurationsServlet')
            .then(response => response.json())
            .then(data => {
                console.log("Data fetched: ", data); 
                const ctx = document.getElementById('myPieChart').getContext('2d');
                new Chart(ctx, {
                    type: 'pie',
                    data: {
                        labels: data.labels,
                        datasets: [{
                            label: 'Work Duration (hours)',
                            data: data.durations,
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.2)',
                                'rgba(54, 162, 235, 0.2)',
                                'rgba(255, 206, 86, 0.2)',
                                'rgba(75, 192, 192, 0.2)',
                                'rgba(153, 102, 255, 0.2)',
                                'rgba(255, 159, 64, 0.2)'
                            ],
                            borderColor: [
                                'rgba(255, 99, 132, 1)',
                                'rgba(54, 162, 235, 1)',
                                'rgba(255, 206, 86, 1)',
                                'rgba(75, 192, 192, 1)',
                                'rgba(153, 102, 255, 1)',
                                'rgba(255, 159, 64, 1)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true, 
                        aspectRatio: 1,
                        plugins: {
                            legend: {
                                position: 'top',
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(tooltipItem) {
                                        return tooltipItem.label + ': ' + tooltipItem.raw + ' hours';
                                    }
                                }
                            }
                        }
                    }
                });
            })
            .catch(error => console.error('Error fetching data:', error));
    });
</script>
</body>
</html>
