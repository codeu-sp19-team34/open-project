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
    <title> Group Page | StudyU: Study Group Finder </title>
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

    <style>

  .modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    padding-top: 100px; /* Location of the box */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
  }

  /* Modal Content */
  .modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
  }

  /* The Close Button */
  .close {
    color: #aaaaaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
  }

  .close:hover,
  .close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
  }

  <!-- post it notes - -->
  <!-- got this code and modified it from http://creative-punch.net/2014/02/create-css3-post-it-note/ -->

  .quote-container {
    margin-top: 50px;
    position: relative;
  }

  .note {
    color: #333;
    position: relative;
    width: 300px;
    height: 300px;
    margin: 0 auto;
    padding: 90px;
    font-size: 30px;
    text-align:center;
    box-shadow: 0 10px 10px 2px rgba(0,0,0,0.3);
  }

  .yellow {
    background: #eae672;
    -webkit-transform: rotate(2deg);
    -moz-transform: rotate(2deg);
    -o-transform: rotate(2deg);
    -ms-transform: rotate(2deg);
    transform: rotate(2deg);
  }


    </style>
</head>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

<%

    String userid = request.getParameter("userid");
    String groupformalname = "";
    String groupid = request.getParameter("id");
    String thegroup = request.getParameter("group");
    int groupsize = 0;

    Connection conn;

    String url = System.getProperty("cloudsql");
                    try {
                        conn = DriverManager.getConnection(url);
                    } catch (SQLException e) {
                        throw new ServletException("Unable to connect to Cloud SQL", e);
                    }
                    String query = "SELECT * FROM open_project_db.groups WHERE id = \"" + groupid + "\"\n";

                    try(ResultSet rs = conn.prepareStatement(query).executeQuery()) {

                        if (rs.next()) {
                            groupformalname = rs.getString("name");
                            groupsize = rs.getInt("size");
                        }

                    } catch (SQLException e) {
                        throw new ServletException("SQL error", e);

                    }

%>

<body onload="buildUI();">
    <!-- Navigation menu component -->
    <nav>
        <!-- Bootstrap nav menu template -->
        <ul class="nav justify-content-end" id="navigation">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="" role="button" aria-haspopup="true"
                aria-expanded="false">Groups</a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="/create-group.jsp?userid=<%=userid%>">Create a Group</a>
                    <a class="dropdown-item" href="/groups.jsp?userid=<%=userid%>">Find a Group</a>
                </div>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/welcome.jsp?userid=<%=userid%>">Home</a>
            </li>

        </ul>
    </nav>
    <!-- End of navigation menu component -->




          <!--<div class="w3-container">-->
            <h1 align = "center"> <%=groupformalname%></h1>
            <h3 align = "center"> <%=groupsize%> Members </h3>

             <h2 align = "center"> Resources </h2>
             <div align = "center">
                <button id = "myBtn" class="btn btn-primary" style="height:100%;width:200px;background-color:red;border:none;"> Add New Resource </button>
             </div>

            <div class="w3-panel" style = "width:100%;height:30%;float:left;order:1;">

                <!-- The Modal -->
                <div id="myModal" class="modal">

                  <!-- Modal content -->
                  <div class="modal-content">
                    <span class="close">&times;</span>

                    <h1 align = "center"> Add New Resource </h1>

                     <form class="form-signin" action="/createresource" method=post target = "_self"> <!-- need to finish this-->

                        <div class="form-label-group">
                           <input id="resname" name="resname"class="form-control" placeholder="Name of resource" required autofocus>
                        </div>

                        <div class="form-label-group">
                            <input id="reslink" name="reslink"class="form-control" placeholder="Link to resource" type="url"required autofocus>
                        </div>

                        <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                        <input type="hidden" id="id" name="id" value="<%=groupid%>" >
                        <input type="hidden" id="group" name="group" value="<%=thegroup%>" >

                        <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Create Resource </button>
                             <hr class="my-4">

                     </form>

                  </div>

                </div>

                <script>
                // Get the modal
                var modal = document.getElementById("myModal");

                // Get the button that opens the modal
                var btn = document.getElementById("myBtn");

                // Get the <span> element that closes the modal
                var span = document.getElementsByClassName("close")[0];

                // When the user clicks the button, open the modal
                btn.onclick = function() {
                  modal.style.display = "block";
                }

                // When the user clicks on <span> (x), close the modal
                span.onclick = function() {
                  modal.style.display = "none";
                }

                // When the user clicks anywhere outside of the modal, close it
                window.onclick = function(event) {
                  if (event.target == modal) {
                    modal.style.display = "none";
                  }
                }
                </script>

               <!--<div class = "w3-panel" style = "width:80%;height:100%;float:left;overflow-y:scroll;overflow-x:hidden">-->

                   <%

                   String fetchresources = "SELECT * FROM open_project_db.resources WHERE groupid = \"" + groupid + "\"\n";

                   try(ResultSet fetching = conn.prepareStatement(fetchresources).executeQuery()) {

                    while (fetching.next()) {

                        String resurl = fetching.getString("url");
                        String resname = fetching.getString("name");

                    %>
                        <a href = "<%=resurl%>" target = "_blank">
                        <blockquote class="note yellow"> <%=resname%>  </blockquote>
                        </a>
                        <br><br>
                    <%

                    }

                    } catch (SQLException e) {
                         throw new ServletException("SQL error", e);

                     }

                   %>

               <!--</div>-->

           </div>


</body>
</html>