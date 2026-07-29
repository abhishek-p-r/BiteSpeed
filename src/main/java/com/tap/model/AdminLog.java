package com.tap.model;

import java.sql.Timestamp;

public class AdminLog {

    private int logId;
    private int adminId;
    private String action;
    private String description;
    private Timestamp logTime;

    // =========================
    // Default Constructor
    // =========================

    public AdminLog() {

    }

    // =========================
    // Constructor for Add Log
    // =========================

    public AdminLog(int adminId,
                    String action,
                    String description) {

        this.adminId = adminId;
        this.action = action;
        this.description = description;
    }

    // =========================
    // Full Constructor
    // =========================

    public AdminLog(int logId,
                    int adminId,
                    String action,
                    String description,
                    Timestamp logTime) {

        this.logId = logId;
        this.adminId = adminId;
        this.action = action;
        this.description = description;
        this.logTime = logTime;
    }

    // =========================
    // Getters & Setters
    // =========================

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getLogTime() {
        return logTime;
    }

    public void setLogTime(Timestamp logTime) {
        this.logTime = logTime;
    }

    @Override
    public String toString() {
        return "AdminLog [logId=" + logId
                + ", adminId=" + adminId
                + ", action=" + action
                + ", description=" + description
                + ", logTime=" + logTime
                + "]";
    }
}