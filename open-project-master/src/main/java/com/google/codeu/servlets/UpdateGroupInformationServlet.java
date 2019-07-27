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
import com.google.codeu.data.EncryptPassword;
import com.google.common.base.Stopwatch;

import java.io.IOException;
import java.math.BigInteger;
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
@WebServlet("/updateginfo")
public class UpdateGroupInformationServlet extends HttpServlet {

    Connection conn;

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

        String userid = req.getParameter("userid");
        String groupid = req.getParameter("groupid");
        String thegroup =req.getParameter("thegroup");
        String choice = req.getParameter("choice");

        String url = System.getProperty("cloudsql");
        log("connecting to: " + url);
        try {
            conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String query = "";

        if (choice.equals("2")){
            query = "UPDATE open_project_db.groups SET max_size = \"" + req.getParameter("xsize") + "\" WHERE (id = \"" + groupid + "\");\n";
            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            //resp.sendRedirect();
            req.getRequestDispatcher("/group_settings.jsp?thegroup=" + thegroup + "&userid=" + userid + "&groupid=" + groupid).forward(req, resp);

        }


        else if (choice.equals("4")){

            query = "UPDATE open_project_db.groups SET description = \"" + req.getParameter("xdes") + "\" WHERE (id = \"" + groupid + "\");\n";
            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            //resp.sendRedirect("/group_settings.jsp?thegroup=" + thegroup + "&userid=" + userid + "&groupid=" + groupid);
            req.getRequestDispatcher("/group_settings.jsp?thegroup=" + thegroup + "&userid=" + userid + "&groupid=" + groupid).forward(req, resp);


        }

        else if (choice.equals("5")) {
            //delete the user from all the groups
            String primary = "DELETE FROM open_project_db.group_users WHERE (group_id = \"" + groupid + "\");";

            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(primary);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            //delete all of the users messages
            String delmsgs = "DELETE FROM open_project_db.messages WHERE (group_id = \"" + groupid + "\");";

            try {
                statement = conn.prepareStatement(delmsgs);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            //delete the user now that all of the dependent stuff is gone
            query = "DELETE FROM open_project_db.groups WHERE (id = \"" + groupid + "\");";
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();
                resp.sendRedirect("/welcome.jsp?userid=" + userid);


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