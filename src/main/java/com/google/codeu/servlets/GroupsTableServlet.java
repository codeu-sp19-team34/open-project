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

import java.io.IOException;

import java.io.PrintWriter;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// [START gae_java8_mysql_app]
@SuppressWarnings("serial")
@WebServlet(name = "groups",
    description = "Groups: Send groups data from CloudSQL open_project_db",
    urlPatterns = "/groups")
public class GroupsTableServlet extends HttpServlet {
  Connection conn;

  @Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException,
      ServletException {

    final String selectSql = "SELECT * FROM open_project_db.groups";

    PrintWriter out = resp.getWriter();
    resp.setContentType("text/plain");

    try (ResultSet rs = conn.prepareStatement(selectSql).executeQuery()) {
      out.print("Groups:\n");
      while (rs.next()) {
        String id = rs.getString("id");
        String creator_id = rs.getString("creator_id");
        String name = rs.getString("name");
        String course = rs.getString("course");
        String size = rs.getString("size");
        String max_size = rs.getString("max_size");

        out.println(id + ", " + creator_id + ": " + name + ", " + course);
        out.println(size + ", " + max_size + "\n");

      }
    } catch (SQLException e) {
      throw new ServletException("SQL error", e);
    }
  }

  @Override
  public void init() throws ServletException {
    String url = System.getProperty("groups");
    log("connecting to: " + url);
    try {
      conn = DriverManager.getConnection(url);
    } catch (SQLException e) {
      throw new ServletException("Unable to connect to Cloud SQL", e);
    }
  }
}
// [END gae_java8_mysql_app]
