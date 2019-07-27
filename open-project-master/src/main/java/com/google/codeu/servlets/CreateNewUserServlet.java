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

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigInteger;
import java.sql.*;

/**
 * Redirects the user to the Google login page or their page if they're already logged in.
 */
@WebServlet("/newuser")
public class CreateNewUserServlet extends HttpServlet {

  Connection conn;
  EncryptPassword p;

  @Override
  public void doPost(HttpServletRequest request, HttpServletResponse resp) throws IOException {
    String path = request.getRequestURI();
    if (path.startsWith("/favicon.ico")) {
      return; // ignore the request for favicon.ico
    }

    final String selectSql = "SELECT * FROM open_project_db.users";

    String mfirst = request.getParameter("mfname");
    String mlast = request.getParameter("mlname");
    String mphone = request.getParameter("mphone");

    //first need to check to see if the phone number they entered is actually a number
    //if it is not, then you have them re-enter their info
    String regex = "\\d+";
    if (!mphone.matches(regex)){
      resp.sendRedirect("/index.html");
    }

    String muni = request.getParameter("muni");
    String memail = request.getParameter("inputEmail");
    String mpassword = request.getParameter("inputPassword");
    
    String find = "SELECT * FROM open_project_db.users WHERE email = \"" + memail +"\";";

    //PrintWriter out = resp.getWriter();
    //resp.setContentType("text/plain");

    try (ResultSet finder = conn.prepareStatement(find).executeQuery()){
      if (finder.next()) {
          resp.sendRedirect("/index.html");

      }
      else { //create a new user and add the encrypted password and the keys to the database
        int id = 0;
        try {
          id = countUsers();
        } catch (ServletException e) {
          e.printStackTrace();
        }

        p = new EncryptPassword(mpassword);
        BigInteger n = p.getPublickey();
        BigInteger e = p.getExponent();
        BigInteger d = p.getPrivatekey();
        int sa = p.getSalt();

        String s = "INSERT INTO open_project_db.users (id, first_name, last_name, university, email, phone_number, password, n, e, d, s, loggedin) VALUES (" +
                id + ", \"" + mfirst + "\", \"" + mlast + "\", \"" + muni + "\", \"" + memail + "\", \"" +
                mphone + "\", \"" + p.performEncryption() + "\", \"" + n + "\", \"" + e + "\", \"" + d + "\", " + sa + ", \"" + 1 + "\");\n";

       // String s = "INSERT INTO open_project_db.users VALUES (" + id + ", \"" + mfirst + "\", \"" +
         //       mlast + "\", \"" + muni + "\", \"" + memail + "\", \"" + mphone + "\"" +
           //     ", \"" + p.performEncryption() + "\", \"" + n + "\", \"" + e + "\", \"" + d + "\", " + sa + ", \"" + 1 +"\");";

        PreparedStatement statement = conn.prepareStatement(s);
        statement.executeUpdate();
        //out.println("new user has been created");
        //resp.sendRedirect("/user-page.html?user=" + memail);
        resp.sendRedirect("/welcome.jsp?userid=" + id);
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }


  }

  private int countUsers() throws ServletException {

    final String selectSql = "SELECT * FROM open_project_db.users";
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


