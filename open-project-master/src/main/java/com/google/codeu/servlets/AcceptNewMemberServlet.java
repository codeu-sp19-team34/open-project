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
@WebServlet("/acceptnewperson")
public class AcceptNewMemberServlet extends HttpServlet {

    Connection conn;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String url = System.getProperty("cloudsql");

        try {
            this.conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String userid = request.getParameter("userid");
        String addid = request.getParameter("addid");
        String groupid = request.getParameter("groupid");
        String group = request.getParameter("group");
        int size = Integer.parseInt(request.getParameter("size"));
        String dept = request.getParameter("dept");
        String no = request.getParameter("no");

        //add to group users
        String addtogu = "INSERT INTO open_project_db.group_users (group_id, user_id) VALUES (" + groupid + ", " + addid + ");";
        PreparedStatement statement = null;
        try {
            statement = conn.prepareStatement(addtogu);
            statement.executeUpdate();
           // request.getServletContext().getRequestDispatcher("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid).forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }


        //increase the number of group members by 1 in groups

        String increaseby1 = "UPDATE open_project_db.groups SET size = " + (size + 1) + " WHERE (id = " + groupid + ");";
        try {
            statement = conn.prepareStatement(increaseby1);
            statement.executeUpdate();
            //request.getServletContext().getRequestDispatcher("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid).forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        //delete from the interest

        String deletefrominterest = "DELETE FROM open_project_db.interest WHERE (userid = " + addid + ") AND (department = \"" + dept + "\") AND (courseno = " + no + ");";
        try {
            statement = conn.prepareStatement(deletefrominterest);
            statement.executeUpdate();
            request.getServletContext().getRequestDispatcher("/admin_settings.jsp?group=" + group + "&id=" + groupid + "&userid=" + userid).forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }


    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doGet(request, response);

    }


}