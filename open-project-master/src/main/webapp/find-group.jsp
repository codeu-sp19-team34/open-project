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
<%@page import="java.util.TreeMap"%>
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
<%@page import="java.sql.Blob"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title> Results | StudyU: Study Group Finder </title>
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

            <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Comfortaa" />

            <style>

                body {
                    font-family: 'Comfortaa', cursive;
                }
            </style>
</head>

<% String userid = (String)request.getAttribute("usersid");
Connection conn;

            String url = System.getProperty("cloudsql");
                    try {
                        conn = DriverManager.getConnection(url);
                    } catch (SQLException e) {
                        throw new ServletException("Unable to connect to Cloud SQL", e);
                    }
     String loggedin = "SELECT * FROM open_project_db.users WHERE id = \"" + userid + "\"\n";

     try (ResultSet rs = conn.prepareStatement(loggedin).executeQuery()){
            if (rs.next()) {
              if (rs.getString("loggedin").equals("0")) {
               %>
                     <jsp:forward page="/oops"/>
               <%
               }
            }

       } catch (SQLException e) {
              throw new ServletException("SQL error", e);
     }




 %>

<body onload="addLoginOrLogoutLinkToNavigation();" style="background-color:#056691">
    <!-- Navigation menu component -->
<nav>
    <!-- Bootstrap nav menu template -->
    <ul class="nav justify-content-end" id="navigation">
            <li class="nav-item">
                <a class="nav-link active" href="/welcome.jsp?userid=<%=userid%>">Home</a>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true"
                   aria-expanded="false">Groups</a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="/create-group.jsp?userid=<%=userid%>">Create a Group</a>
                    <a class="dropdown-item" href="/groups.jsp?userid=<%=userid%>">Find a Group</a>
                </div>
            </li>
            <li class="nav-item">
                 <a class="nav-link active" href="/logout?userid=<%=userid%>">Logout</a>
            </li>
    </ul>
</nav>

    <!-- End of navigation menu component -->

    <div class="form-container">
    <br>
            <h2 class="primary-heading" style="margin-bottom: 0px !important" align="center"> Search Results </h2>
            <div style="height: 2px; background-color: white; width: 15%; margin: 25px auto;"></div>

            <div align = center>

                <%
                TreeMap<String, Integer> results = (TreeMap<String, Integer>) request.getAttribute("findresults");

                if (results.size() == 0) {
                %>
                    <h1 class="primary-heading" style="margin-bottom: 0px !important" align="center"> Sorry, we could not find any groups that match. </h1>

                    <!-- then ask them if they want to express interest in joing a group -->
                    <br><br>
                    <div align="center">
                        <form action="/tryagain" method="post" target="_self">
                            <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                            <input type="hidden" id="subject" name="subject" value="<%=request.getAttribute("subject")%>">
                            <input type="hidden" id="number" name="number" value="<%=request.getAttribute("number")%>">
                            <input type="hidden" id="professor" name="professor" value="<%=request.getAttribute("professor")%>">
                            <input type="hidden" id="style" name="style" value="<%=request.getAttribute("style")%>">
                            <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit" align="center" style="width:70%;"> Express interest in a group for this class </button>
                        </form>
                        <br>
                       <div align="center" style = "width:70%">
                             <p align="center"> If you would like to join a group when one of your classmates creates one, choose EXPRESS INTEREST and the group admin will be notified. </p>
                       </div>
                    <div>
                <%
                }

                else {

                   for (String key: results.keySet()) {

                   int members = 0;
                   int sizeofgroup = 0;
                   String desc = "";

                    String groupquery = "SELECT * FROM open_project_db.groups WHERE id = \"" + Integer.toString(results.get(key)) + "\"\n";

                         try (ResultSet mrs = conn.prepareStatement(groupquery).executeQuery()){
                                if (mrs.next()) {
                                  members = mrs.getInt("size");
                                  sizeofgroup = mrs.getInt("max_size");

                                  Blob bo = mrs.getBlob("description");
                                  byte[] ddata = bo.getBytes(1, (int) bo.length());
                                  desc = new String(ddata, "UTF-8");
                                }

                           } catch (SQLException e) {
                                  throw new ServletException("SQL error", e);
                         }

                     String id = Integer.toString(results.get(key));

                     String link = key.replaceAll("\\s","");

                %>
                    <a href="/grouppage.jsp?group=<%=link%>&id=<%=id%>&userid=<%=userid%>"> <button type="button" class="btn btn-primary" style="height:200px;width:60%;" align = "center"> <h3 style="font-size:20px;"><%=key%></h3> <br> <p style = "font-size:15px;"><%=members%> members / limit <%=sizeofgroup%> </p> <br> <p style = "font-size:12px;"> <%=desc%> </p> </button> </a>
                    <br><br>
                <%
                    }

                 }

                %>

              </div>
     </div>



</body>

</html>