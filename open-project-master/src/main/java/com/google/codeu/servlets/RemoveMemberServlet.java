/*
 * Copyright 2016 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.codeu.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

// [START gae_java8_mysql_app]
@WebServlet("/byemember")
public class RemoveMemberServlet extends HttpServlet {

    Connection conn;

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        String url = System.getProperty("cloudsql");
        log("connecting to: " + url);
        try {
            conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String groupid = request.getParameter("groupid");
        String group = request.getParameter("group");
        String userid = request.getParameter("userid");
        String choice = request.getParameter("choice");

        if (choice.equals("1")){

            group = request.getParameter("xname").replaceAll("\\s","");

            String query = "UPDATE open_project_db.groups SET name = \"" + request.getParameter("xname") + "\" WHERE (id = \"" + groupid + "\");\n";
            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();
                request.getServletContext().getRequestDispatcher("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid).forward(request, response);
                //response.sendRedirect();
                //return;

            } catch (SQLException e) {
                e.printStackTrace();
            }


        }

        else if (choice.equals("2")) {

            String memberid = request.getParameter("memberid");
            int thissize = 0;

            String query1 = "SELECT * FROM open_project_db.groups WHERE id = " + groupid + ";\n";

            try (ResultSet rs = conn.prepareStatement(query1).executeQuery()){

                if(rs.next()) {
                    thissize = rs.getInt("size");
                }
                //response.sendRedirect("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid);
                //request.getServletContext().getRequestDispatcher("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid).forward(request, response);

            } catch (SQLException e) {
                throw new ServletException("SQL error", e);

            }
            String query2 = "UPDATE open_project_db.groups SET size = \"" + (thissize -1) + "\" WHERE (id = " + groupid + ");\n";

            PreparedStatement statement;
            try {
                statement = conn.prepareStatement(query2);
                statement.executeUpdate();
                //response.sendRedirect("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid);
                //request.getServletContext().getRequestDispatcher("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid).forward(request, response);

            } catch (SQLException e) {
                throw new ServletException("SQL error", e);

            }

            String query3 = "DELETE FROM open_project_db.group_users WHERE (group_id = " + groupid + ") and (user_id = " + memberid + ");\n";


            try {
                statement = conn.prepareStatement(query3);
                statement.executeUpdate();
                //response.sendRedirect("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid);
                request.getServletContext().getRequestDispatcher("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid).forward(request, response);

            } catch (SQLException e) {
                throw new ServletException("SQL error", e);

            }


        }

        else if (choice.equals("3")){

            String query = "UPDATE open_project_db.groups SET style = \"" + request.getParameter("style") + "\" WHERE (id = \"" + groupid + "\");\n";

            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();
                //response.sendRedirect("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid);
                request.getServletContext().getRequestDispatcher("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid).forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
            }


        }


    }


    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doPost(request, response);

    }

}