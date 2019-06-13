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
            String firstname = "";
            String lastname = "";
            String email = "";
            String phone = "";
            String uni = "";

            try(ResultSet rs = conn.prepareStatement(findusername).executeQuery()) {
                while (rs.next()) {
                //check to see if the user is actually logged in
                //if theyre not, then take them to the login page
               if (rs.getString("loggedin").equals("0")) {
                %>
                    <jsp:forward page="/oops"/>
                <%
               }


                firstname = rs.getString("first_name");
                lastname = rs.getString("last_name");
                uni = rs.getString("university");
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

                <h3 align="center"> Change University </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="3" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >

                      <select list = "Universities" id="xuni" name="xuni" autocomplete = "off" class="form-control" type="text" tabindex="4" style = "width:100%;height:35px;border-radius:1rem;padding-left:10px;color:#888888;font-size:12px" required>
                                     <datalist id="Universities">
                                                  <option value="" disabled selected hidden><%=uni%> </option>
                                                  <option value="A. T. Still University"> A. T. Still University </option>
                                                  <option value="Abilene Christian University"> Abilene Christian University </option>
                                                  <option value="Abraham Baldwin Agricultural College"> Abraham Baldwin Agricultural College </option>
                                                  <option value="Academy of Art University"> Academy of Art University </option>
                                                  <option value="Adams State University"> Adams State University </option>

                                                  <option value="Adelphi University"> Adelphi University </option>
                                                  <option value="Adler Graduate School"> Adler Graduate School </option>
                                                  <option value="Adler University"> Adler University </option>
                                                  <option value="Adrian College"> Adrian College </option>
                                                  <option value="Adventist University of Health Sciences"> Adventist University of Health Sciences </option>

                                                  <option value="Agnes Scott College"> Agnes Scott College </option>
                                                  <option value="Air Force Institute of Technology"> Air Force Institute of Technology </option>
                                                  <option value="Alabama A&M University"> Alabama A&M University </option>
                                                  <option value="Alabama State University"> Alabama State University </option>
                                                  <option value="Alaska Bible College"> Alaska Bible College </option>

                                                  <option value="Alaska Pacific University"> Alaska Pacific University </option>
                                                  <option value="Albany College of Pharmacy and Health Sciences"> Albany College of Pharmacy and Health Sciences </option>
                                                  <option value="Albany Medical College"> Albany Medical College </option>
                                                  <option value="Albany State University"> Albany State University </option>
                                                  <option value="Albertus Magnus College"> Albertus Magnus College </option>

                                                  <option value="Alboin College"> Alboin College </option>
                                                  <option value="Albright College"> Albright College </option>
                                                  <option value="Alcorn State University"> Alcorn State University </option>
                                                  <option value="Alderson Broaddus University"> Aldersin Broaddus University </option>
                                                  <option value="Alfred State College"> Alfred State College </option>

                                                  <option value="Alfred University"> Alfred University </option>
                                                  <option value="Alice Lloyd College"> Alice Lloyd College </option>
                                                  <option value="Allegheny College"> Allegheny College </option>
                                                  <option value="Allen College"> Allen College </option>
                                                  <option value="Allen University"> Allen University </option>

                                                  <option value="Alliant International University"> Alliant International University </option>
                                                  <option value="Alma College"> Alma College </option>
                                                  <option value="Alvernia University"> Alvernia University </option>
                                                  <option value="Alverno College"> Alverno College </option>
                                                  <option value="Amberton University"> Amberton University </option>

                                                  <option value="American Baptist College"> American Baptist College </option>
                                                  <option value="American Film Institute Conservatory"> American Film Institute Conservatory </option>
                                                  <option value="American International College">American International College </option>
                                                  <option value="American Jewish University"> American Jewish University </option>
                                                  <option value="American University"> American University </option>

                                                  <option value="Amherst College"> Amherst College </option>
                                                  <option value="Anderson University"> Anderson University </option>
                                                  <option value="Andrews University"> Andrews University </option>
                                                  <option value="Angelo State University"> Angelo State University </option>

                                                  <option value="Anna Maria College"> Anna Maria College </option>
                                                  <option value="Antioch University"> Antoich University </option>
                                                  <option value="Antioch University of Los Angeles"> Antioch University of Los Angeles </option>
                                                  <option value="Antioch University of New England"> Antioch University of New England </option>
                                                  <option value="Antioch University of Santa Barbara"> Antioch University of Santa Barbara </option>

                                                  <option value="Antioch University Seattle"> Antioch University Seattle </option>
                                                  <option value="Appalachian Bible College"> Appalachian Bible College </option>
                                                  <option value="Appalachian College of Pharmacy"> Appalachian College of Pharmacy </option>
                                                  <option value="Appalachian State University"> Appalachian State University </option>
                                                  <option value="Aquinas College"> Aquinas College </option>

                                                  <option value="Aquinas College, Tennessee"> Aquinas College, Tennessee </option>
                                                  <option value="Arcadia University"> Arcadia University </option>
                                                  <option value="Argosy University"> Argosy University </option>
                                                  <option value="Arizona Christian University"> Arizona Christian University </option>
                                                  <option value="Arizona State University"> Arizona State University </option>

                                                  <option value="Arkansas Baptist College"> Arkansas Baptist College </option>
                                                  <option value="Arkansas State University"> Arkansas State University </option>
                                                  <option value="Arkansas Tech University"> Arkansas Tech University </option>
                                                  <option value="Arlington Baptist University"> Arlington Baptist University </option>
                                                  <option value="Armstrong State University"> Armstrong State University </option>

                                                  <option value="Art Academy of Cincinnati"> Art Academy of Cincinnati </option>
                                                  <option value="ArtCenter College of Design"> ArtCenter College of Design </option>
                                                  <option value="Asbury University"> Asbury University </option>
                                                  <option value="Ashland University"> Ashland University </option>
                                                  <option value="Assumption College"> Assumption College </option>

                                                  <option value="Athens State University"> Athens State University </option>
                                                  <option value="Atlanta Metropolitan State College"> Atlanta Metropolitan State College </option>
                                                  <option value="Auburn University"> Auburn University </option>
                                                  <option value="Auburn University at Montgomery"> Auburn University at Montgomery </option>
                                                  <option value="Augsburg College"> Augsburg College </option>

                                                  <option value="Augusta University"> Augusta University </option>
                                                  <option value="Augustana College"> Augustana College </option>
                                                  <option value="Augustana University"> Augustana University </option>
                                                  <option value="Aurora University"> Aurora University </option>
                                                  <option value="Austin College"> Austin College </option>

                                                  <option value="Austin Peay State University"> Austin Peay State University </option>
                                                  <option value="Ave Maria University"> Ave Maria University </option>
                                                  <option value="Averett University"> Averett University </option>
                                                  <option value="Avila University"> Avila University </option>
                                                  <option value="Azusa Pacific University"> Auza Pacific University </option>

                                                  <option value="Babson College"> Babson College </option>
                                                  <option value="Bacone College"> Bacone College </option>
                                                  <option value="Baker College"> Baker College </option>
                                                  <option value="Baker University"> Baker University </option>
                                                  <option value="Baldwin Wallace University"> Baldwin Wallace University </option>

                                                  <option value="Ball State University"> Ball State University </option>
                                                  <option value="Bank Street College of Education"> Bank Street College of Education </option>
                                                  <option value="Baptist Bible College"> Baptist Bible College </option>
                                                  <option value="Baptist Memorial College of Health Sciences"> Baptist Memorial College of Health Sciences </option>
                                                  <option value="Baptist University of the Americas"> Baptist University of the Americas </option>

                                                  <option value="Barclay College"> Barclay College </option>
                                                  <option value="Bard College"> Bard College </option>
                                                  <option value="Bard College at Simon's Rock"> Bard College at Simon's Rock </option>
                                                  <option value="Barnard College"> Barnard College </option>
                                                  <option value="Barnes-Jewish College Goldfarb School of Nursing"> Barnes-Jewish College Goldfarb School of Nursing </option>

                                                  <option value="Barry University"> Barry University </option>
                                                  <option value="Barton College"> Barton College </option>
                                                  <option value="Bastyr University"> Bastyr University </option>
                                                  <option value="Bates College"> Bates College </option>
                                                  <option value="Bay Path University"> Bay Path University </option>

                                                  <option value="Bay State College"> Bay State College </option>
                                                  <option value="Baylor College of Medicine"> Baylor College of Medicine </option>
                                                  <option value="Baylor University"> Baylor University </option>
                                                  <option value="Beacon College"> Beacon College </option>
                                                  <option value="Becker College"> Becker College </option>

                                                  <option value="Belhaven University"> Belhaven University </option>
                                                  <option value="Bellarmine University"> Ballarmine University </option>
                                                  <option value="Bellevue College"> Bellvue College </option>
                                                  <option value="Bellevue University"> Bellvue University </option>
                                                  <option value="Bellin College"> Bellin College </option>

                                                  <option value="Belmont Abbey College"> Belmont Abbey College </option>
                                                  <option value="Belmont University"> Belmont University </option>
                                                  <option value="Beloit College"> Beloit College </option>
                                                  <option value="Bemidji State University"> Bemidji State University </option>
                                                  <option value="Benedict College"> Benedict College </option>

                                                  <option value="Benedictine College"> Benedictine College </option>
                                                  <option value="Benjamin Franklin Institute of Technology"> Benjamin Franklin Institute of Technology </option>
                                                  <option value="Bennett College"> Bennett College </option>
                                                  <option value="Bennington College"> Bennington College </option>
                                                  <option value="Bently University"> Bently University </option>

                                                  <option value="Berea College"> Berea College </option>
                                                  <option value="Berkeley College"> Berkeley College </option>
                                                  <option value="Barklee College of Music"> Barklee College of Music </option>
                                                  <option value="Bernard M Baruch College"> Bernard M Baruch College </option>
                                                  <option value="Berry College"> Berry College </option>

                                                  <option value="Bethany College"> Bethany College </option>
                                                  <option value="Bethany Lutheran College"> Bethany Lutheran College </option>
                                                  <option value="Bethel College"> Bethel College </option>

                                                  <option value="Bethel University"> Bethel University </option>
                                                  <option value="Bethesda University"> Bethesda University </option>
                                                  <option value="Bethune-Cookman University"> Bethune-Cookman University </option>
                                                  <option value="Beulah Heights University"> Beulah Heights University </option>

                                                  <option value="Binghamton University of New York"> Binghamton University of New York </option>
                                                  <option value="Biola University"> Biola University </option>
                                                  <option value="Birmingham-Southern College"> Birmingham-Southern College </option>
                                                  <option value="Bismarck State College"> Bismark State College </option>
                                                  <option value="Black Hills State University"> Black HIlls State University </option>

                                                  <option value="Blackburn College"> Blackburn College </option>
                                                  <option value="Blessing-Rieman College of Nursing"> Blessing-Rieman College of Nursing </option>
                                                  <option value="Bloomfield College"> Bloomfield College </option>
                                                  <option value="Bloomsburg University of Pennsylvania"> Bloomsburg University of Pennsylvania </option>
                                                  <option value="Blue Mountain College"> Blue Mountain College </option>

                                                  <option value="Bluefield College"> Bluefield College </option>
                                                  <option value="Bluefield State College"> Bluefield State College </option>
                                                  <option value="Bluffton University"> Buffton University </option>
                                                  <option value="Bob Jones University"> Bob Jones University </option>
                                                  <option value="Boise Bible College"> Boise Bible College </option>

                                                  <option value="Boise State University"> Boise State University </option>
                                                  <option value="Boricua College"> Boricua College </option>
                                                  <option value="Boston Architectural College"> Boston Architectural College </option>
                                                  <option value="Boston College"> Boston College </option>
                                                  <option value="Boston Graduate School of Psychoanalysis"> Boston Graduate School of Psychoanalysis </option>

                                                  <option value="Boston University"> Boston University </option>
                                                  <option value="Bowdoin College"> Bowdoin College </option>
                                                  <option value="Bowie State University"> Bowie State University </option>
                                                  <option value="Bowling Green State University"> Bowling Green State University </option>
                                                  <option value="Bradley University"> Bradley University </option>

                                                  <option value="Brandeis University"> Brandeis University </option>
                                                  <option value="Brandman University"> Brandman University </option>
                                                  <option value="Brazosport College"> Brazosport College </option>
                                                  <option value="Brenau University"> Brenau University </option>
                                                  <option value="Brescia University"> Brenscia University </option>

                                                  <option value="Brevard College"> Brevard College </option>
                                                  <option value="Brewton-Parker College"> Brewton-Parker College </option>
                                                  <option value="Briar Cliff University"> Briar Cliff University </option>
                                                  <option value="Briarcliffe College"> Briarcliffe College </option>
                                                  <option value="Bridgewater College"> Bridgewater College </option>

                                                  <option value="Bridgewater State University"> Bridgewater State University </option>
                                                  <option value="Brigham Young University"> Brigham Young University </option>
                                                  <option value="Brigham Young University-Hawaii"> Brigham Young University-Hawaii </option>
                                                  <option value="Brigham Young University-Idaho"> Brigham Young University-Idaho </option>
                                                  <option value="Brooklyn College"> Brooklyn College </option>

                                                  <option value="Brooklyn Law School"> Brooklyn Law School </option>
                                                  <option value="Broward College"> Broward College </option>
                                                  <option value="Brown Mackie College"> Brown Mackie College </option>
                                                  <option value="Brown University"> Brown University </option>
                                                  <option value="Bryan College"> Bryan College </option>

                                                  <option value="Bryant and Stratton College"> Bryant and Stratton College </option>
                                                  <option value="Bryant University"> Bryant University </option>
                                                  <option value="Bryn Athyn College"> Bryn Athyn College </option>
                                                  <option value="Bryn Mawr College"> Bryn Mawr College </option>

                                                  <option value="Bucknell University"> Bucknell University </option>
                                                  <option value="Buena Vista University"> Buena Vista University </option>
                                                  <option value="Buffalo State College"> Buffalo State College </option>
                                                  <option value="Butler University"> Butler University </option>
                                                  <option value="Cabarrus College of Health Sciences"> Cabarrus College of Health Sciences </option>

                                                  <option value="Cabrini University"> Cabrini University </option>
                                                  <option value="Cairn University"> Cairn University </option>
                                                  <option value="Caldwell University"> Caldwell University </option>
                                                  <option value="California Baptist University"> California Baptist University </option>
                                                  <option value="California College of the Arts"> California College of the Arts </option>

                                                  <option value="California Institute of Integral Studies"> California Institute of Integral Studies </option>
                                                  <option value="California Institute of Technology"> California Institute of Technology </option>
                                                  <option value="California Institute of the Arts"> California Institute of the Arts </option>
                                                  <option value="California Lutheran University"> California Lutheran University </option>
                                                  <option value="California Polytechnic State University, San Luis Obispo"> California Polytechnic State University, San Luis Obispo (Cal Poly SLO) </option>

                                                  <option value="California State Polytechnic University, Ponoma"> California State Polytechnic University, Ponoma </option>
                                                  <option value="California State University, Channel Islands"> California State University, Channel Islands </option>
                                                  <option value="California State University, Maritime Academy"> California State University, Maritime Academy </option>
                                                  <option value="California State University, San Marcos"> California State University, San Marcos </option>
                                                  <option value="California State University, Stanislaus"> California State University, Stanislaus </option>

                                                  <option value="California State University, Bakersfield"> California State University, Bakersfield </option>
                                                  <option value="California State University, Chico"> California State University, Chico </option>
                                                  <option value="California State University, Dominguez Hills"> California State University, Dominguez Hills </option>
                                                  <option value="California State University, East Bay"> California State University, East Bay </option>
                                                  <option value="California State University, Fresno"> California State University, Fresno </option>

                                                  <option value="California State University, Fullerton"> California State University, Fullerton </option>
                                                  <option value="California State University, Long Beach"> California State University, Long Beach </option>
                                                  <option value="California State University, Los Angeles"> California State University, Los Angeles </option>
                                                  <option value="California State University, Monterey Bay"> California State University, Moneterey Bay </option>
                                                  <option value="California State University, Northridge"> California State University, Northridge </option>

                                                  <option value="California State University, Sacramento"> California State University, Sacramento (Sacramento State)</option>
                                                  <option value="California State University, San Bernadino"> California State University, San Bernadino </option>
                                                  <option value="California University of Pennsylvania"> California University of Pennsylvania </option>
                                                  <option value="California Western School of Law"> California Western School of Law </option>
                                                  <option value="Calumet College of St. Joseph"> Calumet College of St. Joseph </option>

                                                  <option value="Calvary University"> Calvary University </option>
                                                  <option value="Calvin College"> Calvin College </option>
                                                  <option value="Cambridge College"> Cambridge College </option>
                                                  <option value="Cameron University"> Cameron University </option>
                                                  <option value="Campbell University"> Campbell University </option>

                                                  <option value="Campbellsville University"> Campbellsville University </option>
                                                  <option value="Canisius College"> Canisius College </option>
                                                  <option value="Cañada College"> Cañada College (Canada College) </option>
                                                  <option value="Capital University"> Capital University </option>
                                                  <option value="Capitol Technology University"> Caitol Technology University </option>

                                                  <option value="Cardinal Stritch University"> Cardinal Stritch University </option>
                                                  <option value="Carleton College"> Carleton College </option>
                                                  <option value="Carlow University"> Carlow University </option>
                                                  <option value="Carnegie Mellon University"> Carnegie Mellon University </option>
                                                  <option value="Carroll College"> Carroll College </option>

                                                  <option value="Carroll University"> Carroll University </option>
                                                  <option value="Carson-Newman University"> Carson-Newman University </option>
                                                  <option value="Carthage College"> Carthage College </option>
                                                  <option value="Case Western Reserve University"> Case Western Reserve University </option>
                                                  <option value="Castleton University"> Castleton University </option>

                                                  <option value="Catawba College"> Catawba College </option>
                                                  <option value="Catholic Theological Union"> Catholic Theological Union </option>
                                                  <option value="Cazenovia College"> Cazenovia College </option>
                                                  <option value="Cedar Crest College"> Cedar Crest College </option>
                                                  <option value="Cedarville University"> Cedarville University </option>

                                                  <option value="Centenary College of Louisiana"> Centenary College of Lousiana </option>
                                                  <option value="Centenary University"> Centenary University </option>
                                                  <option value="Central Baptist College"> Central Baptist College </option>
                                                  <option value="Central Christian College of Kansas"> Central Christian College of Kansas </option>
                                                  <option value="Central Christian College of the Bible"> Central Christian College of the Bible </option>

                                                  <option value="Central College"> Central College </option>
                                                  <option value="Central Connecticut State University"> Central Connecticut State University </option>
                                                  <option value="Central Methodist University"> Central Methodist University </option>
                                                  <option value="Central Michigan University"> Central Michigan University </option>
                                                  <option value="Central Penn College"> Central Penn College </option>

                                                  <option value="Central State University"> Central State University </option>
                                                  <option value="Central Washington University"> Central Washington University </option>
                                                  <option value="Centralia College"> Centralia College </option>
                                                  <option value="Centre College"> Centre College </option>
                                                  <option value="Chadron State College"> Chadron State College </option>

                                                  <option value="Chamberlain College of Nursing"> Chamberlain College of Nursing </option>
                                                  <option value="Chaminade University of Honolulu"> Chaminade University of Honolulu </option>
                                                  <option value="Champlain College"> Champlain College </option>
                                                  <option value="Chapman University"> Chapman University </option>
                                                  <option value="Charles R. Drew University of Medicine and Science"> Charles R. Drew University of Medicine and Science </option>

                                                  <option value="Charleston Southern University"> Charleston Southern University </option>
                                                  <option value="Chatham University"> Chatham University </option>
                                                  <option value="Chestnut Hill College"> Chestnut Hill College </option>
                                                  <option value="Cheyney University of Pennsylvania"> Cheyney University of Pennsylvania </option>
                                                  <option value="Chicago State University"> Chicago State University </option>

                                                  <option value="Chipola College"> Chipola College </option>
                                                  <option value="Chowan University"> Chowan University </option>
                                                  <option value="Christian Brothers University"> Christian Brothers University </option>
                                                  <option value="Christopher Newport University"> Christopher Newport University </option>
                                                  <option value="Cincinnati Christian University"> Cincinnati Christian University </option>

                                                  <option value="City University of Seattle"> City University of Seattle </option>
                                                  <option value="Claflin University"> Claflin University </option>
                                                  <option value="Claremont Graduate University"> Claremont Graduate University </option>
                                                  <option value="Claremont McKenna College"> Claremont McKenna College </option>
                                                  <option value="Clarion University of Pennsylvania"> Clarion University of Pennsylvania </option>

                                                  <option value="Clark Atlanta University"> Clark Atlanta University </option>
                                                  <option value="Clark University"> Clark University </option>
                                                  <option value="Clarke University"> Clarke University </option>
                                                  <option value="Clarks Summit University"> Clarks Summit University </option>
                                                  <option value="Clarkson College"> Clarkson College </option>

                                                  <option value="Clarkson University"> Clarkson University </option>
                                                  <option value="Clemson University"> Clemson University </option>
                                                  <option value="Cleveland Institute of Art"> Cleveland Institute of Art </option>
                                                  <option value="Cleveland Institute of Music"> Cleveland Institute of Music </option>
                                                  <option value="Cleveland State University"> Cleveland State University </option>

                                                  <option value="Cleveland University-Kansas City"> Cleveland University-Kansas City </option>
                                                  <option value="Coastal Carolina University"> Coastal Carolina University </option>
                                                  <option value="Coe College"> Coe College </option>
                                                  <option value="Cogswell Polytechnical College"> Cogswell Polytechnical College </option>
                                                  <option value="Coker College"> Coker College </option>

                                                  <option value="Colby College"> Colby College </option>
                                                  <option value="Colby-Sawyer College"> Colby-Sawyer College </option>
                                                  <option value="Colgate University"> Colgate University </option>
                                                  <option value="College for Creative Studies"> College for Creative Studies </option>
                                                  <option value="College of Biblical Studies"> College of Biblical Studies </option>

                                                  <option value="College of Central Florida"> College of Central Florida </option>
                                                  <option value="College of Charleston"> College of Charleston </option>
                                                  <option value="College of Coastal Georgia"> College of Coastal Georgia </option>
                                                  <option value="College of Our Lady of the Elms"> College of Our Lady of the Elms </option>

                                                  <option value="College of Saint Elizabeth"> College of Saint Elizabeth </option>
                                                  <option value="College of Saint Mary"> College of Saint Mary </option>
                                                  <option value="College of South Nevada"> College of South Nevada </option>
                                                  <option value="College of St. Joseph"> College of St. Joseph </option>

                                                  <option value="College of Staten Island"> College of Staten Island </option>
                                                  <option value="College of the Atlantic"> College of the Atlantic </option>
                                                  <option value="College of the Holy Cross"> College of the Holy Cross </option>
                                                  <option value="College of the Ozarks"> College of the Ozarks </option>
                                                  <option value="College of William & Mary"> College of William & Mary </option>

                                                  <option value="Colorado Christian University"> Colorado Christian University </option>
                                                  <option value="Colorado College"> Colorado College </option>
                                                  <option value="Colorado Mesa University"> Colorado Mesa University </option>
                                                  <option value="Colorado School of Mines"> Colorado School of Mines </option>
                                                  <option value="Colorado State University"> Colorado State University </option>

                                                  <option value="Colorado State University-Pueblo"> Colorado State University-Pueblo </option>
                                                  <option value="Colorado Technical University"> Colorado Technical University </option>
                                                  <option value="Columbia Basin College"> Columbia Basin College </option>
                                                  <option value="Columbia College"> Columbia College </option>
                                                  <option value="Columbia College Chicago"> Columbia College Chicago </option>

                                                  <option value="Columbia College of Nursing"> Columbia College of Nursing </option>
                                                  <option value="Columbia College, South Carolina"> Columbia College, South Carolina </option>
                                                  <option value="Columbia College-Hollywood"> Columbia College-Hollywood </option>
                                                  <option value="Columbia International University"> Columbia International University </option>
                                                  <option value="Columbus College of Art and Design"> Columbus College of Art and Design </option>

                                                  <option value="Columbus State University"> Columbus State University </option>
                                                  <option value="Concord University"> Concord University </option>
                                                  <option value="Concordia College"> Concordia College </option>
                                                  <option value="Concordia College Alabama"> Concordia College Alabama </option>
                                                  <option value="Concordia College New York"> Concordia College New York </option>

                                                  <option value="Concordia University Ann Arbor"> Concordia University Ann Arbor </option>
                                                  <option value="Concordia University Chicago"> Concordia University Chicago </option>
                                                  <option value="Concordia University Irvine"> Concordia University Irvine </option>
                                                  <option value="Concordia University Texas"> Concordia University Texas </option>
                                                  <option value="Concordia University Wisconsin"> Concordia University Wisconsin </option>

                                                  <option value="Concordia University Nebraska"> Concordia University Nebraska </option>
                                                  <option value="Concordia University Oregon"> Concordia University Oregon </option>
                                                  <option value="Concordia University St. Paul"> Concordia University St. Paul </option>
                                                  <option value="Connecticut College">
                                                  <option value="Converse College"> Converse College </option>

                                                  <option value="Conway School of Landscape Design"> Conway School of Landscape Design </option>
                                                  <option value="Coppin State University"> Coppin State University </option>
                                                  <option value="Corban University"> Corban University </option>
                                                  <option value="Cornell College"> Cornell College </option>
                                                  <option value="Cornell University"> Cornell University </option>

                                                  <option value="Cornerstone University"> Cornerstone University </option>
                                                  <option value="Cornish College of the Arts"> Cornish College of the Arts </option>
                                                  <option value="Cottey College"> Cottey College </option>
                                                  <option value="Covenant College"> Covenant College </option>
                                                  <option value="Cox College"> Cox College </option>

                                                  <option value="Cranbrook Academy of Art"> Cranbrook Academy of Art </option>
                                                  <option value="Creighton University"> Creighton University </option>
                                                  <option value="Chiswell College"> Chiswell College </option>
                                                  <option value="Crossroads Bible College"> Crossroads Bible College </option>
                                                  <option value="Crossroads College"> Crossroads College </option>

                                                  <option value="Crowley's Ridge College"> Crowley's Ridge College </option>
                                                  <option value="Crown College"> Crown College </option>
                                                  <option value="Culver-Stockton College"> Culver-Stockton College </option>
                                                  <option value="Cumberland University"> Cumberland University </option>
                                                  <option value="College of San Mateo"> College of San Mateo (CSM) </option>

                                                  <option value="Curry College"> Curry College </option>
                                                  <option value="Curtis Institute of Music"> Curtis Institute of Music </option>
                                                  <option value="Daemen College"> Daemen College </option>
                                                  <option value="Dakota State University"> Dakota State University </option>
                                                  <option value="Dakota Wesleyan University"> Dakota Wesleyan University </option>

                                                  <option value="Dallas Baptist University"> Dallas Baptist University </option>
                                                  <option value="Dallas Christian College"> Dallas Christian College </option>
                                                  <option value="Dalton State College"> Dalton State College </option>
                                                  <option value="Dartmouth College"> Dartmouth College </option>
                                                  <option value="Davenport University"> Davenport University </option>

                                                  <option value="Davidson College"> Davidson College </option>
                                                  <option value="Davis & Elkins College"> Davis & Elkins College </option>
                                                  <option value="Davis College"> Davis College </option>
                                                  <option value="Daytona State College"> Daytona State College </option>
                                                  <option value="Dean College"> Dean College </option>

                                                  <option value="Defiance College"> Defiance College </option>
                                                  <option value="Deleware State University"> Deleware State University </option>
                                                  <option value="Deleware Valley University"> Deleware Valley University </option>
                                                  <option value="Delta State University"> Delta State University </option>
                                                  <option value="Denison University"> Denison University </option>

                                                  <option value="Denver College of Nursing"> Denver College of Nursing </option>
                                                  <option value="DePaul University"> DePaul University </option>
                                                  <option value="DePauw University"> DePauw University </option>
                                                  <option value="Des Moines University"> Des Moines University </option>
                                                  <option value="DeSales University"> DeSales University </option>

                                                  <option value="DeVry University"> DeVry University </option>
                                                  <option value="Dickinson College"> Dickinson College </option>
                                                  <option value="Dickinson State University"> Dickinson State University </option>
                                                  <option value="Dillard University"> Dillard University </option>
                                                  <option value="Dixie State University"> Dixie State University </option>

                                                  <option value="Doane University"> Doane University </option>
                                                  <option value="Dominican College"> Dominican College </option>
                                                  <option value="Dominican University"> Dominican University </option>
                                                  <option value="Dominican University of California"> Dominican University of California </option>
                                                  <option value="Donnelly College"> Donnelly College </option>

                                                  <option value="Dordt College"> Dordt College </option>
                                                  <option value="Dowling College"> Dowling College </option>
                                                  <option value="Drake University"> Drake University </option>
                                                  <option value="Drew University"> Drew University </option>
                                                  <option value="Drexel University"> Drexel University </option>

                                                  <option value="Duke University"> Duke University </option>
                                                  <option value="Earlham College"> Earlham College </option>
                                                  <option value="East Carolina University"> East Carolina University </option>
                                                  <option value="East Central University"> East Central University </option>
                                                  <option value="East Georgia State College"> East Georgia State College </option>

                                                  <option value="East Tennessee State University"> East Tennessee State University </option>
                                                  <option value="East Texas Baptist University"> East Texas Baptist University </option>
                                                  <option value="Edgewood College"> Edgewood College </option>
                                                  <option value="Emory University"> Emory University </option>
                                                  <option value="Fairfield University"> Fairfield University </option>

                                                  <option value="Fashion Institute of Technology"> Fashion Institute of Technology </option>
                                                  <option value="Fisher College"> Fisher College </option>
                                                  <option value="Fisk University"> Fisk University </option>
                                                  <option value="Fitchburg State University"> Fitchburg State University </option>
                                                  <option value="Florida College"> Florida College </option>

                                                  <option value="Florida Gulf Coast University"> Florida Gulf Coast University </option>
                                                  <option value="Florida Institute of Technology"> Florida Institute of Technology </option>
                                                  <option value="Florida State University"> Florida State University </option>
                                                  <option value="Fordham University"> Fordham University </option>
                                                  <option value="Friends University"> Friends University </option>

                                                  <option value="Furman University"> Furman University </option>
                                                  <option value="George Mason University"> George Mason University </option>
                                                  <option value="George Washington University"> George Washington University </option>
                                                  <option value="Georgetown University"> Georgetown University </option>
                                                  <option value="Georgia Institute of Technology"> Georgia Institute of Technology (Georgia Tech) </option>

                                                  <option value="Georgia State University"> Georgia State University </option>
                                                  <option value="Hamilton College"> Hamilton College </option>
                                                  <option value="Hanover College"> Hanover College </option>
                                                  <option value="Harding University"> Harding University </option>
                                                  <option value="Harvard University"> Harvard University </option>

                                                  <option value="Harvey Mudd College"> Harvey Mudd College </option>
                                                  <option value="Hillsdale College"> Hillsdale College </option>
                                                  <option value="Holy Names University"> Holy Names University </option>
                                                  <option value="Hofstra University"> Hofstra University </option>
                                                  <option value="Howard University"> Howard University </option>

                                                  <option value="Humboldt State University"> Humboldt State University </option>
                                                  <option value="Idaho State University"> Idaho State University </option>
                                                  <option value="Illinois Institute of Technology"> Illinois Institute of Technology </option>
                                                  <option value="Illinois State University"> Illinois State University </option>
                                                  <option value="Indiana State University"> Indiana State University </option>

                                                  <option value="Iowa State University of Science and Technology"> Iowa State University of Science and Technology </option>
                                                  <option value="John Hopkins University"> John Hopkins University </option>
                                                  <option value="Kansas State University"> Kansas State University </option>
                                                  <option value="Kean University"> Kean University </option>
                                                  <option value="Kennesaw State University"> Kennesaw State University </option>

                                                  <option value="Kent State University"> Kent State University </option>
                                                  <option value="Kentucky State University"> Kentucky State University </option>
                                                  <option value="La Roche College"> La Roche College </option>
                                                  <option value="La Sierra University"> La Sierra University </option>
                                                  <option value="Laboure College"> Laboure College </option>

                                                  <option value="Lafayette College"> Lafayette College </option>
                                                  <option value="Lake Forest College"> Lake Forest College </option>
                                                  <option value="Lake Superior State University"> Lake Superior State University </option>
                                                  <option value="Lamar University"> Lamar University </option>
                                                  <option value="Lewis & Clark College"> Lewis & Clark College </option>

                                                  <option value="Liberty University"> Liberty University </option>
                                                  <option value="Long Island University"> Long Island University </option>
                                                  <option value="Lousiana State University"> Louisiana State University </option>
                                                  <option value="Louisiana Tech University"> Louisiana Tech University </option>
                                                  <option value="Loyola Marymount University"> Loyola Marymount University </option>

                                                  <option value="Luther College"> Luther College </option>
                                                  <option value="Macalester College"> Macalester College </option>
                                                  <option value="Manhattan College"> Manhatten College </option>
                                                  <option value="Marist College"> Marist College </option>
                                                  <option value="Marshall University"> Marshall University </option>

                                                  <option value="Massachusetts Institute of Technology"> Massachusetts Institute of Technology (MIT) </option>
                                                  <option value="Menlo College"> Menlo College </option>
                                                  <option value="Metropolitan College of New York"> Metropolitan College of New York </option>
                                                  <option value="Miami University"> Miami University </option>
                                                  <option value="Middlebury College"> Middlebury College </option>

                                                  <option value="Mills College"> Mills College </option>
                                                  <option value="Minnesota State University Moorhead"> Minnesota State University Moorhead </option>
                                                  <option value="Minnesota State University Mankato"> Minnesota State University Mankato </option>
                                                  <option value="Minot State University"> Minot State University </option>
                                                  <option value="Missouri State University"> Missouri State University </option>

                                                  <option value="Missouri University of Science and Technology"> Missouri University of Science and Technology </option>
                                                  <option value="Montana State University"> Montana State University </option>
                                                  <option value="Montana State University Billings"> Montana State University Billings </option>
                                                  <option value="Northern Montana State University"> Northern Montana State University </option>
                                                  <option value="Montana Tech"> Montana Tech </option>

                                                  <option value="Morehouse College"> Morehouse College </option>
                                                  <option value="Morgan State University"> Morgan State University </option>
                                                  <option value="National University"> National University </option>
                                                  <option value="Nazareth College"> Nazareth College </option>
                                                  <option value="New England College"> New England College </option>

                                                  <option value="New England Institute of Technology"> New England Institute of Technology </option>
                                                  <option value="New Jersey City University"> New Jersey City University </option>
                                                  <option value="New Jersey Institute of Technology"> New Jersey Institute of Technology </option>
                                                  <option value="New Mexico State University"> New Mexico State University </option>
                                                  <option value="New York Academy of Art"> New York Academy of Art </option>

                                                  <option value="New York City College of Technology"> New York City College of Technology </option>
                                                  <option value="New York Institute of Technology"> New York Institute of Technology </option>
                                                  <option value="New York University"> New York University (NYU) </option>
                                                  <option value="Niagara University"> Niagara University </option>
                                                  <option value="North Carolina Central University"> North Carolina Central University </option>

                                                  <option value="North Carolina State University"> North Carolina State University </option>
                                                  <option value="North Central College"> North Central College </option>
                                                  <option value="North Dakota State University"> North Dakota State University </option>
                                                  <option value="Northeastern Illinois University"> Northeastern Illinois University </option>
                                                  <option value="Northeastern State University"> Northeastern State University </option>

                                                  <option value="Northern Kentucky University"> Northern Kentucky University </option>
                                                  <option value="Northwest Missouri State University"> Northwest Missouri State University </option>
                                                  <option value="Northwestern Oklahoma State University"> Northwestern Oklahoma State University </option>
                                                  <option value="Northwestern State University of Louisiana"> Northwestern State University of Louisiana </option>
                                                  <option value="Northwestern University"> Northwestern University </option>

                                                  <option value="Notre Dame College"> Notre Dame College </option>
                                                  <option value="Notre Dame de Namur University (NDNU)"> Notre Dame de Namur University </option>
                                                  <option value="Notre Dame of Maryland University"> Notre Dame of Maryland University </option>
                                                  <option value="Nova Southeastern University"> Nova Southeastern University </option>
                                                  <option value="Oakland University"> Oakland University </option>

                                                  <option value="Ohio University"> Ohio University </option>
                                                  <option value="Oklahoma Christian University"> Oklahoma Christian University </option>
                                                  <option value="Oklahoma City University"> Oklahoma City University </option>
                                                  <option value="Oklahoma State University"> Oklahoma State University </option>
                                                  <option value="Old Dominion University"> Old Dominion University </option>

                                                  <option value="Oregon Health & Science University"> Oregon Health & Science University </option>
                                                  <option value="Oregon Institute of Technology"> Oregon Institute of Technology </option>
                                                  <option value="Oregon State University"> Oregon State University </option>
                                                  <option value="Pace University"> Pace University </option>
                                                  <option value="Pacific University"> Pacific University </option>

                                                  <option value="Palo Alto University"> Palo Alto University </option>
                                                  <option value="Park University"> Park University </option>
                                                  <option value="Penn State University"> Penn State University </option>
                                                  <option value="Pepperdine University"> Pepperdine University </option>
                                                  <option value="Pittsburg State University"> Pittsburg State University </option>

                                                  <option value="Pitzer College"> Pitzer College </option>
                                                  <option value="Plymouth State University"> Plymouth State University </option>
                                                  <option value="Ponoma College"> Ponoma College </option>
                                                  <option value="Portland State University"> Portland State University </option>
                                                  <option value="Princeton University"> Princeton University </option>

                                                  <option value="Purdue University"> Purdue University </option>
                                                  <option value="Reed College"> Reed College </option>
                                                  <option value="Reinhardt University"> Reinhardt University </option>
                                                  <option value="Rensselaer Polytechnic Institute"> Rensselaer Polytechnic Institute </option>
                                                  <option value="Rhode Island College"> Rhode Island College </option>

                                                  <option value="Rice University"> Rice University </option>
                                                  <option value="Rider University"> Rider University </option>
                                                  <option value="Rochester Institute of Technology"> Rochester Institute of Technology </option>
                                                  <option value="Rutgers State University"> Rutgers State University </option>
                                                  <option value="Sacred Heart University"> Sacred Heart University </option>

                                                  <option value="Saint Joseph's University"> Saint Joseph's University </option>
                                                  <option value="Salem State University"> Salem State University </option>
                                                  <option value="Sam Houston State University"> Sam Houston State University </option>
                                                  <option value="Samford University"> Samford University </option>
                                                  <option value="San Diego State University"> San Diego State University </option>

                                                  <option value="San Francisco Art Institute"> San Francisco Art Institute </option>
                                                  <option value="San Francisco State University"> San Francisco State University (SFSU) </option>
                                                  <option value="San Jose State University"> San Jose State University (SJSU) </option>
                                                  <option value="Santa Clara University"> Santa Clara University </option>
                                                  <option value="Savannah State University"> Savannah State University </option>

                                                  <option value="Seton Hall University"> Seton Hall University </option>
                                                  <option value="Siena College"> Siena College </option>
                                                  <option value="Simmons College"> Simmons College </option>
                                                  <option value="Smith College"> Smith College </option>
                                                  <option value="Sonoma State University"> Sonoma State University </option>

                                                  <option value="South Carolina State University"> South Carolina State University </option>
                                                  <option value="South Dakota State University"> South Dakota State University </option>
                                                  <option value="South Texas College"> South Texas College </option>
                                                  <option value="South University"> South University </option>
                                                  <option value="St. John's University"> St. John's University </option>

                                                  <option value="Stanford University"> Stanford University </option>
                                                  <option value="Stevens Institute of Technology"> Stevens Institute of Technology </option>
                                                  <option value="Suffolk University"> Suffolk University </option>
                                                  <option value="Sweet Briar College"> Sweet Briar College </option>
                                                  <option value="Syracuse University"> Syracuse University </option>

                                                  <option value="Temple University"> Temple University </option>
                                                  <option value="Tennessee State University"> Tennessee State University </option>
                                                  <option value="Tennessee Technological University"> Tennessee Technological University </option>
                                                  <option value="Texas A&M University"> Texas A&M University </option>
                                                  <option value="Texas College"> Texas College </option>

                                                  <option value="Texas State University"> Texas State University </option>
                                                  <option value="Texas Tech University"> Texas Tech University </option>
                                                  <option value="The Catholic University of America"> The Catholic University of America </option>
                                                  <option value="The University of Alabama"> The University of Alabama </option>
                                                  <option value="The University of Alabama in Huntsville"> The University of Alabama in Huntsville </option>

                                                  <option value="The University of Maine"> The UNiversity of Maine </option>
                                                  <option value="The University of Memphis"> The University of Memphis </option>
                                                  <option value="The University of Montana"> The University of Montana </option>
                                                  <option value="The University of Oklahoma"> The University of Oklahoma </option>
                                                  <option value="The University of Tampa"> The University of Tampa </option>

                                                  <option value="Thee University of Tennessee Knoxville"> The University of Tennessee Knoxville </option>
                                                  <option value="The University of Texas at Arlington"> The University of Texas at at Arlington </option>
                                                  <option value="The University of Texas at Austin"> The University of Texas at Austin </option>
                                                  <option value="The University of Texas at Dallas"> The University of Texas at Dallas </option>
                                                  <option value="The University of Texas at El Paso"> The University of Texas at El Paso </option>

                                                  <option value="The University of Texas at San Antonio"> The University of Texas at San Antonio </option>
                                                  <option value="The University of Texas at Tyler"> The University of Texas at Tyler </option>
                                                  <option value="The University of Tulsa"> The University of Tulsa </option>
                                                  <option value="Thomas Jefferson University"> Thomas Jefferson University </option>
                                                  <option value="Trinity University"> Trinity University </option>

                                                  <option value="Troy University"> Troy University </option>
                                                  <option value="Tufts University"> Tufts University </option>
                                                  <option value="Tulane University"> Tulane University </option>
                                                  <option value="United States Air Force Academy"> Unites States Air Force Academy </option>
                                                  <option value="University at Albany, State University of New York"> University at Albany, State University of New York </option>

                                                  <option value="University at Buffalo, State University of New York"> University at Buffalo, State University of New York </option>
                                                  <option value="University of Akron"> University of Akron </option>
                                                  <option value="University of Alabama at Birmingham"> University of Alabama at Birmingham </option>
                                                  <option value="University of Alaska Anchorage"> University of Alaska Anchorage </option>
                                                  <option value="University of Alaska Fairbanks"> University of Alaska Fairbanks </option>

                                                  <option value="University of Alaska Southeast"> University of Alaska Southeast </option>
                                                  <option value="University of Arkansas"> University of Arkansas </option>
                                                  <option value="University of Baltimore"> University of Baltimore </option>
                                                  <option value="University of California, Berkeley"> University of California, Berkeley (UC Berkeley) </option>
                                                  <option value="University of California, Davis"> University of California, Davis (UC Davis) </option>

                                                  <option value="University of California, Irvine"> University of California, Irvine (UC Irvine) </option>
                                                  <option value="University of California, Los Angeles"> University of California, Los Angeles (UCLA) </option>
                                                  <option value="University of California, Merced"> University of California, Merced (UC Merced) </option>
                                                  <option value="University of California, Riverside"> University of California, Riverside (UC Riverside) </option>
                                                  <option value="University of California, San Diego"> University of California, San Diego (UCSD) </option>

                                                  <option value="University of California, San Francisco"> University of California, San Francisco (UCSF) </option>
                                                  <option value="University of California, Santa Barbara"> University of California, Santa Barbara (UCSB) </option>
                                                  <option value="University of California, Santa Cruz"> University of California, Santa Cruz (UCSC) </option>
                                                  <option value="University of Central Arkansas"> University of Central Arkansas </option>
                                                  <option value="University of Central Florida"> University of Central Florida </option>

                                                  <option value="University of Central Missouri"> University of Central Missouri </option>
                                                  <option value="University of Central Oklahoma"> University of Central Oklahoma </option>
                                                  <option value="University of Chicago"> University of Chicago </option>
                                                  <option value="University of Cincinnati"> University of Cincinnati </option>
                                                  <option value="University of Colorado Boulder"> University of Colorado Boulder </option>

                                                  <option value="University of Colorado Colorado Springs"> University of Colorado Colorado Springs </option>
                                                  <option value="University of Colorado Denver"> University of Colorado Denver </option>
                                                  <option value="University of Connecticut"> University of Connecticut </option>
                                                  <option value="University of Dallas"> University of Dallas </option>
                                                  <option value="University of Dayton"> University of Dayton </option>

                                                  <option value="University of Deleware"> University of Deleware </option>
                                                  <option value="University of Denver"> University of Denver </option>
                                                  <option value="University of Florida"> University of Florida </option>
                                                  <option value="University of Georgia"> University of Georgia </option>
                                                  <option value="University of Hawaii at Hilo"> University of Hawaii at Hilo </option>

                                                  <option value="University of Hawaii at Manoa"> University of Hawaii at Manoa </option>
                                                  <option value="University of Hawaii at West Oahu"> University of Hawaii at West Oahu </option>
                                                  <option value="University of Houston"> University of Houston </option>
                                                  <option value="University of Idaho"> University of Idaho </option>
                                                  <option value="University of Illinois at Chicago"> University of Illinois at Chicago </option>

                                                  <option value="University of Illinois at Springfield"> University of Illinois at Springfield </option>
                                                  <option value="University of Illinois at Urbana-Champagin"> University of Illinois at Urbana-Champagin </option>
                                                  <option value="University of Iowa"> University of Iowa </option>
                                                  <option value="University of Kansas"> University of Kansas </option>
                                                  <option value="University of Kentucky"> University of Kentucky </option>

                                                  <option value="University of Louisiana at Lafayette"> University of Louisiana at Lafayette </option>
                                                  <option value="University of Louisiana at Monroe"> University of Louisiana at Monroe </option>
                                                  <option value="University of Louisville"> University of Louisville </option>
                                                  <option value="University of Maryland"> University of Maryland </option>
                                                  <option value="University of Maryland Eastern Shore"> University of Maryland Eastern Shore </option>

                                                  <option value="University of Maryland Baltimore"> University of Maryland Baltimore </option>
                                                  <option value="University of Massachusetts Amherst"> University of Massachusetts Amherst </option>
                                                  <option value="University of Massachusetts Boston"> University of Massachusetts Boston </option>
                                                  <option value="University of Miami"> University of Miami </option>
                                                  <option value="University of Michigan"> University of Michigan </option>

                                                  <option value="University of Michigan Dearborn"> University of Michigan Dearborn </option>
                                                  <option value="University of Michigan Flint"> University of Michigan Flint </option>
                                                  <option value="University of Minnesota"> University of Minnesota </option>
                                                  <option value="University of Mississippi"> University of Mississippi </option>
                                                  <option value="University of Missouri"> University of Missouri </option>

                                                  <option value="University of Missouri Kansas City"> University of Missouri Kansas City </option>
                                                  <option value="University of Missouri St. Louis"> University of Missouri St. Louis </option>
                                                  <option value="University of Mobile"> University of Mobile </option>
                                                  <option value="University of Nebraska at Omaha"> University of Nebraska at Omaha </option>
                                                  <option value="University of Nebraska at Lincoln"> University of Nebraska at Lincoln </option>

                                                  <option value="University of Nevada Las Vegas"> University of Nevada Las Vegas </option>
                                                  <option value="University of Nevada Reno"> University of Nevada Reno </option>
                                                  <option value="University of New Hampshire"> University of New Hampshire </option>
                                                  <option value="University of New Mexico"> University of New Mexico </option>
                                                  <option value="University of New Orleans"> University of New Orleans </option>

                                                  <option value="University of North Carolina at Asheville"> University of North Carolina at Asheville </option>
                                                  <option value="University of North Carolina at Chapel Hill"> University of North Carolina at Chapel Hill </option>
                                                  <option value="University of North Carolina at Charlotte"> University of North Carolina at Charolotte </option>
                                                  <option value="University of North Carolina at Greensboro"> University of North Carolina at Greensboro </option>
                                                  <option value="University of North Carolina at Pembroke"> University of North Carolina at Pembroke </option>

                                                  <option value="University of Notre Dame"> University of Notre Dame </option>
                                                  <option value="University of Oregon"> University of Oregon </option>
                                                  <option value="University of Pennsylvania"> University of Pennsylvania </option>
                                                  <option value="University of Pittsburg"> University of Pittsburg </option>
                                                  <option value="University of Portland"> University of Portland </option>

                                                  <option value="University of Puget Sound"> University of Puget Sound </option>
                                                  <option value="University of Rhode Island"> University of Rhode Island </option>
                                                  <option value="University of Richmond"> University of Richmond </option>
                                                  <option value="University of Rochester"> University of Rochester </option>
                                                  <option value="University of San Diego"> University of San Diego </option>

                                                  <option value="University of San Francisco"> University of San Francisco </option>
                                                  <option value="University of South Carolina"> University of South Carolina </option>
                                                  <option value="University of South Carolina Aiken"> University of South Carolina Aiken </option>
                                                  <option value="University of South Carolina Beaufort"> University of South Carolina Beaufort </option>
                                                  <option value="University of South Carolina Upstate"> University of South Carolina Upstate </option>

                                                  <option value="University of South Dakota"> University of South Dakota </option>
                                                  <option value="University of the Pacific"> University of the Pacific </option>
                                                  <option value="University of the Potomac"> University of the Potomac </option>
                                                  <option value="University of Toledo"> University of Toledo </option>
                                                  <option value="University of Vermont"> University of Vermont </option>

                                                  <option value="University of Virginia"> University of Virginia </option>
                                                  <option value="University of Washington"> University of Washington </option>
                                                  <option value="University of Wisconsin Eau Claire"> University of Wisconsin Eau Claire </option>
                                                  <option value="University of Wisconsin Green Bay"> University of Wisconsin Green Bay </option>
                                                  <option value="University of Wisconsin La Crosse"> University of Wisconsin La Crosse </option>

                                                  <option value="University of Wisconsin Madison"> University of Wisconsin Madison </option>
                                                  <option value="University of Wisconsin Milwaukee"> University of Wisconsin Milwaukee </option>
                                                  <option value="University of Wisconsin Oshkosh"> University of Wisconsin Oshkosh </option>
                                                  <option value="University of Wisconsin Parkside"> University of Wisconsin Parkside </option>
                                                  <option value="University of Wisconsin Platteville"> University of Wisconsin Platteville </option>

                                                  <option value="University of Wisconsin River Falls"> University of Wisconsin River Falls </option>
                                                  <option value="University of Wisconsin Stevens Point"> University of Wisconsin Stevens Point </option>
                                                  <option value="University of Wisconsin Stout"> University of Wisconsin Stout </option>
                                                  <option value="University of Wisconsin Superior"> University of Wisconsin Superior </option>
                                                  <option value="University of Wisconsin Whitewater"> University of Wisconsin Whitewater </option>

                                                  <option value="University of Wyoming"> University of Wyoming </option>
                                                  <option value="Utah State University"> Utah State University </option>
                                                  <option value="Utica College"> Utica College </option>
                                                  <option value="Vanderbilt University"> Vanderbilt University </option>
                                                  <option value="Vassar College"> Vassar College </option>

                                                  <option value="Villanova University"> Villanova University </option>
                                                  <option value="Washington State University"> Washington State University </option>
                                                  <option value="Weber State University"> Weber State University </option>
                                                  <option value="Wells College"> Wells College </option>
                                                  <option value="West Virginia University"> West Virginia University </option>

                                                  <option value="Western Washington University"> Western Washington University </option>
                                                  <option value="Yale University"> Yale University </option>

                                          </datalist>
                                          </select>

                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>


                <h3 align="center"> Change Password </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="4" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input id="xpassword" name="xpassword" autocomplete = "off" class="form-control" placeholder="Change Password">
                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>
                <h3 align="center"> Change Email </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="5" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input type = "email" id="xemail" name="xemail" autocomplete = "off" class="form-control" placeholder="<%=email%>">
                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>
                <h3 align="center"> Change Phone Number </h3>
                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="6" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <input type = "tel" id="xphone" name="xphone" autocomplete = "off" class="form-control" placeholder="<%=phone%>">
                      &nbsp
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit"> Change </button>
                      <hr class="my-4">
                </form>

                <form action = "/updateinfo" method = "post" target="_self">
                      <input type="hidden" id="choice" name="choice" value="7" >
                      <input type="hidden" id="userid" name="userid" value="<%=userid%>" >
                      <button class="btn btn-lg btn-primary btn-block text-uppercase" style="background-color:red;" type="submit"> Delete Account </button>
                      <hr class="my-4">
                </form>


            </div>
        </div>



</body>

</html>