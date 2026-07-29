package com.tap.model;

public class PaymentMethodReport {

    private String paymentMode;
    private int transactionCount;
    private double totalAmount;
    private double percentage;

    public PaymentMethodReport() {
    }

    public PaymentMethodReport(String paymentMode, int transactionCount, double totalAmount, double percentage) {
        this.paymentMode = paymentMode;
        this.transactionCount = transactionCount;
        this.totalAmount = totalAmount;
        this.percentage = percentage;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }

    public int getTransactionCount() {
        return transactionCount;
    }

    public void setTransactionCount(int transactionCount) {
        this.transactionCount = transactionCount;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getPercentage() {
        return percentage;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }
}
