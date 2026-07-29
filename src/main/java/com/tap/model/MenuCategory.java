package com.tap.model;

import java.sql.Timestamp;

public class MenuCategory {


    private int categoryId;

    private int restaurantId;

    private String categoryName;

    private String description;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    private Timestamp deletedAt;



    // Default Constructor
    public MenuCategory() {

    }



    // Constructor for Add Category
    public MenuCategory(int restaurantId,
                        String categoryName,
                        String description) {

        this.restaurantId = restaurantId;
        this.categoryName = categoryName;
        this.description = description;
    }



    // Full Constructor
    public MenuCategory(int categoryId,
                        int restaurantId,
                        String categoryName,
                        String description,
                        Timestamp createdAt,
                        Timestamp updatedAt,
                        Timestamp deletedAt) {

        this.categoryId = categoryId;
        this.restaurantId = restaurantId;
        this.categoryName = categoryName;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
    }



    public int getCategoryId() {
        return categoryId;
    }


    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }



    public int getRestaurantId() {
        return restaurantId;
    }


    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }



    public String getCategoryName() {
        return categoryName;
    }


    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }



    public String getDescription() {
        return description;
    }


    public void setDescription(String description) {
        this.description = description;
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



    public Timestamp getDeletedAt() {
        return deletedAt;
    }


    public void setDeletedAt(Timestamp deletedAt) {
        this.deletedAt = deletedAt;
    }



    @Override
    public String toString() {

        return "MenuCategory [categoryId=" + categoryId
                + ", restaurantId=" + restaurantId
                + ", categoryName=" + categoryName
                + ", description=" + description
                + "]";
    }

}