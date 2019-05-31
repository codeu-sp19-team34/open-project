<!--
Copyright 2019 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

<%@page import="java.util.ArrayList"%>
<%@page import="javax.servlet.ServletException"%>
<%@page import="javax.servlet.annotation.WebServlet"%>
<%@page import="javax.servlet.http.HttpServlet"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="javax.servlet.http.HttpServletResponse"%>
<%@page import="java.io.IOException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>CodeU 2019 Starter Project</title>
    <link rel="stylesheet" href="/css/main.css">

    <!-- jQuery CDN Link -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!-- Bootstrap 4 Link -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <!-- Font Awesome Icons link -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css">


    <script src="/js/navigation-loader.js"></script>
</head>

<body onload="buildUI();">
    <!-- Navigation menu component -->
    <nav>
        <!-- Bootstrap nav menu template -->
        <ul class="nav justify-content-end" id="navigation">
            <li class="nav-item">
                <a class="nav-link active" href="#">Home</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Messages</a>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true"
                    aria-expanded="false">Groups</a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="#">Create a Group</a>
                    <a class="dropdown-item" href="#">Find a Group</a>
                </div>
            </li>
        </ul>
    </nav>
    <!-- End of navigation menu component -->

    <%
        Connection conn;

        String url = System.getProperty("cloudsql");
                log("\n \n \n \n group paggggggggeeee ");
                try {
                    conn = DriverManager.getConnection(url);
                } catch (SQLException e) {
                    throw new ServletException("Unable to connect to Cloud SQL", e);
                }

                String groupid = request.getParameter("id");
                String thegroup = request.getParameter("group");

                //trying
                request.setAttribute("groupid", groupid);
                request.setAttribute("thegroup", thegroup);

                String query = "SELECT * FROM open_project_db.groups WHERE id = \"" + groupid + "\"\n";
                String groupformalname = "";
                String groupcourse = "";
                int groupsize = 0;
                int groupmaxsize = 0;
                String groupsubjects = "";
                String groupprofessor = "";
                String groupschool = "";
                String userid = request.getParameter("userid");

                request.setAttribute("userid", userid);

                try(ResultSet rs = conn.prepareStatement(query).executeQuery()) {

                    while (rs.next()) {
                        groupformalname = rs.getString("name");
                        groupcourse = rs.getString("course");
                        groupsize = rs.getInt("size");
                        groupmaxsize = rs.getInt("max_size");
                        groupsubjects = rs.getString("subjects");
                        groupprofessor = rs.getString("professor");
                        groupschool = rs.getString("school");
                    }

                } catch (SQLException e) {
                    throw new ServletException("SQL error", e);

                }

            //checking to see if the user already belongs to the group
         String ingroupalready = "SELECT * FROM open_project_db.group_users WHERE group_id = \"" + groupid + "\" AND user_id = \"" + userid + "\"\n";

         try(ResultSet rs = conn.prepareStatement(ingroupalready).executeQuery()) {

              if (!rs.next()) { //locked, the user needs to request access

          %>
               <h1 align = "center"> <%=groupformalname%></h1>
               <h3 align = "center"> <%=groupsize%> Members </h3>

               <form class="joining" action="/joingroup" method=post target = "_self">

                    <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                    <input type="hidden" id="id" name="id" value="<%=groupid%>" >
                    <input type="hidden" id="group" name="group" value="<%=thegroup%>" >

                   <div style="text-align:center">
                         <button type="submit" class="btn btn-primary" style="height:100px;width:200px"> Join Group </button>
                   </div>

               </form>

          <%
              }
              else { //the user already belongs to this
          %>

            <h1 align = "center"> <%=groupformalname%></h1>
            <h3 align = "center"> <%=groupsize%> Members </h3>

          <%



              }

           } catch (SQLException e) {
               throw new ServletException("SQL error", e);

           }


    %>






</body>
</html>