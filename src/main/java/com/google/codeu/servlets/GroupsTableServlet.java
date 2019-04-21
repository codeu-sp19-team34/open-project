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

package com.example.appengine.cloudsql;

import com.google.apphosting.api.ApiProxy;
import com.google.common.base.Stopwatch;
import com.google.codeu.data.Group;

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
@WebServlet("/groups")
public class GroupsTableServlet extends HttpServlet {

  Connection conn;
  Group g;

  @Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

    System.out.println("IN DOGET FUNCTION");

    String query = "SELECT * FROM open_project_db.groups";

    resp.setContentType("text/html");
    PrintWriter out = resp.getWriter();

    try(ResultSet rs = conn.prepareStatement(query).executeQuery()) {
      out.print("Groups:\n");
      while (rs.next()) {
        int id = rs.getInt("id");
        int creator_id = rs.getInt("creator_id");
        String name = rs.getString("name");
        String course = rs.getString("course");
        int size = rs.getInt("size");
        int max_size = rs.getInt("max_size");

        g = new Group(id, creator_id, name, course, size, max_size);

        out.println("<p>");
        out.println(id + ", " + creator_id + ": " + name + ", " + course + "\t" + size + ", " + max_size + "\n");
        out.println("</p>");
      }
    } catch (SQLException e) {
      throw new ServletException("SQL error", e);
    } finally {
      out.close();
    }
  }

  @Override
  public void init() throws ServletException {
    String url = System.getProperty("cloudsql");
    log("connecting to: " + url);
    try {
      conn = DriverManager.getConnection(url);
    } catch (SQLException e) {
      throw new ServletException("Unable to connect to Cloud SQL", e);
    }
  }
}
