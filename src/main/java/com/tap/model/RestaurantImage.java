package com.tap.model;

import java.sql.Timestamp;

public class RestaurantImage {


    private int imageId;

    private int restaurantId;

    private String imageUrl;

    private String imageType;

    private int displayOrder;

    private Timestamp createdAt;



    // Default Constructor
    public RestaurantImage() {

    }



    // Constructor For Add Image

    public RestaurantImage(int restaurantId,
                           String imageUrl,
                           String imageType,
                           int displayOrder) {

        this.restaurantId = restaurantId;
        this.imageUrl = imageUrl;
        this.imageType = imageType;
        this.displayOrder = displayOrder;
    }



    // Full Constructor

    public RestaurantImage(int imageId,
                           int restaurantId,
                           String imageUrl,
                           String imageType,
                           int displayOrder,
                           Timestamp createdAt) {

        this.imageId = imageId;
        this.restaurantId = restaurantId;
        this.imageUrl = imageUrl;
        this.imageType = imageType;
        this.displayOrder = displayOrder;
        this.createdAt = createdAt;
    }





    public int getImageId() {
        return imageId;
    }


    public void setImageId(int imageId) {
        this.imageId = imageId;
    }



    public int getRestaurantId() {
        return restaurantId;
    }


    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }



    public String getImageUrl() {
        return imageUrl;
    }


    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }



    public String getImageType() {
        return imageType;
    }


    public void setImageType(String imageType) {
        this.imageType = imageType;
    }



    public int getDisplayOrder() {
        return displayOrder;
    }


    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }



    public Timestamp getCreatedAt() {
        return createdAt;
    }


    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }





    @Override
    public String toString() {

        return "RestaurantImage [imageId="
                + imageId
                + ", restaurantId="
                + restaurantId
                + ", imageUrl="
                + imageUrl
                + ", imageType="
                + imageType
                + ", displayOrder="
                + displayOrder
                + "]";
    }

}