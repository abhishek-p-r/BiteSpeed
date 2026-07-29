package com.tap.model;

import java.sql.Timestamp;


public class OrderHistory {


    private int historyId;

    private int orderId;

    private int userId;

    private double totalAmount;

    private String status;

    private Timestamp createdDate;



    public OrderHistory() {

    }




    public OrderHistory(int orderId,
                        int userId,
                        double totalAmount,
                        String status) {


        this.orderId = orderId;

        this.userId = userId;

        this.totalAmount = totalAmount;

        this.status = status;

    }





    public int getHistoryId() {
        return historyId;
    }


    public void setHistoryId(int historyId) {
        this.historyId = historyId;
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



    public double getTotalAmount() {
        return totalAmount;
    }


    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }



    public String getStatus() {
        return status;
    }


    public void setStatus(String status) {
        this.status = status;
    }



    public Timestamp getCreatedDate() {
        return createdDate;
    }


    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }


}