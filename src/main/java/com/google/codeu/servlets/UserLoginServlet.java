package com.google.codeu.servlets;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.apphosting.api.ApiProxy;
import com.google.codeu.data.EncryptPassword;
import com.google.common.base.Stopwatch;

import java.io.IOException;

import java.io.PrintWriter;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// [START gae_java8_mysql_app]
@SuppressWarnings("serial")
// With @WebServlet annotation the webapp/WEB-INF/web.xml is no longer required.
@WebServlet("/login")
public class UserLoginServlet extends HttpServlet {
    Connection conn;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException,
            ServletException {

        //below is dependent on what yuji and joel will create in html
        String loginemail = request.getParameter("email");
        String enteredpassword = request.getParameter("password");

        EncryptPassword p = new EncryptPassword(enteredpassword);

        final String selectSql = "SELECT * FROM open_project_db.users";

        try (ResultSet rs = conn.prepareStatement(selectSql).executeQuery()) {
            boolean success = false;
            while (rs.next()) {

                String email = rs.getString("email");
                String password = rs.getString("password");

                if (loginemail.equals(email) && p.performEncryption().equals(password)){
                    success = true;
                    if (rs.getString("faculty").equals("0")) {
                        response.sendRedirect("/student-page.html?user=" + email);
                    }
                    else if (rs.getString("faculty").equals("1")){
                        response.sendRedirect("/faculty-page.html?user=" + email);
                    }
                }

            }
        } catch (SQLException e) {
            throw new ServletException("SQL error", e);
        }


    }

}
// [END gae_java8_mysql_app]