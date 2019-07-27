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
    <title> Home | StudyU: Study Group Finder</title>
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

    <% String userid = request.getParameter("userid"); %>
<!-- Navigation menu component -->
    <nav>
        <!-- Bootstrap nav menu template -->
        <ul class="nav justify-content-end" id="navigation">

            <li class="nav-item dropdown" style ="width:100px;" align="right">
                <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true"
                   aria-expanded="false">Groups</a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="/create-group.jsp?userid=<%=userid%>">Create a Group</a>
                    <a class="dropdown-item" href="/groups.jsp?userid=<%=userid%>">Find a Group</a>
                </div>
            </li>
            <li class="nav-item" style = "width:100px;" align= "right">
                <a class="nav-link active" href="/user_settings.jsp?userid=<%=userid%>">Settings</a>
            </li>
            <li class="nav-item" style="width:100px;" align = "right">
                <a class="nav-link active" href="/logout?userid=<%=userid%>">Logout</a>
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
            String username = "";
            try(ResultSet rs = conn.prepareStatement(findusername).executeQuery()) {
                if(rs.next()) {
                log("\n \n \n \n THE SELECT IS WORKING");
                username = rs.getString("first_name");
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

    %>
    <br><br>
    <h1 align="center" style="color:#eae672;"> Welcome, <%=username%>!</h1>

    <div class="form-container">
            <%
             String pending = "SELECT * FROM open_project_db.interest WHERE userid = " + userid;
             try(ResultSet rs = conn.prepareStatement(pending).executeQuery()) {

                if (rs.next()) {

                %>
                    <h2 class="primary-heading" style="color:white;margin-bottom: 0px !important" align="center"> Groups You're Waiting For </h2>
                    <div style="height: 2px; background-color: white; width: 15%; margin: 25px auto;"></div>

                <%

                }

                rs.beforeFirst();

                while(rs.next()) {

                %>
                <form align =center action = "/notinterested" method = "post" target="_self">
                    <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                    <input type="hidden" id="id" name="id" value="<%=rs.getString("id")%>" >
                    <p> <%=rs.getString("department")%> <%=rs.getInt("courseno")%> with Professor <%=Character.toUpperCase(rs.getString("professor").charAt(0))%><%=rs.getString("professor").substring(1)%>  </p>
                    <button class="btn btn-lg btn-primary btn-block text-uppercase" type = "submit" style="margin:auto;font-size:10px;height:1%;width:6%;background-color:red;"> remove </button>
                    <br>

                </form>
                <%

                }

             }
             catch (SQLException e) {
                throw new ServletException("SQL error", e);

             }

            %>



            <h2 class="primary-heading" style="color:white;margin-bottom: 0px !important" align="center"> Your Groups </h2>
            <div style="height: 2px; background-color: white; width: 15%; margin: 25px auto;"></div>
            <form align = center>
                <%

                 ArrayList<Integer> groupids = new ArrayList<>(); //first you need to find the groups that the user belongs to

                 String findbelongquery = "SELECT * FROM open_project_db.group_users WHERE user_id = " + userid;

                          try(ResultSet rs = conn.prepareStatement(findbelongquery).executeQuery()) {
                            while (rs.next()) {
                             Integer g = rs.getInt("group_id");
                             groupids.add(g);

                            }
                          } catch (SQLException e) {
                            throw new ServletException("SQL error", e);

                          }

                ArrayList<String> thegroups = new ArrayList<String>();
                ArrayList<String> groupcourses = new ArrayList<String>();


                          for (Integer x: groupids) {

                            String query = "SELECT * FROM open_project_db.groups WHERE id = " + x;

                            try (ResultSet rs = conn.prepareStatement(query).executeQuery()) {
                              while (rs.next()) {
                                Blob b = rs.getBlob("name");
                                byte[] bdata = b.getBytes(1, (int) b.length());
                                String name = new String(bdata, "UTF-8");

                                String clas = rs.getString("course");
                                thegroups.add(name);
                                groupcourses.add(clas);

                              }
                            } catch (SQLException e) {
                              throw new ServletException("SQL error", e);


                            }
                          }


                if (thegroups.size() == 0) {
             %>
                    <h1 class="primary-heading" style="color:red;margin-bottom: 0px !important" align="center"> Uh Oh! You are not in any groups yet! </h1>
                    <h2 align="center"> Click on GROUPS to find or create a group </h2>
             <%
                }

                else {

                    for (int i = 0; i < thegroups.size(); i++) {

                    String link = thegroups.get(i).replaceAll("\\s","");
                %>
                   <a href="/grouppage.jsp?group=<%=link%>&id=<%=groupids.get(i)%>&userid=<%=userid%>">
                   <button type="button" class="btn btn-primary" style="border-radius:10px;background-color:#0892d0;height:200px;width:60%;border:7px solid white;">
                        <h3> <%=thegroups.get(i)%> </h3>
                        <br>
                        <p> <%=groupcourses.get(i)%> </p>
                   </button> </a>

                   <br>
                   <br>
                <%
                    }

                 }



                %>
            </form>
        </div>



</body>

</html>