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
<%@page import="java.util.TreeMap"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Study Group Finder</title>
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
    <!-- Navigation menu component -->
    <nav>
        <!-- Bootstrap nav menu template -->
        <ul class="nav justify-content-end" id="navigation">
            <!-- <li class="nav-item">
                            <a class="nav-link active" href="/welcome.jsp">Home</a>
                        </li>-->
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true"
                   aria-expanded="false">Groups</a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="/create-group.html">Create a Group</a>
                    <a class="dropdown-item" href="/groups.html">Find a Group</a>
                </div>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/index.html">Logout</a>
            </li>

        </ul>
    </nav>
    <!-- End of navigation menu component -->

    <div class="form-container">
            <h2 class="primary-heading" style="margin-bottom: 0px !important" align="center"> Your Groups </h2>
            <div style="height: 2px; background-color: white; width: 15%; margin: 25px auto;"></div>

            <form align = center>
                <%

                String userid = (String)request.getAttribute("usersid");

                TreeMap<String, Integer> results = (TreeMap<String, Integer>) request.getAttribute("findresults");

                if (results.size() == 0) {
                %>
                    <h1 class="primary-heading" style="margin-bottom: 0px !important" align="center"> Sorry, we could not find any groups that match. </h1>
                <%
                }

                else {

                   for (String key: results.keySet()) {

                     String id = Integer.toString(results.get(key));

                     String link = key.replaceAll("\\s","");

                %>
                    <a href="/grouppage.jsp?group=<%=link%>&id=<%=id%>&userid=<%=userid%>"> <button type="button" class="btn btn-primary" style="height:200px;width:200px"> <%=key%> <br> </button> </a>
                    &nbsp
                <%
                    }

                 }

                %>

        </div>



</body>

</html>