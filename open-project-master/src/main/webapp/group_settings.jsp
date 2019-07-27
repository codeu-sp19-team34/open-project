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
<%@page import="java.sql.Blob"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title> Settings | StudyU: Study Group Finder</title>
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

<body onload="addLoginOrLogoutLinkToNavigation();" style="background-color:#056691">

    <% String userid = request.getParameter("userid");
       String groupid = request.getParameter("groupid");
       String thegroup = request.getParameter("thegroup");

        Connection conn;

                   String url = System.getProperty("cloudsql");
                           try {
                               conn = DriverManager.getConnection(url);
                           } catch (SQLException e) {
                               throw new ServletException("Unable to connect to Cloud SQL", e);
                           }


       String isadmin = "SELECT * FROM open_project_db.groups WHERE id = \"" + groupid + "\"\n";
            String adminnumber = "";
             try (ResultSet rss = conn.prepareStatement(isadmin).executeQuery()){

                    if (rss.next()) {
                          adminnumber = Integer.toString(rss.getInt("admin"));
                    }
              } catch (SQLException e) {
                    throw new ServletException("SQL error", e);
              }

         String findusername = "SELECT * FROM open_project_db.users WHERE id = " + userid;

                    try(ResultSet rs = conn.prepareStatement(findusername).executeQuery()) {
                        while (rs.next()) {
                        //check to see if the user is actually logged in
                        //if theyre not, then take them to the login page
                       if (rs.getString("loggedin").equals("0")) {
                        %>
                            <jsp:forward page="/oops"/>
                        <%
                       }
                        }
                     } catch (SQLException e) {
                       throw new ServletException("SQL error", e);

                    }

                    //now find the group info to display

                    String findthegroup = "SELECT * FROM open_project_db.groups WHERE id = " + groupid;
                    String gname = "";
                    String gcourse = "";
                    int gsize = 0;
                    int gmax = 0;
                    String gprofessor = "";
                    String gschool = "";
                    int gstyle = 0;
                    String gdescription = "";
                    int gadmin = 0;
                    //int grstyle = 0;

                    try(ResultSet finding = conn.prepareStatement(findthegroup).executeQuery()) {
                        while (finding.next()) {

                            Blob b = finding.getBlob("name");
                            byte[] bdata = b.getBytes(1, (int) b.length());

                            gname = new String(bdata, "UTF-8");

                            gcourse = finding.getString("course");
                            gsize = finding.getInt("size");
                            gmax = finding.getInt("max_size");
                            gprofessor = finding.getString("professor");
                            gschool = finding.getString("school");
                            gstyle = finding.getInt("style");

                            Blob blah = finding.getBlob("description");
                            byte[] ddata = blah.getBytes(1, (int) blah.length());
                            gdescription = new String(ddata, "UTF-8");

                            gadmin = finding.getInt("admin");

                        }
                     } catch (SQLException e) {
                       throw new ServletException("SQL error", e);

                    }


    %>
    <!-- Navigation menu component -->
    <nav>
        <!-- Bootstrap nav menu template -->
        <ul class="nav justify-content-end" id="navigation">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true"
              aria-expanded="false">Menu</a>
                  <div class="dropdown-menu">
                      <a class="dropdown-item" href="/grouppage.jsp?group=<%=thegroup%>&id=<%=groupid%>&userid=<%=userid%>">Group Chat</a>
                      <a class="dropdown-item" href="/group_resources.jsp?group=<%=thegroup%>&id=<%=groupid%>&userid=<%=userid%>">Resources</a>
                      <%
                      if (userid.equals(adminnumber)) {
                      %>
                            <a class = "dropdown-item" href = "/admin_settings.jsp?group=<%=thegroup%>&id=<%=groupid%>&userid=<%=userid%>"> Admin Settings </a>
                      <%
                        }
                      %>

                     <%
                        if (gstyle == 1) {
                     %>
                          <a class = "dropdown-item" href = "/schedule_meeting.jsp?group=<%=thegroup%>&id=<%=groupid%>&userid=<%=userid%>"> Schedule Meeting </a>
                     <%
                        }
                     %>
                  </div>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/welcome.jsp?userid=<%=userid%>">Home</a>
            </li>
            <li class="nav-item">
               <a class="nav-link active" href="/logout?userid=<%=userid%>">Logout</a>
            </li>
        </ul>
    </nav>
    <!-- End of navigation menu component -->
    <br>
    <h1 align="center" style="color:#eae672;"> Group Settings </h1>
    <br><br>

    <div class="form-container" align="center" style="height:50%;">

            <div align ="center" style="width:60%;height:60%;">
                <h3 align="center" style="color:#eae672;"> Change Maximum Size </h3>
                <form action = "/updateginfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="2" >
                      <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input type="hidden" id="thegroup" name="thegroup" value="<%=thegroup%>" >
                      <input id="xsize" name="xsize" type="number" min=<%=gsize%> max ="6" autocomplete = "off" class="form-control" placeholder="<%=gmax%>">
                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>

                <h3 align="center" style="color:#eae672;"> Change Group Description </h3>
                <form action = "/updateginfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="4" >
                      <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input type="hidden" id="thegroup" name="thegroup" value="<%=thegroup%>" >

                      <%
                        if (gdescription == null) {

                      %>

                        <input id="xdes" name="xdes" autocomplete = "off" class="form-control" placeholder="Enter description">


                      <%

                         }

                         else {

                      %>
                       <input id="xdes" name="xdes" autocomplete = "off" class="form-control" placeholder="<%=gdescription%>">

                      <%
                        }
                      %>


                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>

                <%
                    if (gadmin != Integer.parseInt(userid)){
                %>
                <form action = "/leavegroup" method = "post" target="_self">
                       <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                       <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                       <input type="hidden" id="groupsize" name="groupsize" value="<%=gsize%>" >
                       <!--<input type="hidden" id="thegroup" name="thegroup" value="<%=thegroup%>" >-->
                       <button class="btn btn-lg btn-primary btn-block text-uppercase" style="background-color:red;" type="submit"> Leave Group </button>

                </form>

                <%
                    }
                %>
                <br>



            </div>
     </div>



</body>

</html>