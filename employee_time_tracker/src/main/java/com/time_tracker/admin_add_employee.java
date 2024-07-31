package com.time_tracker;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Random;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet implementation class admin_add_employee
 */
@WebServlet("/admin_add_emp")
public class admin_add_employee extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String emp_name = request.getParameter("name");
        int age = Integer.parseInt(request.getParameter("age"));
        String role = request.getParameter("employee_role");
        String phone_number = request.getParameter("phone_number");
        String email = request.getParameter("email");

        int emp_id = generate_employee_id();
        String emp_password = generate_employee_password();
        
        String fixedSalt = "$2a$10$eImiTXuWVxfM37uY4JANjQ";
        
        String hashed_password = BCrypt.hashpw(emp_password,fixedSalt);

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
            pst.setString(7, hashed_password);

            int rowcount = pst.executeUpdate();
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
            if (rowcount > 0) {
                request.setAttribute("status", "success");
                
                sendemail(email,emp_id,emp_password);
            } else {
                request.setAttribute("status", "failed");
            }
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "exception: " + e.getMessage());
            dispatcher = request.getRequestDispatcher("admin_home.jsp");
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
    private int generate_employee_id() {
        return new Random().nextInt(99999999); 
    }

    private String generate_employee_password() {
        return String.valueOf(new Random().nextInt(999999));  
    }
    private void sendemail(String toAddress, int employee_id, String employee_password) throws MessagingException {
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
                "Employee Account ID: " + employee_id + "\n" +
                "Employee Password: " + employee_password + "\n" +
                "Please don't use your temporary password for login purposes.\n" +
                "Please activate your account by setting a new PIN.\n\n" +
                "Best Regards,\nCorporate");

Transport.send(message);
        
    }
}
