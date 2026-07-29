package com.tap.servlet;


import com.tap.model.CartItem;
import com.tap.model.User;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


import java.io.IOException;
import java.util.Map;



@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {


    private static final long serialVersionUID = 1L;




    // ================================
    // CHECKOUT SUBMIT
    // ================================

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {



        HttpSession session =
                request.getSession();




        // Check user login

        User user =
                (User) session.getAttribute("user");



        if(user == null) {


            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );


            return;

        }






        // Get cart from session

        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>)
                        session.getAttribute("cart");






        // Check cart empty

        if(cart == null || cart.isEmpty()) {



            response.sendRedirect(
                    request.getContextPath()
                    + "/menu.jsp"
            );


            return;

        }






        String address =
                request.getParameter("address");



        String phone =
                request.getParameter("phone");







        // Validate checkout details

        if(address == null
                || address.trim().isEmpty()
                ||
           phone == null
                || phone.trim().isEmpty()) {




            session.setAttribute(
                    "checkoutError",
                    "Please enter address and phone number"
            );



            response.sendRedirect(
                    request.getContextPath()
                    + "/checkout.jsp"
            );


            return;

        }







        // Save checkout details


        session.setAttribute(
                "checkoutAddress",
                address
        );



        session.setAttribute(
                "checkoutPhone",
                phone
        );







        // Redirect to payment


        response.sendRedirect(
                request.getContextPath()
                + "/payment.jsp"
        );



    }









    // ================================
    // OPEN CHECKOUT PAGE
    // ================================

    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {




        HttpSession session =
                request.getSession();






        // Check user login

        User user =
                (User) session.getAttribute("user");



        if(user == null) {


            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );


            return;

        }






        // Get cart

        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>)
                        session.getAttribute("cart");







        // Prevent empty checkout


        if(cart == null || cart.isEmpty()) {



            response.sendRedirect(
                    request.getContextPath()
                    + "/menu.jsp"
            );


            return;

        }






        request.getRequestDispatcher(
                "/checkout.jsp"
        )
        .forward(request, response);



    }



}

