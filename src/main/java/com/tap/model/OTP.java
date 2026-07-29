package com.tap.model;

import java.sql.Timestamp;


public class OTP {


    private int otpId;

    private int userId;

    private String otpCode;

    private Timestamp expiryTime;

    private boolean isVerified;

    private Timestamp createdAt;



    public OTP(){}



    public int getOtpId() {
        return otpId;
    }


    public void setOtpId(int otpId) {
        this.otpId = otpId;
    }



    public int getUserId() {
        return userId;
    }


    public void setUserId(int userId) {
        this.userId = userId;
    }



    public String getOtpCode() {
        return otpCode;
    }


    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }



    public Timestamp getExpiryTime() {
        return expiryTime;
    }


    public void setExpiryTime(Timestamp expiryTime) {
        this.expiryTime = expiryTime;
    }



    public boolean isVerified() {
        return isVerified;
    }


    public void setVerified(boolean verified) {
        isVerified = verified;
    }



    public Timestamp getCreatedAt() {
        return createdAt;
    }


    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }



    @Override
    public String toString() {

        return "OTP{" +
                "otpId=" + otpId +
                ", userId=" + userId +
                ", otpCode='" + otpCode + '\'' +
                ", expiryTime=" + expiryTime +
                ", isVerified=" + isVerified +
                ", createdAt=" + createdAt +
                '}';

    }

}