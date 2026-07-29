package com.tap.model;

import java.sql.Timestamp;

public class Menu {

    private int menuId;
    private int restaurantId;
    
    private String image;

    private String itemName;
    private String description;

    private double price;

    private boolean available;

    private String category;

    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp deletedAt;

    private double rating;

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }
    
    // Default Constructor
    public Menu() {

    }

    // Constructor for Add Menu
    public Menu(int restaurantId,
                String itemName,
                String description,
                double price,
                boolean available,
                String category, String image) {

        this.restaurantId = restaurantId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.available = available;
        this.image = image;
        this.category = category;
    }

    // Full Constructor
    public Menu(int menuId,
                int restaurantId,
                String itemName,
                String description,
                double price,
                boolean available,
                String category,
                Timestamp createdAt,
                Timestamp updatedAt,
                Timestamp deletedAt,
                String image) {

        this.menuId = menuId;
        this.restaurantId = restaurantId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.available = available;
        this.category = category;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
        this.image = image;

    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
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

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
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
    public String getImage() {
        return image;
    }

    public String getImagePath() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "Menu [menuId=" + menuId
                + ", restaurantId=" + restaurantId
                + ", itemName=" + itemName
                + ", description=" + description
                + ", price=" + price
                + ", available=" + available
                + ", category=" + category
                +",image=" + image
                + "]";
    }
}