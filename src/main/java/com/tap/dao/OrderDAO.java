package com.tap.dao;

import java.util.List;
import com.tap.model.DailyReport;
import com.tap.model.Order;
import com.tap.model.PaymentMethodReport;
import com.tap.model.RestaurantProfitReport;


public interface OrderDAO {


    int addOrder(Order order);



    Order getOrder(int orderId);



    List<Order> getOrdersByUser(int userId);



    List<Order> getAllOrders();

    List<Order> getOrdersByRestaurantId(int restaurantId);

    void updateOrder(Order order);



    void cancelOrder(int orderId);

    List<DailyReport> getDailyAnalysisReports();

    List<RestaurantProfitReport> getRestaurantProfitReports();

    List<PaymentMethodReport> getPaymentMethodReports();


}