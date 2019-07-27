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
@WebServlet("/updateinfo")
public class UpdateInformationServlet extends HttpServlet {

    Connection conn;

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

        String userid = req.getParameter("userid");
        String choice = req.getParameter("choice");

        String url = System.getProperty("cloudsql");
        log("connecting to: " + url);
        try {
            conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String query = "";

        if (choice.equals("1")){

            query = "UPDATE open_project_db.users SET first_name = \"" + req.getParameter("xfirst") + "\" WHERE (id = \"" + userid + "\");\n";
            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            resp.sendRedirect("/user_settings.jsp?userid=" + userid);
        }
        else if (choice.equals("2")){
            query = "UPDATE open_project_db.users SET last_name = \"" + req.getParameter("xlast") + "\" WHERE (id = \"" + userid + "\");\n";
            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            resp.sendRedirect("/user_settings.jsp?userid=" + userid);

        }

        else if (choice.equals("3")){

            query = "UPDATE open_project_db.users SET university = \"" + req.getParameter("xuni") + "\" WHERE (id = \"" + userid + "\");\n";
            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            resp.sendRedirect("/user_settings.jsp?userid=" + userid);

            //once a user changes their school, i was thinking their old groups should be cleared
            //but in case they make a mistake I do not think this should be the case.


        }

        else if (choice.equals("4")){

            EncryptPassword p = new EncryptPassword(req.getParameter("xpassword"));
            BigInteger n = p.getPublickey();
            BigInteger e = p.getExponent();
            BigInteger d = p.getPrivatekey();
            int sa = p.getSalt();

            query = "UPDATE open_project_db.users SET password = \"" + p.performEncryption() +
                    "\", n = \"" + n + "\", e = \"" + e + "\", d = \"" + d + "\", s = \"" + sa +
                    "\" WHERE (id = \"" + userid + "\");\n";

            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException f) {
                f.printStackTrace();
            }

            resp.sendRedirect("/user_settings.jsp?userid=" + userid);


        }
        else if (choice.equals("5")){
            query = "UPDATE open_project_db.users SET email = \"" + req.getParameter("xemail") + "\" WHERE (id = \"" + userid + "\");\n";
            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            resp.sendRedirect("/user_settings.jsp?userid=" + userid);

        }

        else if (choice.equals("6")){
            query = "UPDATE open_project_db.users SET phone_number = \"" + req.getParameter("xphone") + "\" WHERE (id = \"" + userid + "\");\n";
            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            resp.sendRedirect("/user_settings.jsp?userid=" + userid);

        }
        else if (choice.equals("7")){
            //delete the user from all the groups
            String primary = "DELETE FROM open_project_db.group_users WHERE (user_id = \"" + userid + "\");";

            PreparedStatement statement = null;
            try {
                statement = conn.prepareStatement(primary);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            //delete all of the users messages
            String delmsgs = "DELETE FROM open_project_db.messages WHERE (user_id = \"" + userid + "\");";

            try {
                statement = conn.prepareStatement(delmsgs);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            //delete the user now that all of the dependent stuff is gone
            query = "DELETE FROM open_project_db.users WHERE (id = \"" + userid + "\");";
            try {
                statement = conn.prepareStatement(query);
                statement.executeUpdate();


            } catch (SQLException e) {
                e.printStackTrace();
            }

            resp.sendRedirect("/index.html");

        }




    }



}