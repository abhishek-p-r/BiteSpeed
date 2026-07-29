package com.tap.model;


import java.sql.Timestamp;



public class Payment {


    private int paymentId;

    private int orderId;

    private double amount;

    private String paymentMethod;

    private String paymentStatus;

    private String transactionId;

    private Timestamp paymentDate;





    public Payment(){

    }






    // Constructor used in PaymentServlet

    public Payment(
            int orderId,
            String paymentMethod,
            double amount,
            String paymentStatus
    ){


        this.orderId = orderId;

        this.paymentMethod = paymentMethod;

        this.amount = amount;

        this.paymentStatus = paymentStatus;


        // COD does not have transaction id
        if(paymentMethod.equalsIgnoreCase("COD")){

            this.transactionId = "N/A";

        }
        else{

            this.transactionId = null;

        }


    }






    // Full constructor

    public Payment(
            int orderId,
            double amount,
            String paymentMethod,
            String paymentStatus,
            String transactionId
    ){


        this.orderId = orderId;

        this.amount = amount;

        this.paymentMethod = paymentMethod;

        this.paymentStatus = paymentStatus;

        this.transactionId = transactionId;


    }









    public int getPaymentId() {

        return paymentId;

    }


    public void setPaymentId(int paymentId) {

        this.paymentId = paymentId;

    }









    public int getOrderId() {

        return orderId;

    }


    public void setOrderId(int orderId) {

        this.orderId = orderId;

    }









    public double getAmount() {

        return amount;

    }


    public void setAmount(double amount) {

        this.amount = amount;

    }









    public String getPaymentMethod() {

        return paymentMethod;

    }


    public void setPaymentMethod(String paymentMethod) {

        this.paymentMethod = paymentMethod;

    }









    public String getPaymentStatus() {

        return paymentStatus;

    }


    public void setPaymentStatus(String paymentStatus) {

        this.paymentStatus = paymentStatus;

    }









    public String getTransactionId() {

        return transactionId;

    }


    public void setTransactionId(String transactionId) {

        this.transactionId = transactionId;

    }









    public Timestamp getPaymentDate() {

        return paymentDate;

    }


    public void setPaymentDate(Timestamp paymentDate) {

        this.paymentDate = paymentDate;

    }

    public void setStatus(String status) {
        this.paymentStatus = status;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.paymentDate = timestamp;
    }









    @Override
    public String toString(){


        return "Payment{" +

                "paymentId=" + paymentId +

                ", orderId=" + orderId +

                ", amount=" + amount +

                ", paymentMethod='" + paymentMethod + '\'' +

                ", paymentStatus='" + paymentStatus + '\'' +

                ", transactionId='" + transactionId + '\'' +

                ", paymentDate=" + paymentDate +

                '}';


    }


}