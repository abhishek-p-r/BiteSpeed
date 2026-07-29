package com.tap.model;

public class Address {

    private int addressId;
    private int userId;

    private String addressLine1;
    private String addressLine2;

    private String city;
    private String state;
    private String pincode;

    private String landmark;
    private boolean isDefault;

    // =========================
    // Default Constructor
    // =========================

    public Address() {

    }

    // =========================
    // Constructor for Add Address
    // =========================

    public Address(int userId,
                   String addressLine1,
                   String addressLine2,
                   String city,
                   String state,
                   String pincode,
                   String landmark,
                   boolean isDefault) {

        this.userId = userId;
        this.addressLine1 = addressLine1;
        this.addressLine2 = addressLine2;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.landmark = landmark;
        this.isDefault = isDefault;
    }

    // =========================
    // Full Constructor
    // =========================

    public Address(int addressId,
                   int userId,
                   String addressLine1,
                   String addressLine2,
                   String city,
                   String state,
                   String pincode,
                   String landmark,
                   boolean isDefault) {

        this.addressId = addressId;
        this.userId = userId;
        this.addressLine1 = addressLine1;
        this.addressLine2 = addressLine2;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.landmark = landmark;
        this.isDefault = isDefault;
    }

    // =========================
    // Getters & Setters
    // =========================

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public String getLandmark() {
        return landmark;
    }

    public void setLandmark(String landmark) {
        this.landmark = landmark;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    // =========================
    // toString()
    // =========================

    @Override
    public String toString() {
        return "Address [addressId=" + addressId
                + ", userId=" + userId
                + ", addressLine1=" + addressLine1
                + ", addressLine2=" + addressLine2
                + ", city=" + city
                + ", state=" + state
                + ", pincode=" + pincode
                + ", landmark=" + landmark
                + ", isDefault=" + isDefault
                + "]";
    }
}