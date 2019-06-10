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
import java.util.ArrayList;
import java.util.TreeMap;

// [START gae_java8_mysql_app]
@WebServlet("/joingroup")
public class JoinGroupServlet extends HttpServlet {

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

        String userid = request.getParameter("userid");
        String groupid = request.getParameter("id");
        String group = request.getParameter("group");

        String query = "INSERT INTO open_project_db.group_users (group_id, user_id) VALUES (\"" + groupid + "\", \"" + userid + "\")\n";

        PreparedStatement statement;
        try {
            statement = conn.prepareStatement(query);
            statement.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("SQL error", e);

        }

        String findsize = " SELECT * FROM open_project_db.groups WHERE id = " + groupid;
        int size = 0;
        try(ResultSet rs = conn.prepareStatement(findsize).executeQuery()) {

            while (rs.next()) {
                size = rs.getInt("size");
            }

        } catch (SQLException e) {
            throw new ServletException("SQL error", e);

        }

        String incrementcount = "UPDATE open_project_db.groups SET size = \"" + (size + 1) + "\" WHERE (id = \"" + groupid + "\")\n";
        try {
            statement = conn.prepareStatement(incrementcount);
            statement.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("SQL error", e);

        }


        response.sendRedirect("/grouppage.jsp?group="+ group +"&id="+ groupid +"&userid=" + userid);


    }
}
