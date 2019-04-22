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

import com.google.codeu.data.Group;

import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.io.PrintWriter;
import java.sql.*;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@SuppressWarnings("serial")
@WebServlet(name="GroupsTableServlet", value="/groups")
public class GroupsTableServlet extends HttpServlet {

  // Preformatted HTML
  String headers = "<!DOCTYPE html><meta charset=\"utf-8\"><h1>Welcome to the Study Groups Page</h1><h3><a href=\"groups\">Add a new group</a></h3>";
  String blogPostDisplayFormat = "<h2> %s </h2> Created at: %s by %s [<a href=\"/update?id=%s\">update</a>] | [<a href=\"/delete?id=%s\">delete</a>]<br><br> %s <br><br>";

  Connection conn;
  Group g;

  @Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

    final String query = "SELECT * FROM open_project_db.groups";

    PrintWriter out = resp.getWriter();

    out.println(headers); // Print HTML headers

    try (ResultSet rs = conn.prepareStatement(query).executeQuery()) {
      Map<Integer, Group> groups = new HashMap<>();

      while (rs.next()) {
        int id = rs.getInt("id");
        int creator_id = rs.getInt("creator_id");
        String name = rs.getString("name");
        String course = rs.getString("course");
        int size = rs.getInt("size");
        int max_size = rs.getInt("max_size");

        g = new Group(id, creator_id, name, course, size, max_size);

        groups.put(id, g);
      }

      out.println("<table>");
      groups.forEach(
              (k, v) -> {
                // Encode the ID into a websafe string
                String encodeID = Base64.getUrlEncoder().encodeToString(String.valueOf(k).getBytes());


                // Build up string with values from Cloud SQL

                String recordOutput =
                        String.format("<tr><td>%s</td><td>%s</td><td>%d</td><td>%d</td></tr>", v.getGroupName(), v.getGroupCourse(), v.getGroupSize(), v.getGroupMaxSize());
                out.println(recordOutput);
              });
      out.println("</table>");
    } catch (SQLException e) {
      throw new ServletException("SQL error", e);
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
