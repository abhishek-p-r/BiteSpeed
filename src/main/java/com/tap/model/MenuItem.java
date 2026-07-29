package com.tap.model;

import java.sql.Timestamp;

public class MenuItem {

    private int menuItemId;

    private int restaurantId;

    private int categoryId;

    private String itemName;

    private String description;

    private double price;

    private String imageUrl;

    private boolean available;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    private Timestamp deletedAt;



    // Default Constructor
    public MenuItem() {

    }



    // Constructor for Add Menu Item
    public MenuItem(int restaurantId,
                    int categoryId,
                    String itemName,
                    String description,
                    double price,
                    String imageUrl,
                    boolean available) {

        this.restaurantId = restaurantId;
        this.categoryId = categoryId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.available = available;
    }



    // Full Constructor
    public MenuItem(int menuItemId,
                    int restaurantId,
                    int categoryId,
                    String itemName,
                    String description,
                    double price,
                    String imageUrl,
                    boolean available,
                    Timestamp createdAt,
                    Timestamp updatedAt,
                    Timestamp deletedAt) {

        this.menuItemId = menuItemId;
        this.restaurantId = restaurantId;
        this.categoryId = categoryId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.available = available;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
    }



    public int getMenuItemId() {
        return menuItemId;
    }


    public void setMenuItemId(int menuItemId) {
        this.menuItemId = menuItemId;
    }



    public int getRestaurantId() {
        return restaurantId;
    }


    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }



    public int getCategoryId() {
        return categoryId;
    }


    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }



    public String getItemName() {
        return itemName;
    }


    public void setItemName(String itemName) {
        this.itemName = itemName;
    }



    public String getDescription() {
        return description;
    }


    public void setDescription(String description) {
        this.description = description;
    }



    public double getPrice() {
        return price;
    }


    public void setPrice(double price) {
        this.price = price;
    }



    public String getImageUrl() {
        return imageUrl;
    }


    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }



    public boolean isAvailable() {
        return available;
    }


    public void setAvailable(boolean available) {
        this.available = available;
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

        return "MenuItem [menuItemId=" + menuItemId
                + ", restaurantId=" + restaurantId
                + ", categoryId=" + categoryId
                + ", itemName=" + itemName
                + ", description=" + description
                + ", price=" + price
                + ", imageUrl=" + imageUrl
                + ", available=" + available
                + "]";
    }

}