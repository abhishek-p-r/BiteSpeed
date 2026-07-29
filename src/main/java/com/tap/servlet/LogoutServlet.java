package com.tap.servlet;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;



@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {


    private static final long serialVersionUID = 1L;



    @Override
    protected void doGet(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {



        // Get existing session
        HttpSession session =
                request.getSession(false);



        // Invalidate session
        if(session != null) {

            session.invalidate();

        }



        // Prevent accessing previous pages after logout

        response.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate"
        );


        response.setHeader(
                "Pragma",
                "no-cache"
        );


        response.setDateHeader(
                "Expires",
                0
        );



        // Redirect user to login page

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?success=logged_out"
        );

    }





    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {


        doGet(request, response);

    }


}

