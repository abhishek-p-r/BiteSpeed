package com.tap.model;

import java.sql.Timestamp;

public class EmailOTP {

    private int otpId;
    private String email;
    private String otp;
    private Timestamp expiryTime;

    // Default Constructor
    public EmailOTP() {

    }

    // Constructor
    public EmailOTP(String email, String otp, Timestamp expiryTime) {
        this.email = email;
        this.otp = otp;
        this.expiryTime = expiryTime;
    }

    // Full Constructor
    public EmailOTP(int otpId, String email, String otp, Timestamp expiryTime) {
        this.otpId = otpId;
        this.email = email;
        this.otp = otp;
        this.expiryTime = expiryTime;
    }

    public int getOtpId() {
        return otpId;
    }

    public void setOtpId(int otpId) {
        this.otpId = otpId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public Timestamp getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(Timestamp expiryTime) {
        this.expiryTime = expiryTime;
    }

    @Override
    public String toString() {
        return "EmailOTP [otpId=" + otpId +
                ", email=" + email +
                ", otp=" + otp +
                ", expiryTime=" + expiryTime + "]";
    }
}