package com.time_tracker;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@WebServlet("/GetTaskData")
public class GetTaskData extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // Database connection details
            String url = "jdbc:mysql://localhost:3306/time_tracker";
            String user = "root";
            String password = "keshav610";

            // Establish the connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);

            // Query to fetch the task data
            String query = "SELECT task_category, TIME_TO_SEC(duration) AS duration_seconds FROM task_table";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);

            // Process the result set
            Map<String, Double> taskData = new HashMap<>();
            while (rs.next()) {
                String category = rs.getString("task_category");
                double duration = rs.getDouble("duration_seconds");

                taskData.put(category, taskData.getOrDefault(category, 0.0) + duration);
            }

            // Convert the data to JSON
            Gson gson = new Gson();
            String jsonData = gson.toJson(taskData);

            out.print(jsonData);
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
