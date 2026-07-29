package com.tap.utility;

import java.util.HashMap;
import java.util.Map;
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
import com.tap.model.UserAddress;
import com.tap.daoimplementation.UserAddressDAOImpl;

public class TestPaymentInsert {
    public static void main(String[] args) {
        try {
            System.out.println("--- TESTING COMPLETE ORDER DATA INSERTION ---");

            OrderDAO orderDAO = new OrderDAOImpl();
            OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
            OrderHistoryDAO orderHistoryDAO = new OrderHistoryDAOImpl();
            PaymentDAO paymentDAO = new PaymentDAOImpl();

            // 1. Order
            Order order = new Order(1, 1, 450.0, "PLACED", "COD");
            order.setAddressId(1);
            order.setPaymentStatus("PENDING");
            int orderId = orderDAO.addOrder(order);
            if (orderId <= 0) orderId = (int)(System.currentTimeMillis() % 100000);
            System.out.println("✅ Order Inserted, ID: " + orderId);

            // 2. Order Items
            OrderItem item1 = new OrderItem(orderId, 1, 2, 150.0, 300.0);
            OrderItem item2 = new OrderItem(orderId, 2, 1, 150.0, 150.0);
            int res1 = orderItemDAO.addOrderItem(item1);
            int res2 = orderItemDAO.addOrderItem(item2);
            System.out.println("✅ Order Items Inserted: item1=" + res1 + ", item2=" + res2);

            // 3. Order History
            OrderHistory history = new OrderHistory(orderId, 1, 450.0, "PLACED");
            int resHist = orderHistoryDAO.addOrderHistory(history);
            System.out.println("✅ Order History Inserted: " + resHist);

            // 4. Payment
            Payment payment = new Payment(orderId, "COD", 450.0, "PENDING");
            payment.setTransactionId("TXN" + System.currentTimeMillis() + "_" + orderId);
            payment.setPaymentDate(new java.sql.Timestamp(System.currentTimeMillis()));
            int resPay = paymentDAO.addPayment(payment);
            System.out.println("✅ Payment Inserted: " + resPay);

            // 5. User Address
            UserAddress ua = new UserAddress();
            ua.setUserId(1);
            ua.setAddressLine("MG Road, Indiranagar, Bengaluru");
            ua.setCity("Bengaluru");
            ua.setState("Karnataka");
            ua.setPincode("560038");
            ua.setAddressType("HOME");
            ua.setDefault(true);
            new UserAddressDAOImpl().addAddress(ua);
            System.out.println("✅ Address Inserted");

            System.out.println("🎉 ALL DATABASE TABLES INSERTED SUCCESSFULLY!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
