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
    <title> Admin Settings | StudyU: Study Group Finder</title>
    <link rel="stylesheet" href="/css/main.css">

    <!-- jQuery CDN Link -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!-- Bootstrap 4 Link -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <!-- Font Awesome Icons link -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css">

    <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Comfortaa" />

    <style>

        body {
            font-family: 'Comfortaa', cursive;
        }
    </style>

    <script src="/js/navigation-loader.js"></script>

</head>


<body onload="addLoginOrLogoutLinkToNavigation();" style="background-color:#056691">

    <% String userid = request.getParameter("userid");
       String groupid = request.getParameter("id");
       String thegroup = request.getParameter("group");

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

    <%

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
            String gdept ="";
            String gno="";

            try(ResultSet finding = conn.prepareStatement(findthegroup).executeQuery()) {
                while (finding.next()) {

                    Blob b = finding.getBlob("name");
                    byte[] bdata = b.getBytes(1, (int) b.length());

                    gname = new String(bdata, "UTF-8");

                    gcourse = finding.getString("course");

                    gdept = gcourse.split("\\s+")[0];
                    gno = gcourse.split("\\s+")[1];

                    gsize = finding.getInt("size");
                    gmax = finding.getInt("max_size");
                    gprofessor = finding.getString("professor");
                    gschool = finding.getString("school");
                    gstyle = finding.getInt("style");

                    Blob blah = finding.getBlob("description");
                    byte[] ddata = blah.getBytes(1, (int) blah.length());
                    gdescription = new String(ddata, "UTF-8");

                }
             } catch (SQLException e) {
               throw new ServletException("SQL error", e);

            }

    %>
    <br>
    <h1 align="center" style="color:#eae672;"> Group Admin Settings </h1>
    <br><br>

    <div class="form-container" align="center" style="height:50%;">

            <div align ="center" style="width:60%;height:60%;">

                <%
                    if (gsize < gmax) {

                        String findpending = "SELECT * FROM open_project_db.interest WHERE department = \"" + gdept + "\" AND courseno = " + gno +" AND professor = \"" + gprofessor + "\";";
                        try (ResultSet rs = conn.prepareStatement(findpending).executeQuery()){

                            if (rs.next() ) {

                            %>

                                <h3 align="center" style="color:#eae672;"> Add members to your group </h3>
                                <br>

                             <%

                             rs.beforeFirst();

                                while(rs.next()) {

                                    String findtheuser = "SELECT * FROM open_project_db.users WHERE id = " + rs.getString("userid") + ";";

                                    try (ResultSet rs1 = conn.prepareStatement(findtheuser).executeQuery()){

                                        while (rs1.next()){

                                            %>
                                            <form action = "${pageContext.request.contextPath}/acceptnewperson" method= "post" target= "_self">
                                                <button class="btn btn-lg btn-primary btn-block text-uppercase" type = "submit" style="float:left;font-size:12px;height:1%;width:10%;background-color:green;"> accept </button>

                                                <input type="hidden" id="group" name="group" value="<%=thegroup%>" >
                                                <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                                                <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                                                <input type="hidden" id="addid" name = "addid" value = "<%=rs1.getString("id")%>">
                                                <input type="hidden" id="size" name="size" value="<%=gsize%>">
                                                <input type="hidden" id="dept" name="dept" value="<%=gdept%>">
                                                <input type="hidden" id="no" name="no" value="<%=gno%>">
                                                <!--<button class="btn btn-lg btn-primary btn-block text-uppercase" style="float:left;text-align:center;font-size:12px;height:1%;width:8%;background-color:red;"> reject </button>-->

                                                <p style = "font-size:20px;text-align:left;color:white;"> &nbsp <%=rs1.getString("first_name")%> <%=rs1.getString("last_name")%></p>
                                            </form>

                                                <br>

                                            <%
                                          }

                                    } catch (SQLException e) {
                                         throw new ServletException("SQL error", e);
                                    }
                                }

                            }

                        } catch (SQLException e) {
                            throw new ServletException("SQL error", e);
                        }

                    }
                %>


                <h3 align="center" style="color:#eae672;"> Change Group Name </h3> <br>
                <form action = "/byemember" method = "post" target="_self">
                     <input type="hidden" id="choice" name="choice" value="1" >
                     <input type="hidden" id="group" name="group" value="<%=thegroup%>" >
                     <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                     <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                     <input id="xname" name="xname" autocomplete = "off" class="form-control" placeholder="<%=gname%>">
                     &nbsp
                     <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                     <hr class="my-4">
                </form>

                <h3 align="center" style="color:#eae672;"> Remove Members </h3> <br> <br>
                <div>
                      <%
                           String dm = "SELECT * FROM open_project_db.group_users WHERE group_id = " + groupid;
                            try(ResultSet ok = conn.prepareStatement(dm).executeQuery()) {
                                 while (ok.next()) {

                                    String a = "SELECT * FROM open_project_db.users WHERE id =" + ok.getInt("user_id");

                                    try(ResultSet ok2 = conn.prepareStatement(a).executeQuery()) {
                                        if (ok2.next()) {
                                        %>
                                        <form id = "removeperson" action = "/byemember" method = "post" target="_self">
                                            <input type="hidden" id="choice" name="choice" value="2">
                                            <input type="hidden" id="group" name="group" value="<%=thegroup%>" >
                                            <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                                            <input type="hidden" id="memberid" name="memberid" value="<%=ok2.getInt("id")%>" >
                                            <input type="hidden" id="userid" name="userid" value="<%=userid%>" >

                                            <%
                                                if (Integer.toString(ok2.getInt("id")).equals(userid)) {
                                            %>

                                            <button class="btn btn-lg btn-primary btn-block text-uppercase" style="float:left;font-size:12px;height:1%;width:10%;" type ="submit" disabled> REMOVE </button>
                                            <p style="font-size:20px;text-align:left;color:white;"> &nbsp <%=ok2.getString("first_name").toUpperCase()%> <%=ok2.getString("last_name").toUpperCase()%> </p>
                                            <%
                                                }
                                                else {
                                            %>

                                            <button class="btn btn-lg btn-primary btn-block text-uppercase" style="float:left;font-size:12px;height:1%;width:10%;" type ="submit"> REMOVE </button>
                                            <p style="font-size:20px;text-align:left;color:white;"> &nbsp <%=ok2.getString("first_name").toUpperCase()%> <%=ok2.getString("last_name").toUpperCase()%> </p>

                                            <%
                                                }
                                            %>
                                            <br>
                                        </form>
                                        <%

                                        }
                                    }
                                    catch (SQLException e) {
                                        throw new ServletException("SQL error", e);
                                    }

                                 }
                              } catch (SQLException e) {
                                throw new ServletException("SQL error", e);

                             }



                      %>
                      <hr class="my-4">
                </div>

                <h3 align="center" style="color:#eae672;"> Change Group Style </h3>
                <br>
                <form action = "/byemember" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="3" >
                      <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input type="hidden" id="group" name="group" value="<%=thegroup%>" >

                      <%

                        if (gstyle == 0) {


                      %>

                      <input type="radio" id="style" name="style" value="0" checked required> <label for="style" style="color:white;">Virtual Group (Work together only online)</label> </br>
                      <input type="radio" id="style" name="style" value="1" required> <label for="style" style="color:white;">Hybrid Group (Work together online and in-person)</label> </br>


                      <%
                        }

                        else {


                      %>
                        <input type="radio" id="style" name="style" value="0" required> <label for="style" style="color:white;">Virtual Group (Work together only online)</label>  </br>
                        <input type="radio" id="style" name="style" value="1" checked required> <label for="style" style="color:white;">Hybrid Group (Work together online and in-person)</label> </br>

                      <%
                      }

                      %>


                        <br>

                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>



                <br>
                <br>

                <form action = "/updateginfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="5" >
                      <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" style="background-color:red;" type="submit"> Delete Group </button>
                      <hr class="my-4">
                </form>


            </div>
     </div>



</body>

</html>