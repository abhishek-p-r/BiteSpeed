package com.tap.model;

import java.sql.Date;

public class Coupon {

    private int couponId;
    private String couponCode;
    private double discountPercentage;
    private Date expiryDate;
    private double minimumOrderAmount;
    private boolean active;

    // =========================
    // Default Constructor
    // =========================

    public Coupon() {

    }

    // =========================
    // Constructor for Add Coupon
    // =========================

    public Coupon(String couponCode,
                  double discountPercentage,
                  Date expiryDate,
                  double minimumOrderAmount,
                  boolean active) {

        this.couponCode = couponCode;
        this.discountPercentage = discountPercentage;
        this.expiryDate = expiryDate;
        this.minimumOrderAmount = minimumOrderAmount;
        this.active = active;
    }

    // =========================
    // Full Constructor
    // =========================

    public Coupon(int couponId,
                  String couponCode,
                  double discountPercentage,
                  Date expiryDate,
                  double minimumOrderAmount,
                  boolean active) {

        this.couponId = couponId;
        this.couponCode = couponCode;
        this.discountPercentage = discountPercentage;
        this.expiryDate = expiryDate;
        this.minimumOrderAmount = minimumOrderAmount;
        this.active = active;
    }

    // =========================
    // Getters & Setters
    // =========================

    public int getCouponId() {
        return couponId;
    }

    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public double getMinimumOrderAmount() {
        return minimumOrderAmount;
    }

    public void setMinimumOrderAmount(double minimumOrderAmount) {
        this.minimumOrderAmount = minimumOrderAmount;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    @Override
    public String toString() {
        return "Coupon [couponId=" + couponId
                + ", couponCode=" + couponCode
                + ", discountPercentage=" + discountPercentage
                + ", expiryDate=" + expiryDate
                + ", minimumOrderAmount=" + minimumOrderAmount
                + ", active=" + active
                + "]";
    }
}