package com.tap.model;

import java.sql.Timestamp;

public class LoginHistory {

    private int loginHistoryId;
    private int userId;
    private Timestamp loginTime;
    private Timestamp logoutTime;
    private String ipAddress;
    private String deviceInfo;
    private String loginStatus;

    public LoginHistory() {}

    public int getLoginHistoryId() { return loginHistoryId; }
    public void setLoginHistoryId(int loginHistoryId) { this.loginHistoryId = loginHistoryId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getLoginTime() { return loginTime; }
    public void setLoginTime(Timestamp loginTime) { this.loginTime = loginTime; }

    public Timestamp getLogoutTime() { return logoutTime; }
    public void setLogoutTime(Timestamp logoutTime) { this.logoutTime = logoutTime; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public String getDeviceInfo() { return deviceInfo; }
    public void setDeviceInfo(String deviceInfo) { this.deviceInfo = deviceInfo; }

    public String getLoginStatus() { return loginStatus; }
    public void setLoginStatus(String loginStatus) { this.loginStatus = loginStatus; }
}