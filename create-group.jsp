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
    <title> Create Group | StudyU: Group Finder</title>
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

<% String userid = request.getParameter("userid"); %>

<body onload="addLoginOrLogoutLinkToNavigation();">
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



    <div class="container">
        <div class="row">
            <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
                <div class="card card-signin my-5">
                    <div class="card-body">
                        <h5 class="card-title text-center">New Group</h5>
                        <form class="form-signin" action="/newgroup" method=post>

                            <div class="form-label-group">
                                <input id="name" name="name"class="form-control" placeholder="Group Name" autocomplete="off"
                                       required autofocus>
                            </div>

                            <div class="form-label-group">
                                <input id="subject" name="subject"class="form-control" placeholder="Course Department Abbreviation (example: BIOL)" autocomplete = "off"
                                       required autofocus>
                            </div>

                            <div class="form-label-group">
                                <input type="number" min="0" id="numberco" name="numberco"class="form-control" placeholder="Course Number (example: 10)" autocomplete = "off"
                                       required autofocus>
                            </div>


                            <!-- university as a hidden parameter-->

                            <%

                             Connection conn;

                                String url = System.getProperty("cloudsql");
                                        log("connecting to: " + url);
                                        try {
                                            conn = DriverManager.getConnection(url);
                                        } catch (SQLException e) {
                                            throw new ServletException("Unable to connect to Cloud SQL", e);
                                        }


                                String school = "";

                                String query = "SELECT * FROM open_project_db.users WHERE id = \"" + userid + "\"\n";

                                try(ResultSet rs = conn.prepareStatement(query).executeQuery()) {

                                if (rs.next()) {
                                    school = rs.getString("university");
                                }

                                } catch (SQLException e) {
                                   throw new ServletException("SQL error", e);

                                }

                            %>

                            <div class="form-label-group">
                                <input id="professor" name="professor" autocomplete = "off" class="form-control" placeholder="Professor (Last Name Only)"
                                       required>
                            </div>

                            <div class="form-label-group">
                                <input type="number" id="number" name="number" autocomplete="off" class="form-control" placeholder="Ideal Size (minimum 3, maximum 6)" min="3" max="6"
                                       required>
                            </div>

                            <input type="hidden" id="school" name="school" value="<%=school%>" >
                            <input type="hidden" id="userid" name="userid" value="<%=userid%>" >

                            <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit">Create My Group!</button>
                            <hr class="my-4">

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>

</html>