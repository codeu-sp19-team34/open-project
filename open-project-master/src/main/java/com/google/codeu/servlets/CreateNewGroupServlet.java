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

import com.google.apphosting.api.ApiProxy;
import com.google.common.base.Stopwatch;

import java.io.IOException;
import java.util.List;

import java.io.PrintWriter;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.sql.*;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

// [START gae_java8_mysql_app]
@WebServlet("/newgroup")
public class CreateNewGroupServlet extends HttpServlet {

    Connection conn;

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

        String url = System.getProperty("cloudsql");
        log("connecting to: " + url);
        try {
            conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String name = req.getParameter("name");
        String coursedept = req.getParameter("subject").toUpperCase();
        String courseno = req.getParameter("numberco");
        String userid = req.getParameter("userid");

        String course = coursedept + " " + courseno;

        String school = req.getParameter("school");
        String professor = req.getParameter("professor").toLowerCase();

        String styler = req.getParameter("style");
        String description = req.getParameter("description");

        int number = Integer.parseInt(req.getParameter("number"));
        int style = Integer.parseInt(styler);
        int groupid = countGroups();

        String query = "INSERT INTO open_project_db.groups (id, name, course, size, max_size, professor, school, style, description, admin) VALUES (" + groupid
                + ", \"" + name + "\", \"" + course + "\", " +
                1 + ", " + number + ", \"" + professor + "\", \"" + school + "\", " + style + ", \"" +
                description + "\", " + userid + ");\n";

        PreparedStatement statement = null;
        try {
            statement = conn.prepareStatement(query);
            statement.executeUpdate();


        } catch (SQLException e) {
            e.printStackTrace();
        }

        //now add that user to the group they just created so that when the group is created they don't have
        //to also join the group as well
        String formattedname1 = name.replaceAll("\\s","");

        byte[] fo = formattedname1.getBytes();

        String formattedname = new String(fo, "UTF-8");


        String addpersontogroup = "INSERT INTO open_project_db.group_users (group_id, user_id) VALUES (" + groupid + ", " + userid + ");\n";

        PreparedStatement newstatement = null;
        try {
            newstatement = conn.prepareStatement(addpersontogroup);
            newstatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }


        resp.sendRedirect("/grouppage.jsp?group=" + formattedname + "&id=" + groupid + "&userid=" + userid);


    }

    private int countGroups() throws ServletException {

        final String selectSql = "SELECT * FROM open_project_db.groups";
        int count = 0;
        try (ResultSet rs = conn.prepareStatement(selectSql).executeQuery()) {

            while (rs.next()) {
                rs.last();
                count = rs.getInt("id") + 1;
            }
        } catch (SQLException e) {
            throw new ServletException("SQL error -- couldnt count", e);
        }
        return count;
    }

}