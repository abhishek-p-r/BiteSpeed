package com.tap.model;

public class DeliveryAgent {

    private int agentId;
    private String fullName;
    private String phone;
    private String email;
    private String vehicleNumber;
    private String vehicleType;
    private String status;

    // ==========================
    // Default Constructor
    // ==========================

    public DeliveryAgent() {

    }

    // ==========================
    // Constructor for Add
    // ==========================

    public DeliveryAgent(String fullName,
                         String phone,
                         String email,
                         String vehicleNumber,
                         String vehicleType,
                         String status) {

        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.vehicleNumber = vehicleNumber;
        this.vehicleType = vehicleType;
        this.status = status;
    }

    // ==========================
    // Full Constructor
    // ==========================

    public DeliveryAgent(int agentId,
                         String fullName,
                         String phone,
                         String email,
                         String vehicleNumber,
                         String vehicleType,
                         String status) {

        this.agentId = agentId;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.vehicleNumber = vehicleNumber;
        this.vehicleType = vehicleType;
        this.status = status;
    }

    // ==========================
    // Getters & Setters
    // ==========================

    public int getAgentId() {
        return agentId;
    }

    public void setAgentId(int agentId) {
        this.agentId = agentId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getVehicleNumber() {
        return vehicleNumber;
    }

    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // ==========================
    // toString()
    // ==========================

    @Override
    public String toString() {

        return "DeliveryAgent [agentId=" + agentId
                + ", fullName=" + fullName
                + ", phone=" + phone
                + ", email=" + email
                + ", vehicleNumber=" + vehicleNumber
                + ", vehicleType=" + vehicleType
                + ", status=" + status
                + "]";
    }
}