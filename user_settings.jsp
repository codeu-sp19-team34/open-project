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
</head>

<body onload="addLoginOrLogoutLinkToNavigation();">

    <% String userid = request.getParameter("userid"); %>
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
                <a class="nav-link active" href="/index.html">Logout</a>
            </li>
        </ul>
    </nav>
    <!-- End of navigation menu component -->

    <%

          Connection conn;

                    String path = request.getRequestURI();
                        if (path.startsWith("/favicon.ico")) {
                          return; // ignore the request for favicon.ico
                        }

                        String url = System.getProperty("cloudsql");
                        log("connecting to: " + url);
                        try {
                          conn = DriverManager.getConnection(url);
                        } catch (SQLException e) {
                          throw new ServletException("Unable to connect to Cloud SQL", e);
                        }


            String findusername = "SELECT * FROM open_project_db.users WHERE id = " + userid;
            String firstname = "";
            String lastname = "";
            String email = "";
            String phone = "";

            try(ResultSet rs = conn.prepareStatement(findusername).executeQuery()) {
                while (rs.next()) {

                firstname = rs.getString("first_name");
                lastname = rs.getString("last_name");
                email = rs.getString("email");
                phone = rs.getString("phone_number");
                }
             } catch (SQLException e) {
               throw new ServletException("SQL error", e);

            }

    %>
    <h1 align="center"> Settings </h1>
    <br><br>

    <div class="form-container" align="center" style="height:50%;">

            <div align ="center" style="width:60%;height:60%;">
                <h3 align="center"> Change First Name </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                     <input type="hidden" id="choice" name="choice" value="1" >
                     <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                     <input id="xfirst" name="xfirst" autocomplete = "off" class="form-control" placeholder="<%=firstname%>">
                     &nbsp
                     <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                     <hr class="my-4">
                </form>
                <h3 align="center"> Change Last Name </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="2" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input id="xlast" name="xlast" autocomplete = "off" class="form-control" placeholder="<%=lastname%>">
                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>
                <h3 align="center"> Change Password </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="3" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input id="xpassword" name="xpassword" autocomplete = "off" class="form-control" placeholder="Change Password">
                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>
                <h3 align="center"> Change Email </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="4" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input type = "email" id="xemail" name="xemail" autocomplete = "off" class="form-control" placeholder="<%=email%>">
                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>
                <h3 align="center"> Change Phone Number </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="5" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input type = "tel" id="xphone" name="xphone" autocomplete = "off" class="form-control" placeholder="<%=phone%>">
                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>

                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="6" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" style="background-color:red;" type="submit"> Delete Account </button>
                      <hr class="my-4">
                </form>


            </div>
        </div>



</body>

</html>