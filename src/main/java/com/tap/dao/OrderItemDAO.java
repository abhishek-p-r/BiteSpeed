package com.tap.dao;


import java.util.List;
import com.tap.model.OrderItem;



public interface OrderItemDAO {


    int addOrderItem(OrderItem orderItem);



    OrderItem getOrderItem(int orderItemId);



    List<OrderItem> getItemsByOrder(int orderId);



    List<OrderItem> getAllOrderItems();



    void updateOrderItem(OrderItem orderItem);



    void deleteOrderItem(int orderItemId);



    boolean orderItemExists(int orderItemId);


}