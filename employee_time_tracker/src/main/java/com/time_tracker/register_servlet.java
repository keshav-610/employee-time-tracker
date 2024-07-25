package com.time_tracker;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;
import javax.activation.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class register_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Define a fixed salt
    private static final String FIXED_SALT = "$2a$10$ABCDEFGHIJKLMNOPQRSTUV"; 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String emp_name = request.getParameter("name");
        String ageStr = request.getParameter("age");
        String role = request.getParameter("employee_role");
        String phone_number = request.getParameter("phone_number");
        String email = request.getParameter("email");

        int age = 0;
        if (ageStr != null && !ageStr.isEmpty()) {
            try {
                age = Integer.parseInt(ageStr);
            } catch (NumberFormatException e) {
                request.setAttribute("status", "Invalid age format.");
                request.getRequestDispatcher("employee.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("status", "Age is required.");
            request.getRequestDispatcher("employee.jsp").forward(request, response);
            return;
        }

        int emp_id = generateEmployeeId();
        String emp_password = generateEmployeePassword();

        // Hash the password using the fixed salt
        String hashedPassword = BCrypt.hashpw(emp_password, FIXED_SALT);

        RequestDispatcher dispatcher = null;
        Connection con1 = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/time_tracker", "root", "keshav610");
            pst = con1.prepareStatement("INSERT INTO employee_table (emp_id, emp_name, age, role, phone_number, email, emp_password) VALUES(?,?,?,?,?,?,?)");

            pst.setInt(1, emp_id);
            pst.setString(2, emp_name);
            pst.setInt(3, age);
            pst.setString(4, role);
            pst.setString(5, phone_number);
            pst.setString(6, email);
            pst.setString(7, hashedPassword);

            int rowcount = pst.executeUpdate();
            dispatcher = request.getRequestDispatcher("login.jsp");
            if (rowcount > 0) {
                request.setAttribute("status", "success");
            } else {
                request.setAttribute("status", "failed");
            }
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "exception: " + e.getMessage());
            dispatcher = request.getRequestDispatcher("employee.jsp");
            dispatcher.forward(request, response);
        } finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (con1 != null) {
                try {
                    con1.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private int generateEmployeeId() {
        return new Random().nextInt(99999999);
    }

    private String generateEmployeePassword() {
        return String.valueOf(new Random().nextInt(999999));
    }
}
