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

    <script>
    function sendMessage() {
      var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          document.getElementById("msgbox").innerHTML =
          this.responseText;
        }
      };
      xhttp.open("GET", "JoinGroupServlet.java", true);
      xhttp.send();
    }
    </script>

    <style>
    .footer {
      left: 1%;
      bottom: 0;
      width: 100%;
      color: white;
      align: center;
    }

  .speech-bubble-me {
      background: #efefef;
      -webkit-border-radius: 4px;
              border-radius: 4px;
      font-size: 1.2rem;
      font-weight:bold;
      line-height: 1.3;
      margin: 0 auto 40px;
      max-width: 400px;
      padding: 15px;
      position: relative;
      float:right;
  }

  .speech-bubble-me p {
      margin: 0 0 10px;
  }
  .speech-bubble-me p:last-of-type {
      margin-bottom: 0;
  }

  .speech-bubble-me::after {
      border-left: 20px solid transparent;
      border-top: 20px solid #efefef;
      bottom: -20px;
      content: "";
      position: absolute;
      right: 20px;
  }

  .speech-bubble-rec {
      background: #efefef;
      -webkit-border-radius: 4px;
              border-radius: 4px;
      font-size: 1.2rem;
      font-weight:bold;
      line-height: 1.3;
      margin: 0 auto 40px;
      max-width: 400px;
      padding: 15px;
      position: relative;
      float:left;
  }

  .speech-bubble-rec p {
      margin: 0 0 10px;
  }
  .speech-bubble-rec p:last-of-type {
      margin-bottom: 0;
  }

  .speech-bubble-rec::after {
      border-right: 20px solid transparent;
      border-top: 20px solid #efefef;
      bottom: -20px;
      content: "";
      position: absolute;
      left: 20px;
  }

    </style>
</head>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

<body onload="buildUI();">
    <!-- Navigation menu component -->
    <nav>
        <!-- Bootstrap nav menu template -->
        <ul class="nav justify-content-end" id="navigation">
            <li class="nav-item">
                <a class="nav-link active" href="#">Home</a>
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
                         <button type="button" onclick="sendMessage()" class="btn btn-primary" style="height:100px;width:200px"> Join Group </button>
                   </div>

               </form>

          <%
              }
              else { //the user already belongs to this
          %>

          <div class="w3-container">
            <h1 align = "center"> <%=groupformalname%></h1>
            <h3 align = "center"> <%=groupsize%> Members </h3>

            <div class="w3-panel" style = "width:27%;height:90%;float:left;">

               <button type="button" class="btn btn-primary" style="height:20%;width:100%;background-color:red;border:none;"> Leave Group </button>
               <br><br>
               <button type="button" class="btn btn-primary" style="height:20%;width:100%;"> Group Calendar </button>
               <br><br>
               <button type="button" class="btn btn-primary" style="height:20%;width:100%;"> Add a Resource </button>
               <h2 align = "center"> Resources </h2>

               <div class = "w3-panel" style = "width:100%;height:100%;float:left;overflow-y:scroll;overflow-x:hidden;">
                    <button type="button" class="btn btn-primary" style="height:40%;width:100%;"> Test1 </button>
                    <br><br>
                    <button type="button" class="btn btn-primary" style="height:40%;width:100%;"> Test 2 </button>
                    <br><br>

               </div>

            </div>
            <div class="w3-panel" style = "width:73%;float:left">
               <form action = "/sendmsg" method=post target="_self">

                    <div id = "msgbox" class = "w3-panel" style="height:69%;width:69%;overflow-y:scroll;overflow-x:hidden;position:fixed;display:flex;flex-direction:column-reverse;">
                       <div>
                        <%

                            //try to find all the messages for the group
                            String getmessages =  "SELECT * FROM open_project_db.messages WHERE group_id = \"" + groupid + "\"\n";

                            try(ResultSet resultset = conn.prepareStatement(getmessages).executeQuery()) {

                                while (resultset.next()) {

                                    String msg = resultset.getString("message");
                                    String sender = Integer.toString(resultset.getInt("user_id"));


                                    //if the user sent this message
                                    if (sender.equals(userid)) {

                                    %>

                                         <div class = "speech-bubble-me">
                                         <%=msg%>
                                         <br>
                                         <p align = "right" style="font-weight:lighter;"> Me </p>
                                         </div>
                                    <%
                                        int spaces = (int)(msg.length() / 15);
                                         if (spaces <= 4) {
                                              spaces = 5;
                                         }
                                        for (int i = 0; i < spaces + 2; i++) {
                                     %>
                                                <br>
                                     <%

                                        }

                                    }

                                    else {

                                        String sendername = "";

                                        String findsendername = "SELECT * FROM open_project_db.users WHERE id = \"" + sender + "\"\n";

                                        try(ResultSet xyz = conn.prepareStatement(findsendername).executeQuery()) {

                                             if (xyz.next()) {
                                                    sendername = xyz.getString("first_name") + " " + xyz.getString("last_name");
                                             }

                                         } catch (SQLException e) {
                                                 throw new ServletException("SQL error", e);

                                          }

                                    %>
                                         <div class = "speech-bubble-rec">
                                         <%=msg%>
                                         <br>
                                         <p align = "right" style="font-weight:lighter;"> <%=sendername%> </p>
                                         </div>
                                         <br>
                                     <%
                                     int spaces = (int)(msg.length() / 15);
                                     if (spaces <= 4) {
                                         spaces = 5;
                                     }
                                      for (int i = 0; i < spaces + 2; i++) {
                                     %>
                                      <br>
                                     <%

                                  }

                                }
                                }

                            } catch (SQLException e) {
                                 throw new ServletException("SQL error", e);

                            }

                        %>
                      </div>
                    </div>
                    <div class = "panel-footer" style="position:fixed;bottom:0;color:white;width:100%">
                        <input placeholder="Say something to your group" id="type" name="type" type="text" style="height:100%;width:55%;border:1px solid #F7730E;border-radius: 18px;padding-left:20px;">
                         &nbsp
                        <button type="submit" class="btn btn-primary" style="height:3%;width:10%;"> Send </button>
                    </div>

                     <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                     <input type="hidden" id="groupid" name="groupid" value="<%=groupid%>" >
                     <input type="hidden" id="group" name="group" value="<%=thegroup%>" >

                </form>
            </div>
          </div>

          <%

              }

           } catch (SQLException e) {
               throw new ServletException("SQL error", e);

           }


    %>






</body>
</html>