package com.tap.model;

import java.sql.Timestamp;

public class Admin {

    private int adminId;
    private String name;
    private String username;
    private String email;
    private String password;
    private String phoneNumber;
    private String role;
    private boolean active;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // =========================
    // Default Constructor
    // =========================

    public Admin() {

    }

    // =========================
    // Constructor for Add Admin
    // =========================

    public Admin(String name,
                 String username,
                 String email,
                 String password,
                 String phoneNumber,
                 String role,
                 boolean active) {

        this.name = name;
        this.username = username;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.active = active;
    }

    // =========================
    // Full Constructor
    // =========================

    public Admin(int adminId,
                 String name,
                 String username,
                 String email,
                 String password,
                 String phoneNumber,
                 String role,
                 boolean active,
                 Timestamp createdAt,
                 Timestamp updatedAt) {

        this.adminId = adminId;
        this.name = name;
        this.username = username;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.active = active;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // =========================
    // Getters & Setters
    // =========================

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Admin [adminId=" + adminId
                + ", name=" + name
                + ", username=" + username
                + ", email=" + email
                + ", phoneNumber=" + phoneNumber
                + ", role=" + role
                + ", active=" + active
                + "]";
    }
}