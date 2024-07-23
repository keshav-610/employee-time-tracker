<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.annotation.WebServlet" %>
<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Task Duration Charts</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 20px;
    }

    .header {
        background-color: #343a40;
        color: #ffffff;
        padding: 10px;
        text-align: center;
    }

    .operation {
        text-align: center;
        margin: 20px 0;
    }

    .operation a {
        color: #007bff;
        margin: 0 10px;
        text-decoration: none;
    }

    .chart-container {
        width: 40%;
        margin: auto;
        text-align: center;
    }

    #totalDuration {
        text-align: center;
        margin-top: 20px;
    }
    .graph_and_pie{
    	display:flex;
    	justify-content:center;
    
    }
    .list-tasks {
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            text-align:center;
        }

        th, td {
	        text-align:center;
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        th {
        	text-align:center;
            background-color: #343a40;
            color: #ffffff;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
</style>
</head>
<body>
<div class="header">
    <% String employee_name = (String) session.getAttribute("emp_name");
    if(employee_name != null) {
        out.println("<h2>Welcome, " + employee_name + "</h2>");
    } else {
        out.println("Username not found");
    }
    %>
</div>
<div class="operation">
    <a href="add-task.jsp">Add Task</a>
    <a href="edit-task.jsp">Edit Task</a>
    <a href="delete-task.jsp">Delete Task</a>
</div>

<div class="graph_and_pie">
<div class="chart-container">
    <canvas id="taskPieChart" width="200" height="200"></canvas>
</div>
<div class="chart-container">
    <canvas id="taskBarChart" width="300" height="200"></canvas>
</div>
</div>
<div id="totalDuration"></div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        fetch('GetTaskData')
            .then(response => response.json())
            .then(data => {
                console.log(data);
                if (data.error) {
                    console.error('Error fetching pie data:', data.error);
                    return;
                }

                const totalDurationInSeconds = Object.values(data).reduce((acc, curr) => acc + curr, 0);
                const totalDurationInHours = totalDurationInSeconds / 3600;
                document.getElementById('totalDuration').innerText = 'Total Hours Worked : ' + totalDurationInHours.toFixed(2) + ' hours';

                const ctxPie = document.getElementById('taskPieChart').getContext('2d');
                const chartDataPie = {
                    labels: Object.keys(data),
                    datasets: [{
                        data: Object.values(data).map(d => d / 3600),
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',  
                            'rgba(54, 162, 235, 0.2)',  
                            'rgba(255, 206, 86, 0.2)',  
                            'rgba(75, 192, 192, 0.2)',  
                            'rgba(153, 102, 255, 0.2)',
                            'rgba(255, 159, 64, 0.2)',  
                            'rgba(201, 203, 207, 0.2)'  
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)',
                            'rgba(201, 203, 207, 1)'
                        ],
                        borderWidth: 1
                    }]
                };
                const configPie = {
                    type: 'pie',
                    data: chartDataPie,
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'top',
                            },
                            title: {
                                display: true,
                                text: 'Your Total Progress (Pie Chart)'
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(tooltipItem) {
                                        const value = tooltipItem.raw;
                                        return value.toFixed(2) + ' hours';
                                    }
                                }
                            }
                        }
                    },
                };

                new Chart(ctxPie, configPie);
            })
            .catch(error => console.error('Error fetching pie data:', error));

        fetch('GetLast5DaysData')
        .then(response => response.json())
        .then(data => {
            console.log(data);
            if (data.error) {
                console.error('Error fetching bar data:', data.error);
                return;
            }

            const sortedData = Object.entries(data).sort((a, b) => new Date(a[0]) - new Date(b[0]));

            const ctxBar = document.getElementById('taskBarChart').getContext('2d');
            const chartDataBar = {
                labels: sortedData.map(entry => entry[0]), 
                datasets: [{
                    label: 'Hours worked per day (last 5 days)',
                    data: sortedData.map(entry => entry[1] / 3600), 
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            };

            const configBar = {
                type: 'bar',
                data: chartDataBar,
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Hours'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        title: {
                            display: true,
                            text: 'Hours worked per day (Bar Chart)'
                        },
                        tooltip: {
                            callbacks: {
                                label: function(tooltipItem) {
                                    const value = tooltipItem.raw;
                                    return value.toFixed(2) + ' hours';
                                }
                            }
                        }
                    }
                }
            };

            new Chart(ctxBar, configBar);
        })
        .catch(error => console.error('Error fetching bar data:', error));

    });
</script>
<div class="list-tasks">
        <h2>Today's Tasks</h2>
        <%
            String emp_name = (String) session.getAttribute("emp_name");
            if (emp_name != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/time_tracker", "root", "keshav610");

                    LocalDate today = LocalDate.now();
                    
                    String query = "SELECT task_category, task_description, start_time, end_time FROM task_table WHERE emp_name = ? AND task_date = ?";
                    PreparedStatement pst = con.prepareStatement(query);
                    pst.setString(1, emp_name);
                    pst.setDate(2, java.sql.Date.valueOf(today));

                    // Execute query
                    ResultSet rs = pst.executeQuery();
        %>
        <table>
            <tr>
                <th>Task Name</th>
                <th>Description</th>
                <th>Start Time</th>
                <th>End Time</th>
            </tr>
            <%
                    // Iterate through the result set and display each task
                    while (rs.next()) {
                        String taskName = rs.getString("task_category");
                        String taskDescription = rs.getString("task_description");
                        String startTime = rs.getTime("start_time").toString();
                        String endTime = rs.getTime("end_time").toString();
            %>
            <tr>
                <td><%= taskName %></td>
                <td><%= taskDescription %></td>
                <td><%= startTime %></td>
                <td><%= endTime %></td>
            </tr>
            <%
                    }
                    // Close resources
                    rs.close();
                    pst.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                out.println("<p>No employee ID found in session.</p>");
            }
        %>
        </table>
    </div>

</body>
</html>
