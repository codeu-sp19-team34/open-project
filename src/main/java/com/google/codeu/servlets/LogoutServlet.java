//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.google.codeu.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet({"/logout"})
public class LogoutServlet extends HttpServlet {
    Connection conn;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String url = System.getProperty("cloudsql");
        this.log("connecting to: " + url);

        try {
            this.conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String userid = request.getParameter("userid");

        String loggedout = "UPDATE open_project_db.users SET loggedin = \"" + 0 + "\" WHERE (id = \"" + userid + "\");\n";
        PreparedStatement statement = null;
        try {
            statement = conn.prepareStatement(loggedout);
            statement.executeUpdate();


        } catch (SQLException e) {
            e.printStackTrace();
        }


        response.sendRedirect("/index.html");
    }


    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doGet(request, response);
    }
}
