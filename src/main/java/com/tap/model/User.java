package com.tap.model;

import java.sql.Date;
import java.sql.Timestamp;

public class User {

    private int userId;

    private String fullName;
    private String email;
    private String phone;
    private String password;

    private String gender;
    private Date dob;

    private String profileImage;
    private String status;

    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    private String role;

    public User(String role) {
		super();
		this.role = role;
	}

	// =========================
    // Default Constructor
    // =========================

    public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public User() {

    }

    // =========================
    // Constructor (Insert)
    // =========================

    public User(String fullName,
                String email,
                String phone,
                String password,
                String gender,
                Date dob,
                String profileImage,
                String status) {

        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.gender = gender;
        this.dob = dob;
        this.profileImage = profileImage;
        this.status = status;
    }

    // =========================
    // Full Constructor
    // =========================

    public User(int userId,
                String fullName,
                String email,
                String phone,
                String password,
                String gender,
                Date dob,
                String profileImage,
                String status,
                Timestamp createdAt,
                Timestamp updatedAt) {

        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.gender = gender;
        this.dob = dob;
        this.profileImage = profileImage;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // =========================
    // Getters & Setters
    // =========================

    public int getUserId() {
        return userId;
    }

    public int getId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public String getName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public Timestamp getLastLogin() {
        return updatedAt != null ? updatedAt : createdAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
	public String toString() {
		return "User [role=" + role + "]";
	}

	
}