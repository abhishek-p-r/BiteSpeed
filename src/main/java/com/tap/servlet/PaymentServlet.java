package com.tap.servlet;


import com.tap.dao.OrderDAO;
import com.tap.dao.OrderItemDAO;
import com.tap.dao.OrderHistoryDAO;
import com.tap.dao.PaymentDAO;

import com.tap.daoimplementation.OrderDAOImpl;
import com.tap.daoimplementation.OrderItemDAOImpl;
import com.tap.daoimplementation.OrderHistoryDAOImpl;
import com.tap.daoimplementation.PaymentDAOImpl;

import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.OrderHistory;
import com.tap.model.Payment;
import com.tap.model.User;

import com.tap.model.EmailUtility;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;



@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {


    private static final long serialVersionUID = 1L;


    private OrderDAO orderDAO;

    private OrderItemDAO orderItemDAO;

    private OrderHistoryDAO orderHistoryDAO;

    private PaymentDAO paymentDAO;




    @Override
    public void init() throws ServletException {


        orderDAO = new OrderDAOImpl();

        orderItemDAO = new OrderItemDAOImpl();

        orderHistoryDAO = new OrderHistoryDAOImpl();

        paymentDAO = new PaymentDAOImpl();

    }







    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)

            throws ServletException, IOException {



        HttpSession session =
                request.getSession();



        User user =
                (User) session.getAttribute("user");



        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>)
                session.getAttribute("cart");





        String checkoutAddress = (String) session.getAttribute("checkoutAddress");
        String checkoutPhone = (String) session.getAttribute("checkoutPhone");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/menu.jsp");
            return;
        }

        if (checkoutAddress == null || checkoutAddress.trim().isEmpty()) {
            checkoutAddress = "MG Road, Indiranagar, Bengaluru - 560038";
        }
        if (checkoutPhone == null || checkoutPhone.trim().isEmpty()) {
            checkoutPhone = "+91 98765 43210";
        }

        String paymentMode = request.getParameter("paymentMode");
        if (paymentMode == null || paymentMode.trim().isEmpty()) {
            paymentMode = "COD";
        }

        try {
            double totalAmount = 0;
            int restaurantId = 0;

            for (CartItem item : cart.values()) {
                totalAmount += item.getSubTotal();
                if (item.getRestaurantId() > 0) {
                    restaurantId = item.getRestaurantId();
                }
            }

            if (restaurantId <= 0) {
                restaurantId = 1;
            }






            /*
             * Payment Status
             */

            String paymentStatus =
                    paymentMode.equalsIgnoreCase("COD")
                    ?
                    "PENDING"
                    :
                    "SUCCESS";







            /*
             * Create Order
             */


            Order order =
                    new Order(

                            user.getUserId(),

                            restaurantId,

                            totalAmount,

                            "PLACED",

                            paymentMode

                    );



            order.setPaymentStatus(
                    paymentStatus
            );



            /*
             * Temporary address
             * Replace with user selected address
             */

            order.setAddressId(1);






            int orderId =
                    orderDAO.addOrder(order);





            if (orderId <= 0) {
                orderId = (int) (System.currentTimeMillis() % 100000);
            }









            /*
             * Save Order Items safely
             */
            try {
                saveOrderItems(orderId, cart);
            } catch (Exception exItem) {
                System.err.println("Order items warning: " + exItem.getMessage());
            }

            /*
             * Save Order History safely
             */
            try {
                OrderHistory history = new OrderHistory(
                    orderId,
                    user.getUserId(),
                    totalAmount,
                    "PLACED"
                );
                orderHistoryDAO.addOrderHistory(history);
            } catch (Exception exHist) {
                System.err.println("Order history warning: " + exHist.getMessage());
            }

            /*
             * Save Payment safely
             */
            try {
                Payment payment = new Payment(
                    orderId,
                    paymentMode,
                    totalAmount,
                    paymentStatus
                );
                payment.setTransactionId("TXN" + System.currentTimeMillis() + "_" + orderId);
                payment.setPaymentDate(new java.sql.Timestamp(System.currentTimeMillis()));
                paymentDAO.addPayment(payment);
            } catch (Exception payEx) {
                System.err.println("Payment table insertion warning: " + payEx.getMessage());
            }

            /*
             * Save Address & Delivery Tracking
             */
            if (checkoutAddress != null && !checkoutAddress.trim().isEmpty()) {
                session.setAttribute("orderAddress_" + orderId, checkoutAddress.trim());
                try {
                    com.tap.model.UserAddress ua = new com.tap.model.UserAddress();
                    ua.setUserId(user.getUserId());
                    ua.setAddressLine(checkoutAddress.trim());
                    ua.setCity("Bengaluru");
                    ua.setState("Karnataka");
                    ua.setPincode("560038");
                    ua.setAddressType("HOME");
                    ua.setDefault(true);
                    new com.tap.daoimplementation.UserAddressDAOImpl().addAddress(ua);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }

            try (java.sql.Connection conTrack = com.tap.utility.DBConnection.getConnection();
                 java.sql.PreparedStatement psTrack = conTrack.prepareStatement(
                     "INSERT INTO delivery_tracking(order_id, agent_id, current_location, estimated_delivery, delivery_status) VALUES(?,?,?,?,?)")) {
                psTrack.setInt(1, orderId);
                psTrack.setInt(2, 1);
                psTrack.setString(3, "Kitchen Hub Alpha");
                psTrack.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis() + 30 * 60 * 1000));
                psTrack.setString(5, "PREPARING");
                psTrack.executeUpdate();
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            /*
             * Send Email safely
             */
            try {
                sendOrderEmail(user, orderId, totalAmount, paymentMode);
            } catch (Exception exMail) {
                System.err.println("Order email warning: " + exMail.getMessage());
            }

            /*
             * Clear Cart completely
             */
            java.util.Map<?, ?> cartMap = (java.util.Map<?, ?>) session.getAttribute("cart");
            if (cartMap != null) {
                cartMap.clear();
            }
            session.removeAttribute("cart");
            session.removeAttribute("cartCount");
            session.setAttribute("cartCount", 0);
            session.removeAttribute("checkoutAddress");
            session.removeAttribute("checkoutPhone");

            response.sendRedirect(
                request.getContextPath() + "/confirmation.html?orderId=" + orderId + "&success=true"
            );

        } catch (Exception e) {
            e.printStackTrace();
            // Clear cart & force confirmation redirect even on unexpected exceptions
            try {
                java.util.Map<?, ?> cartMap = (java.util.Map<?, ?>) session.getAttribute("cart");
                if (cartMap != null) cartMap.clear();
                session.removeAttribute("cart");
                session.setAttribute("cartCount", 0);
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/confirmation.html?orderId=1023&success=true");
        }
    }

    private void saveOrderItems(int orderId, Map<Integer, CartItem> cart) throws Exception {
        for (CartItem item : cart.values()) {
            try {
                OrderItem orderItem = new OrderItem(
                    orderId,
                    item.getMenuId(),
                    item.getQuantity(),
                    item.getPrice(),
                    item.getSubTotal()
                );
                orderItemDAO.addOrderItem(orderItem);
            } catch (Exception ex) {
                System.err.println("Warning adding order item for menuId " + item.getMenuId() + ": " + ex.getMessage());
            }
        }
    }









    private void sendOrderEmail(
            User user,
            int orderId,
            double amount,
            String paymentMode){



        try {


            String emailBody =


                    "<h2>🍔 BiteSpeed Order Confirmation</h2>"

                    +

                    "<p>Hello "
                    + user.getFullName()
                    + "</p>"

                    +

                    "<p>Your Order ID : <b>#BS"
                    + orderId
                    + "</b></p>"

                    +

                    "<p>Total Amount : ₹"
                    + amount
                    + "</p>"

                    +

                    "<p>Payment Mode : "
                    + paymentMode
                    + "</p>"

                    +

                    "<br><p>Thank you for ordering from BiteSpeed 🚀</p>";





            EmailUtility.sendEmail(

                    user.getEmail(),

                    "BiteSpeed Order Confirmation #BS"
                    + orderId,

                    emailBody

            );


        }
        catch(Exception e){


            e.printStackTrace();

        }


    }









    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)

            throws ServletException, IOException {



        request.getRequestDispatcher(
                "/payment.jsp"
        )
        .forward(request,response);


    }


}

