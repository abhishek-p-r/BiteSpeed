package com.tap.dao;


import java.util.List;

import com.tap.model.OrderHistory;


public interface OrderHistoryDAO {


    int addOrderHistory(OrderHistory history);

    OrderHistory getOrderHistory(int historyId);

    List<OrderHistory> getOrderHistoryByUserId(int userId);

    List<OrderHistory> getAllOrderHistories();


}