//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.google.codeu.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Blob;
import java.util.TreeMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet({"/findgroup"})
public class FindGroupsServlet extends HttpServlet {
    Connection conn;

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String url = System.getProperty("cloudsql");
        this.log("connecting to: " + url);

        try {
            this.conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("Unable to connect to Cloud SQL", e);
        }

        String subject = request.getParameter("subject");
        String number = request.getParameter("number");
        String professor = request.getParameter("professor").toLowerCase();
        String school = "";
        String userid = request.getParameter("userid");
        String findschool = "SELECT * FROM open_project_db.users WHERE id = \"" + userid + "\"\n";
        int style = Integer.parseInt(request.getParameter("style"));

        try (ResultSet rs = this.conn.prepareStatement(findschool).executeQuery()){

                while(rs.next()) {
                    school = rs.getString("university");
                }

        } catch (SQLException e) {
            throw new ServletException("SQL error", e);
        }

        String course = subject + " " + number;
        String query = "SELECT * FROM open_project_db.groups WHERE course = \"" + course + "\" AND professor = \"" + professor + "\"\n";
        TreeMap results = new TreeMap();

        try (ResultSet rs = this.conn.prepareStatement(query).executeQuery()){

                this.log("\n \n \n \n doing this");

                while(rs.next()) {
                    this.log("\n \n \n \n there is stuff");
                    if (rs.getString("school").equals(school) && rs.getInt("size") < rs.getInt("max_size")) {
                        if (rs.getInt("style") == style) {

                            Blob blob = rs.getBlob("name");
                            byte[] bdata = blob.getBytes(1, (int) blob.length());
                            String tgn = new String(bdata, "UTF-8");


                            results.put(tgn, rs.getInt("id"));
                        }
                    }
                }

        } catch (SQLException e) {
            throw new ServletException("SQL error", e);
        }

        request.setAttribute("findresults", results);
        request.setAttribute("usersid", userid);
        request.setAttribute("subject", subject);
        request.setAttribute("number", number);
        request.setAttribute("professor", professor);
        request.setAttribute("style", style);
        //request.getRequestDispatcher("/find-group.jsp?subject=" + subject + "&number=" + number + "&professor=" + professor + "&style=" + style).forward(request, response);
        request.getRequestDispatcher("/find-group.jsp").forward(request, response);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        doPost(request, response);
    }
}
