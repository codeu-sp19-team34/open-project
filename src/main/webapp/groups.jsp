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

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Study Group Finder</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
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
    <script src="/js/groups-page-loader.js"></script>
</head>
<body onload="buildUI();">

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

    <%
           String userid = request.getParameter("userid");
    %>

<div class="container">
    <div class="row">
        <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
            <div class="card card-signin my-5">
                <div class="card-body">
                    <h5 class="card-title text-center">Find a Group At Your School</h5>
                    <form class="form-signin" action="/findgroup" method=post target = "_self"> <!-- need to finish this-->

                        <div class="form-label-group">
                            <input id="subject" name="subject"class="form-control" placeholder="Department Abbreviation (example: BIOL)"
                                   required autofocus>
                        </div>

                        <div class="form-label-group">
                            <input id="number" name="number"class="form-control" placeholder="Course Number (example: 10)"
                                   required autofocus>
                        </div>

                        <div class="form-label-group">
                            <input id="professor" name="professor" class="form-control" placeholder="Professor's Last Name (example: Lowe)"
                                   required autofocus>
                        </div>

                        <input type="hidden" id="userid" name="userid" value="<%=userid%>" >

                        <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit">Find groups!</button>
                        <hr class="my-4">

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>