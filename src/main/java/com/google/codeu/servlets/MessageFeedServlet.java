package com.google.codeu.servlets;

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

@SuppressWarnings("serial")
@WebServlet(name = "CloudSQL",
    description = "CloudSQL: Write messages from open_project_db to CloudSQL",
    urlPatterns = "/feed")

public class MessagesFeedServlet extends HttpServlet {
  Connection connect;

  @Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException,
      ServletException {

    final String selectSql = "SELECT * FROM open_project_db.messages";

    PrintWriter out = resp.getWriter();
    resp.setContentType("text/plain");

    try (ResultSet rs = connect.prepareStatement(selectSql).executeQuery()) {
      out.print("Messages:\n");
      while (rs.next()) {
        String id = rs.getString("id");
        String firstName = rs.getString("user_id");
        String lastName = rs.getString("message");

        out.println(id + ": " + user_id + " " + message);
      }
    } catch (SQLException e) {
      throw new ServletException("SQL error", e);
    }

  }

  @Override
  public void init() throws ServletException {
    String url = System.getProperty("cloudsql");
    log("connecting to: " + url);
    try {
      connect = DriverManager.getConnection(url);
    } catch (SQLException e) {
      throw new ServletException("Unable to connect to Cloud SQL", e);
    }
  }
}
