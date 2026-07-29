package com.tap.model;

import java.sql.Timestamp;


public class UserCoupon {


    private int id;

    private int userId;

    private int couponId;

    private boolean used;

    private Timestamp assignedAt;



    public UserCoupon(){}




    public int getId() {
        return id;
    }


    public void setId(int id) {
        this.id = id;
    }



    public int getUserId() {
        return userId;
    }


    public void setUserId(int userId) {
        this.userId = userId;
    }



    public int getCouponId() {
        return couponId;
    }


    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }



    public boolean isUsed() {
        return used;
    }


    public void setUsed(boolean used) {
        this.used = used;
    }



    public Timestamp getAssignedAt() {
        return assignedAt;
    }


    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
    }



    @Override
    public String toString() {

        return "UserCoupon [id="
                + id
                + ", userId="
                + userId
                + ", couponId="
                + couponId
                + ", used="
                + used
                + ", assignedAt="
                + assignedAt
                + "]";

    }

}