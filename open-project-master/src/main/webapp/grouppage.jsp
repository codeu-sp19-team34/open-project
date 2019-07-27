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
    <!--<meta http-equiv="refresh" content="5" >-->
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

                <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Comfortaa" />


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

    setInterval("my_function();",5000);
    function my_function(){
      $('#msgbox').load(location.href + " #innerd");
    }


    </script>

    <style>

    body {
         font-family: 'Comfortaa', cursive;
    }

    ::-webkit-scrollbar {
        width: 0px;
        background: transparent; /* make scrollbar transparent */
    }


    .footer {
      left: 1%;
      bottom: 0;
      width: 100%;
      color: white;
      align: center;
      font-family: 'Comfortaa', cursive;
    }

  .speech-bubble-me {
      background: #eae672;
      -webkit-border-radius: 4px;
              border-radius: 4px;
      font-size: 1.2rem;
      font-weight:bold;
      font-family: 'Comfortaa', cursive;
      line-height: 1.3;
      margin: 0 auto 40px;
      max-width: 400px;
      padding: 15px;
      position: relative;
      float:right;
  }

  .speech-bubble-me p {
  font-family: 'Comfortaa', cursive;
      margin: 0 0 10px;
      text-align:right;
  }
  .speech-bubble-me p:last-of-type {
  font-family: 'Comfortaa', cursive;
      margin-bottom: 0;
  }

  .speech-bubble-me::after {
  font-family: 'Comfortaa', cursive;
      border-left: 20px solid transparent;
      border-top: 20px solid #eae672;
      bottom: -20px;
      content: "";
      position: absolute;
      right: 20px;
  }

  .speech-bubble-rec {
  font-family: 'Comfortaa', cursive;
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
  font-family: 'Comfortaa', cursive;
      margin: 0 0 10px;
      text-align:left;
  }
  .speech-bubble-rec p:last-of-type {
  font-family: 'Comfortaa', cursive;
      margin-bottom: 0;
  }

  .speech-bubble-rec::after {
  font-family: 'Comfortaa', cursive;
      border-right: 20px solid transparent;
      border-top: 20px solid #efefef;
      bottom: -20px;
      content: "";
      position: absolute;
      left: 20px;
  }

  .modal {
  font-family: 'Comfortaa', cursive;
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
  font-family: 'Comfortaa', cursive;
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


     @media screen and (max-width: 728px) {

     h2 {
        font-size:20px;
     }

   .speech-bubble-me {
       background: #eae672;;
       -webkit-border-radius: 4px;
               border-radius: 4px;
       font-size: 0.9rem;
       font-weight:bold;
       line-height: 1.3;
       margin: 0 auto 40px;
       max-width: 400px;
       padding: 15px;
       position: relative;
       float:right;
       font-family: 'Comfortaa', cursive;
   }


   .speech-bubble-rec {
       background: #efefef;
       -webkit-border-radius: 4px;
               border-radius: 4px;
       font-size: 0.9rem;
       font-weight:bold;
       line-height: 1.3;
       margin: 0 auto 40px;
       max-width: 400px;
       padding: 15px;
       position: relative;
       float:left;
       font-family: 'Comfortaa', cursive;
   }

     }

    </style>
</head>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

<%
    Connection conn;

            String url = System.getProperty("cloudsql");
                    try {
                        conn = DriverManager.getConnection(url);
                    } catch (SQLException e) {
                        throw new ServletException("Unable to connect to Cloud SQL", e);
                    }
    String userid = request.getParameter("userid");
    String groupid = request.getParameter("id");
    String thegroup = request.getParameter("group");
    String loggedin = "SELECT * FROM open_project_db.users WHERE id = \"" + userid + "\"\n";

     try (ResultSet rs = conn.prepareStatement(loggedin).executeQuery()){
        if(rs.next()) {
          if (rs.getString("loggedin").equals("0")) {
           %>
                 <jsp:forward page="/oops"/>
           <%
           }
         }

       } catch (SQLException e) {
              throw new ServletException("SQL error", e);
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

                       //trying
                       request.setAttribute("groupid", groupid);
                       request.setAttribute("thegroup", thegroup);

                       String query = "SELECT * FROM open_project_db.groups WHERE id = \"" + groupid + "\"\n";
                       String groupformalname = "";
                       String groupcourse = "";
                       int groupsize = 0;
                       int groupmaxsize = 0;
                       String groupprofessor = "";
                       String groupschool = "";
                       //String userid = request.getParameter("userid");
                       int grstyle = 0;

                       request.setAttribute("userid", userid);

                       try(ResultSet rs = conn.prepareStatement(query).executeQuery()) {

                           while (rs.next()) {

                               Blob gblob = rs.getBlob("name");
                               byte[] gdata = gblob.getBytes(1, (int) gblob.length());
                               groupformalname = new String(gdata, "UTF-8");

                               groupcourse = rs.getString("course");
                               groupsize = rs.getInt("size");
                               groupmaxsize = rs.getInt("max_size");
                               groupprofessor = rs.getString("professor");
                               groupschool = rs.getString("school");
                               grstyle = rs.getInt("style");

                           }

                       } catch (SQLException e) {
                           throw new ServletException("SQL error", e);

                       }




 %>

<body onload="buildUI();" style="background-color:#056691;font-family: 'Comfortaa', cursive;">
    <!-- Navigation menu component -->
    <nav>
        <!-- Bootstrap nav menu template -->
        <ul class="nav justify-content-end" id="navigation">
            <li class="nav-item dropdown">
               <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="" role="button" aria-haspopup="true"
               aria-expanded="false">Menu</a>
               <div class="dropdown-menu">
                   <a class = "dropdown-item" href = "/group_resources.jsp?group=<%=thegroup%>&id=<%=groupid%>&userid=<%=userid%>"> Resources </a>
                   <%
                   if (userid.equals(adminnumber)) {
                   %>
                        <a class = "dropdown-item" href = "/admin_settings.jsp?group=<%=thegroup%>&id=<%=groupid%>&userid=<%=userid%>"> Admin Settings </a>
                   <%
                    }
                   %>

                   <%
                   if (grstyle == 1) {
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

    <%

            //checking to see if the user already belongs to the group
         String ingroupalready = "SELECT * FROM open_project_db.group_users WHERE group_id = \"" + groupid + "\" AND user_id = \"" + userid + "\"\n";

         try(ResultSet rs = conn.prepareStatement(ingroupalready).executeQuery()) {

              if (!rs.next()) { //locked, the user needs to request access

          %>
               <h1 align = "center" style="color:#eae672;font-family: 'Comfortaa', cursive;"> <%=groupformalname%></h1>
               <h3 align = "center" style="color:#eae672;font-family: 'Comfortaa', cursive;"> <%=groupsize%> Members </h3>

               <br><br><br><br>

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

          <div id ="blah" class="w3-container">
             <a href = "/group_settings.jsp?thegroup=<%=thegroup%>&userid=<%=userid%>&groupid=<%=groupid%>" style = "font-family: 'Comfortaa', cursive;font-size:40px;text-align:center;color:#eae672"><h1 id = "forml" style ="font-family: 'Comfortaa', cursive;"> <%=groupformalname%></h1></a>


            <div align = "center">
                <h3 id = "myBtn" align = "center" style="font-family: 'Comfortaa', cursive;font-size:16px;color:#eae672;"> <%=groupsize%> Members </h3>
            </div>

                        <div class="w3-panel" style = "width:100%;height:30%;float:left;order:1;">

                            <!-- The Modal -->
                            <div id="myModal" class="modal">

                              <!-- Modal content -->
                              <div class="modal-content">
                                <span class="close">&times;</span>

                                <h1 align = "center" style="text-style:bold;"> Group Members </h1>

                                <div style="padding-left:40px;">
                                    <div style="overflow-y:scroll;">

                                        <%

                                                //first find their id numbers, then you can find their name
                                                ArrayList<Integer> membernumbers = new ArrayList<Integer>();

                                                String findmemberids = "SELECT * FROM open_project_db.group_users WHERE group_id = \"" + groupid + "\"\n";

                                                try (ResultSet findingnumbers = conn.prepareStatement(findmemberids).executeQuery()){

                                                        while(findingnumbers.next()) {
                                                            membernumbers.add(findingnumbers.getInt("user_id"));
                                                        }

                                                } catch (SQLException e) {
                                                    throw new ServletException("SQL error", e);
                                                }

                                                for (Integer i: membernumbers) {

                                                    String findmembersname = "SELECT * FROM open_project_db.users WHERE id = \"" + Integer.toString(i) + "\"\n";
                                                    try (ResultSet findingthename = conn.prepareStatement(findmembersname).executeQuery()){

                                                            if(findingthename.next()) {

                                                            %>
                                                                <h3 align = "left"> <%=findingthename.getString("first_name")%> <%=findingthename.getString("last_name")%> </h3>
                                                                <br>

                                                            <%
                                                            }

                                                    }
                                                    catch (SQLException e) {
                                                        throw new ServletException("SQL error", e);
                                                    }




                                                }



                                        %>

                                  </div>

                             </div>



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


            <div class="w3-panel" style = "width:50%;height:80%;padding-left:0px;">
               <form action = "/sendmsg" method=post target="_self">

                    <div id = "msgbox" class = "w3-panel" style="text-align:center;height:60%;width:90%;overflow-y:scroll;overflow-x:hidden;position:fixed;display:flex;flex-direction:column-reverse;">

                       <div id = "innerd">
                       <div>
                        <%

                            //try to find all the messages for the group
                            String getmessages =  "SELECT * FROM open_project_db.messages WHERE group_id = \"" + groupid + "\"\n";

                            try(ResultSet resultset = conn.prepareStatement(getmessages).executeQuery()) {

                                while (resultset.next()) {

                                    Blob blob = resultset.getBlob("message");
                                    byte[] bdata = blob.getBytes(1, (int) blob.length());

                                    String msg = new String(bdata, "UTF-8");
                                    String sender = Integer.toString(resultset.getInt("user_id"));


                                    //if the user sent this message
                                    if (sender.equals(userid)) {

                                    %>

                                         <div class = "speech-bubble-me" style="text-align:right;">
                                         <%=msg%>
                                         <br>
                                         <p align = "right" style="font-weight:lighter;"> Me </p>
                                         </div>
                                    <%
                                        int spaces = (int)(msg.length() / 9);
                                         if (spaces <= 4) {
                                              spaces = 4;
                                         }
                                        for (int i = 0; i < spaces+2; i++) {
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
                                         <div class = "speech-bubble-rec" style="text-align:left;">
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
                    </div>
                    <div style = "text-align:left;">
                        <div class = "panel-footer" align = "left" style="position:fixed;bottom:0;width:100%;">
                            <input placeholder="Say something to your group" id="type" name="type" type="text" autocomplete="off" style="height:50px;width:75%;border:1px solid #F7730E;border-radius: 5px;padding-left:20px;float:left;">

                            <button type="submit" class="btn btn-primary" style="height:50px;width:15%;background-color:#0892d0"> Send </button>
                        </div>
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