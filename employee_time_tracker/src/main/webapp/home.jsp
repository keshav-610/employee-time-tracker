<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Task Duration Pie Chart</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

<div class="chart-container" style="width: 30%; margin: auto;">
    <canvas id="taskPieChart" width="300" height="300"></canvas>
</div>
<div id="totalDuration" style="text-align: center; margin-top: 20px;"></div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        fetch('GetTaskData')
            .then(response => response.json())
            .then(data => {
                console.log(data);
                if (data.error) {
                    console.error(data.error);
                    return;
                }

                const totalDurationInSeconds = Object.values(data).reduce((acc, curr) => acc + curr, 0);
                const totalDurationInHours = totalDurationInSeconds / 3600;
                document.getElementById('totalDuration').innerText = 'Total Duration: ' + totalDurationInHours.toFixed(2) + ' hours';

                const ctx = document.getElementById('taskPieChart').getContext('2d');
                const chartData = {
                    labels: Object.keys(data),
                    datasets: [{
                        data: Object.values(data).map(d => d / 3600),
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',  // Color for "Checking"
                            'rgba(54, 162, 235, 0.2)',  // Color for "Coding"
                            'rgba(255, 206, 86, 0.2)',  // Color for "Production"
                            'rgba(75, 192, 192, 0.2)',  // Color for "Testing"
                            'rgba(153, 102, 255, 0.2)', // Color for "Meeting"
                            'rgba(255, 159, 64, 0.2)',  // Color for "Designing"
                            'rgba(201, 203, 207, 0.2)'  // Color for "Debugging"
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
                const config = {
                    type: 'pie',
                    data: chartData,
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'top',
                            },
                            title: {
                                display: true,
                                text: 'Your Total Progress'
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

                new Chart(ctx, config);
            })
            .catch(error => console.error('Error fetching task data:', error));
    });
</script>
</body>
</html>
