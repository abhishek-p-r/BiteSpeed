package com.tap.model;

import java.sql.Timestamp;

public class AuthToken {

    private int tokenId;
    private int userId;
    private String token;
    private Timestamp expiryTime;
    private boolean active;

    // =========================
    // Default Constructor
    // =========================

    public AuthToken() {

    }

    // =========================
    // Constructor for Save Token
    // =========================

    public AuthToken(int userId,
                     String token,
                     Timestamp expiryTime,
                     boolean active) {

        this.userId = userId;
        this.token = token;
        this.expiryTime = expiryTime;
        this.active = active;
    }

    // =========================
    // Full Constructor
    // =========================

    public AuthToken(int tokenId,
                     int userId,
                     String token,
                     Timestamp expiryTime,
                     boolean active) {

        this.tokenId = tokenId;
        this.userId = userId;
        this.token = token;
        this.expiryTime = expiryTime;
        this.active = active;
    }

    // =========================
    // Getters & Setters
    // =========================

    public int getTokenId() {
        return tokenId;
    }

    public void setTokenId(int tokenId) {
        this.tokenId = tokenId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(Timestamp expiryTime) {
        this.expiryTime = expiryTime;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    @Override
    public String toString() {
        return "AuthToken [tokenId=" + tokenId
                + ", userId=" + userId
                + ", token=" + token
                + ", expiryTime=" + expiryTime
                + ", active=" + active
                + "]";
    }
}