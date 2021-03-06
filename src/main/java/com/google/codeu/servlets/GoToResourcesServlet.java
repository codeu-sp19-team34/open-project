/*
 * Copyright 2016 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.codeu.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

// [START gae_java8_mysql_app]
@WebServlet("/gotores")
public class GoToResourcesServlet extends HttpServlet {

    Connection conn;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String groupid = request.getParameter("groupid");
        String userid = request.getParameter("userid");
        String group = request.getParameter("group");

        response.sendRedirect("/group_resources.jsp?group="+ group +"&id="+ groupid +"&userid=" + userid);

    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        doGet(request, response);
    }

}