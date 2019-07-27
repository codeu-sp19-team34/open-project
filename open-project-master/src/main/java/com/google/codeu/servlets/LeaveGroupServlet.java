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

@WebServlet({"/leavegroup"})
public class LeaveGroupServlet extends HttpServlet {
    Connection conn;

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String url = System.getProperty("cloudsql");
        this.log("connecting to: " + url);

        try {
            this.conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String groupid = request.getParameter("groupid");
        String userid = request.getParameter("userid");
        int groupsize = Integer.parseInt(request.getParameter("groupsize"));
        String query = "DELETE FROM open_project_db.group_users WHERE (group_id = \"" + groupid + "\") and (user_id = \"" + userid + "\");\n";
        PreparedStatement statement = null;

        try {
            statement = this.conn.prepareStatement(query);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String decrementcount = "UPDATE open_project_db.groups SET size = \"" + (groupsize - 1) + "\" WHERE (id = \"" + groupid + "\")\n";

        try {
            statement = this.conn.prepareStatement(decrementcount);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException("SQL error", e);
        }

        response.sendRedirect("/welcome.jsp?userid=" + userid);
    }
}
