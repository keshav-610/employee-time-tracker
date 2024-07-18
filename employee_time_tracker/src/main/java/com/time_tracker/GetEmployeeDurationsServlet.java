package com.time_tracker;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/GetEmployeeDurationsServlet")
public class GetEmployeeDurationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JSONArray labels = new JSONArray();
        JSONArray durations = new JSONArray();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/time_tracker", "root", "keshav610");
            PreparedStatement pst = con.prepareStatement("SELECT emp_name, SUM(TIME_TO_SEC(duration) / 3600) AS total_duration FROM task_table GROUP BY emp_name");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                labels.put(rs.getString("emp_name"));
                durations.put(rs.getDouble("total_duration"));
            }

            rs.close();
            pst.close();
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        JSONObject json = new JSONObject();
        json.put("labels", labels);
        json.put("durations", durations);
        response.getWriter().print(json.toString());
    }
}
