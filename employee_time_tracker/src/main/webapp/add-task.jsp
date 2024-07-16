<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add a new Task</title>
</head>
<body>
<h2>Add a new Task</h2>
	<form action="add-task" method="post">
		<label>Project Name</label>
		<input type="text" name="project-name"/><br><br>
		
		<label>Role</label>
		<input type="text" name="task-role"/><br><br>
		
		<label>Date</label>
		<input type="date" name="task-date"/><br><br>
		
		<label>Start Time</label>
		<input type="time" name="task-start-time"/><br><br>
		
		<label>End Time</label>
		<input type="time" name="task-end-time"/><br><br>
		
		<label>Task Category</label>
		<input type="text" name="task-category"/><br><br>
		
		<label>Description</label>
		<textarea name="task-description"></textarea><br><br>	
		
		<input type="submit" value="Add"/>		
	</form>
</body>
</html>