package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.OrderItemDAOImpl;
import com.tap.model.OrderItem;



public class OrderItemTest {


    public static void main(String[] args) {



        OrderItemDAOImpl dao =
                new OrderItemDAOImpl();




        OrderItem item = new OrderItem();



        item.setOrderId(1);

        item.setMenuId(1);

        item.setQuantity(2);

        item.setPrice(250);



        dao.addOrderItem(item);






        System.out.println(
                dao.getOrderItem(1)
        );







        List<OrderItem> items =
                dao.getAllOrderItems();



        for(OrderItem i : items){

            System.out.println(i);

        }







        OrderItem update =
                dao.getOrderItem(1);



        if(update != null){


            update.setQuantity(4);


            dao.updateOrderItem(update);


        }







        // dao.deleteOrderItem(1);



        System.out.println(
                "Exists : " + dao.orderItemExists(1)
        );

    }

}