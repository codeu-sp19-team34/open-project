/*
 * Copyright 2019 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package com.google.codeu.servlets;


import com.google.codeu.data.EncryptPassword;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Redirects the user to the Google login page or their page if they're already logged in.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

  Connection conn;
  EncryptPassword p;

  @Override
  public void doPost(HttpServletRequest request, HttpServletResponse resp) throws IOException, ServletException {

    String url = System.getProperty("cloudsql");
    log("connecting to: " + url);
    try {
      conn = DriverManager.getConnection(url);
    } catch (SQLException e) {
      throw new ServletException("Unable to connect to Cloud SQL", e);
    }


    String path = request.getRequestURI();
    if (path.startsWith("/favicon.ico")) {
      return; // ignore the request for favicon.ico
    }


    String memail = request.getParameter("inputEmail");
    String mpassword = request.getParameter("inputPassword");

    String find = "SELECT * FROM open_project_db.users WHERE email = \"" + memail + "\";";

    //PrintWriter out = resp.getWriter();
    //resp.setContentType("text/plain");

    try (ResultSet finder = conn.prepareStatement(find).executeQuery()) {
      if (finder.next()) {
        //out.println("that user already exists");
        p = new EncryptPassword(finder.getString("password"), new BigInteger(finder.getString("n")), new BigInteger(finder.getString("e")), new BigInteger(finder.getString("d")), finder.getInt("s"));

        //remove salt
        String dcry = p.performDecryption();
        if (finder.getInt("s") == 0) {
          dcry = dcry.substring(0, dcry.length() - 5);
        } else if (finder.getInt("s") == 1) {
          dcry = dcry.substring(0, dcry.length() - 10);
        } else if (finder.getInt("s") == 2) {
          dcry = dcry.substring(0, dcry.length() - 9);
        } else if (finder.getInt("s") == 3) {
          dcry = dcry.substring(0, dcry.length() - 7);
        }
        if (dcry.equals(mpassword)) { //user authentication
          resp.sendRedirect("/user-page.html?user=" + memail);
        }
        else {
          resp.sendRedirect("/login.html");
        }

      } else {
        resp.sendRedirect("/login.html");
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }

  }

  private int countUsers() throws ServletException {

    final String selectSql = "SELECT * FROM open_project_db.users";
    int count = 0;
    try (ResultSet rs = conn.prepareStatement(selectSql).executeQuery()) {

      while (rs.next()) {
        count++;
      }
    } catch (SQLException e) {
      throw new ServletException("SQL error -- couldnt count", e);
    }
    return count;
  }
}