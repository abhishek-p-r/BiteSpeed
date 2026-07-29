package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.OrderDAOImpl;
import com.tap.model.Order;



public class OrderTest {


    public static void main(String[] args) {


        OrderDAOImpl dao = new OrderDAOImpl();



        Order order = new Order();



        order.setUserId(1);

        order.setAddressId(1);

        order.setTotalAmount(500);

        order.setOrderStatus("PLACED");



        dao.addOrder(order);



//
//
//        Order result = dao.getOrder(1);
//
//
//        System.out.println(result);
//
//
//
//
//
//
//        List<Order> orders =
//                dao.getAllOrders();
//
//
//
//        for(Order o : orders){
//
//            System.out.println(o);
//
//        }
//
//
//
//
//
//
//
//        Order update =
//                dao.getOrder(1);
//
//
//
//        if(update != null){
//
//
//            update.setOrderStatus("DELIVERED");
//
//
//            dao.updateOrder(update);
//
//        }
//
//
//
//
//
//
//        // dao.cancelOrder(1);



    }

}