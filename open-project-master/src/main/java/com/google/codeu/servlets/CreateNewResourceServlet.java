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
@WebServlet("/createresource")
public class CreateNewResourceServlet extends HttpServlet {

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

        String groupid = request.getParameter("id");
        String userid = request.getParameter("userid");
        String resourcename = request.getParameter("resname");

        String resourceurl = request.getParameter("reslink");
        String group = request.getParameter("group");
        int idno = getResourceId();


        String query = "INSERT INTO open_project_db.resources (resource_id, groupid, name, url) VALUES (\"" + idno + "\", \"" + groupid + "\", \"" + resourcename + "\", \"" + resourceurl + "\");\n";

        PreparedStatement statement;
        try {
            statement = conn.prepareStatement(query);
            statement.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("SQL error", e);

        }

        //response.sendRedirect("/group_resources.jsp?group="+ group +"&id="+ groupid +"&userid=" + userid);
        request.getServletContext().getRequestDispatcher("/group_resources.jsp?group="+ group +"&id="+ groupid +"&userid=" + userid).forward(request, response);

    }

    public int getResourceId() throws ServletException {

        String query = "SELECT * FROM open_project_db.resources";
        try(ResultSet rs = conn.prepareStatement(query).executeQuery()) {

            if(rs.next()) {
                rs.last();
                return rs.getInt("resource_id") + 1;
            }

        } catch (SQLException e) {
            throw new ServletException("SQL error", e);

        }

        return 0;


    }
}
