package com.tap.model;

import java.sql.Timestamp;


public class Order {


    private int orderId;

    private int userId;

    private int restaurantId;

    private int addressId;

    private double totalAmount;

    private String orderStatus;

    private String paymentMode;

    private String paymentStatus;

    private Timestamp orderDate;




    public Order() {

    }






    public Order(
            int userId,
            int restaurantId,
            double totalAmount,
            String orderStatus,
            String paymentMode
    ) {


        this.userId = userId;

        this.restaurantId = restaurantId;

        this.totalAmount = totalAmount;

        this.orderStatus = orderStatus;

        this.paymentMode = paymentMode;


    }







    public int getOrderId() {

        return orderId;

    }


    public void setOrderId(int orderId) {

        this.orderId = orderId;

    }








    public int getUserId() {

        return userId;

    }


    public void setUserId(int userId) {

        this.userId = userId;

    }








    public int getRestaurantId() {

        return restaurantId;

    }


    public void setRestaurantId(int restaurantId) {

        this.restaurantId = restaurantId;

    }








    public int getAddressId() {

        return addressId;

    }


    public void setAddressId(int addressId) {

        this.addressId = addressId;

    }








    public double getTotalAmount() {

        return totalAmount;

    }


    public void setTotalAmount(double totalAmount) {

        this.totalAmount = totalAmount;

    }








    public String getOrderStatus() {

        return orderStatus;

    }


    public void setOrderStatus(String orderStatus) {

        this.orderStatus = orderStatus;

    }








    public String getPaymentMode() {

        return paymentMode;

    }


    public void setPaymentMode(String paymentMode) {

        this.paymentMode = paymentMode;

    }








    public String getPaymentStatus() {

        return paymentStatus;

    }


    public void setPaymentStatus(String paymentStatus) {

        this.paymentStatus = paymentStatus;

    }








    public Timestamp getOrderDate() {

        return orderDate;

    }


    public void setOrderDate(Timestamp orderDate) {

        this.orderDate = orderDate;

    }








    @Override
    public String toString() {


        return "Order{" +

                "orderId=" + orderId +

                ", userId=" + userId +

                ", restaurantId=" + restaurantId +

                ", addressId=" + addressId +

                ", totalAmount=" + totalAmount +

                ", orderStatus='" + orderStatus + '\'' +

                ", paymentMode='" + paymentMode + '\'' +

                ", paymentStatus='" + paymentStatus + '\'' +

                ", orderDate=" + orderDate +

                '}';


    }


}