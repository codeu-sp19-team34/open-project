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
@WebServlet("/tryagain")
public class ExpressInterestServlet extends HttpServlet {

    Connection conn;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        this.log("performing the interest");


        String url = System.getProperty("cloudsql");

        try {
            this.conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String userid = request.getParameter("userid");
        String subject = request.getParameter("subject");
        String number = request.getParameter("number");
        String professor = request.getParameter("professor");
        String style = request.getParameter("style");
        this.log("number 1");

        int id = count();

        String query = "INSERT INTO open_project_db.interest (id, department, courseno, professor, style, userid) VALUES (" + id
                + ", \"" + subject.toUpperCase() + "\", " + number + ", \"" + professor.toLowerCase() + "\", " + style + ", " + userid + ");\n";
        PreparedStatement statement = null;
        try {
            statement = this.conn.prepareStatement(query);
            statement.executeUpdate();
            log("done interest");
            request.getServletContext().getRequestDispatcher("/groups.jsp?userid=" +userid).forward(request, response);



        } catch (SQLException e) {
                e.printStackTrace();
        }

    }


    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doGet(request, response);

    }

    private int count() throws ServletException {

        final String selectSql = "SELECT * FROM open_project_db.interest";
        int count = 0;
        try (ResultSet rs = conn.prepareStatement(selectSql).executeQuery()) {

            if (rs.next()){
                rs.last();
                count = rs.getInt("id") + 1;
            }
            /** while (rs.next()) {
             count++;
             }*/
        } catch (SQLException e) {
            throw new ServletException("SQL error -- couldnt count", e);
        }
        return count;
    }

}