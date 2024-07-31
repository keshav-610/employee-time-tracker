package com.time_tracker;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class register_servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        if (phone_number == null || phone_number.length() != 10) {
            request.setAttribute("status", "Phone number must be 10 digits.");
            request.getRequestDispatcher("employee.jsp").forward(request, response);
            return;
        }

        int emp_id = generateEmployeeId();
        String emp_password = generateEmployeePassword();

        String hashedPassword = BCrypt.hashpw(emp_password, FIXED_SALT);

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
            if (rowcount > 0) {
                try {
                    sendEmail(email, emp_id, emp_password);
                    request.setAttribute("status", "Registration successful. Check your email for details.");
                } catch (MessagingException e) {
                    e.printStackTrace();
                    request.setAttribute("status", "Email send failed: " + e.getMessage());
                }
            } else {
                request.setAttribute("status", "Registration failed.");
            }
            request.getRequestDispatcher("employee.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "Exception: " + e.getMessage());
            request.getRequestDispatcher("employee.jsp").forward(request, response);
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

    private void sendEmail(String toAddress, int emp_id, String emp_password) throws MessagingException {
        final String username = "kesavaprakash1610@gmail.com";
        final String password = "duyu mpdi lxuj myvk";
        final String smtpHost = "smtp.gmail.com";
        final String smtpPort = "587";

        Properties properties = new Properties();
        properties.put("mail.smtp.host", smtpHost);
        properties.put("mail.smtp.port", smtpPort);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
        message.setSubject("Your Employee Details");
        message.setText("Dear Employee,\n\n" +
                        "Your account has been successfully registered.\n\n" +
                        "Employee Account ID: " + emp_id + "\n" +
                        "Employee Password: " + emp_password + "\n" +
                        "Please don't use your temporary password for login purposes.\n" +
                        "Please activate your account by setting a new PIN.\n\n" +
                        "Best Regards,\nCorporate");

        Transport.send(message);
    }
}
