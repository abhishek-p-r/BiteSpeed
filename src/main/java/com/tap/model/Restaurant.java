package com.tap.model;

import java.sql.Timestamp;

public class Restaurant {

    private int restaurantId;
    private int ownerId;

    private String restaurantName;
    private String description;
    private String cuisineType;

    private String phone;
    private String email;

    private String address;
    private String city;
    private String state;
    private String pincode;

    private String openingTime;
    private String closingTime;

    private String image;

    private double rating;

    private boolean active;

    private Timestamp createdAt;
    private Timestamp updatedAt;


    // Default Constructor
    public Restaurant() {

    }


    // Constructor For Adding Restaurant
    public Restaurant(int ownerId,
                      String restaurantName,
                      String description,
                      String cuisineType,
                      String phone,
                      String email,
                      String address,
                      String city,
                      String state,
                      String pincode,
                      String openingTime,
                      String closingTime,
                      String image,
                      double rating,
                      boolean active) {

        this.ownerId = ownerId;
        this.restaurantName = restaurantName;
        this.description = description;
        this.cuisineType = cuisineType;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.openingTime = openingTime;
        this.closingTime = closingTime;
        this.image = image;
        this.rating = rating;
        this.active = active;
    }


    // Full Constructor
    public Restaurant(int restaurantId,
                      int ownerId,
                      String restaurantName,
                      String description,
                      String cuisineType,
                      String phone,
                      String email,
                      String address,
                      String city,
                      String state,
                      String pincode,
                      String openingTime,
                      String closingTime,
                      String image,
                      double rating,
                      boolean active,
                      Timestamp createdAt,
                      Timestamp updatedAt) {

        this.restaurantId = restaurantId;
        this.ownerId = ownerId;
        this.restaurantName = restaurantName;
        this.description = description;
        this.cuisineType = cuisineType;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.openingTime = openingTime;
        this.closingTime = closingTime;
        this.image = image;
        this.rating = rating;
        this.active = active;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }


    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }


    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }


    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
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


    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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


    public String getOpeningTime() {
        return openingTime;
    }

    public void setOpeningTime(String openingTime) {
        this.openingTime = openingTime;
    }


    public String getClosingTime() {
        return closingTime;
    }

    public void setClosingTime(String closingTime) {
        this.closingTime = closingTime;
    }


    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }


    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
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

    public String getDeliveryTime() {
        return (openingTime != null && closingTime != null) ? openingTime + " - " + closingTime : "30 mins";
    }


    @Override
    public String toString() {

        return "Restaurant [restaurantId=" + restaurantId
                + ", ownerId=" + ownerId
                + ", restaurantName=" + restaurantName
                + ", cuisineType=" + cuisineType
                + ", city=" + city
                + ", rating=" + rating
                + ", active=" + active
                + "]";
    }
}