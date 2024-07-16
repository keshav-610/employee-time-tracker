<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="header">
<% String employee_name= (String) session.getAttribute("emp_name");
if(employee_name !=null){
	out.println("<h2>Welcome, "+employee_name+"</h2>");
}
else{
	out.println("Username not found");
}
%>
</div>
<div class="operation">
<a href="add-task.jsp">Add Task</a>
<a href="edit-task.jsp">Edit Task</a>
<a href="delete-task.jsp">Delete an task</a>
</div>

</body>
</html>