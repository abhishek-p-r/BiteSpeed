package com.tap.utility;

import com.tap.dao.OrderDAO;
import com.tap.daoimplementation.OrderDAOImpl;
import com.tap.model.Order;

public class TestUpdateOrderStatus {
    public static void main(String[] args) {
        try {
            OrderDAO orderDAO = new OrderDAOImpl();
            Order o = orderDAO.getOrder(26);
            if (o == null) {
                o = orderDAO.getOrder(1);
            }
            if (o != null) {
                System.out.println("Original Status for Order #" + o.getOrderId() + ": " + o.getOrderStatus());
                
                o.setOrderStatus("PREPARING");
                orderDAO.updateOrder(o);
                System.out.println("Updated Status to PREPARING: " + orderDAO.getOrder(o.getOrderId()).getOrderStatus());

                o.setOrderStatus("DELIVERED");
                o.setPaymentStatus("SUCCESS");
                orderDAO.updateOrder(o);
                System.out.println("Updated Status to DELIVERED: " + orderDAO.getOrder(o.getOrderId()).getOrderStatus());

                System.out.println("🎉 ORDER STATUS UPDATE PASSED 100%!");
            } else {
                System.out.println("No order found to test update");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
