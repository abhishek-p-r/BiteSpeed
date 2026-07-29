package com.tap.model;

import java.sql.Timestamp;


public class Wishlist {


    private int wishlistId;

    private int userId;

    private int menuItemId;

    private Timestamp createdAt;



    public Wishlist(){}




    public int getWishlistId() {
        return wishlistId;
    }


    public void setWishlistId(int wishlistId) {
        this.wishlistId = wishlistId;
    }



    public int getUserId() {
        return userId;
    }


    public void setUserId(int userId) {
        this.userId = userId;
    }



    public int getMenuItemId() {
        return menuItemId;
    }


    public void setMenuItemId(int menuItemId) {
        this.menuItemId = menuItemId;
    }



    public Timestamp getCreatedAt() {
        return createdAt;
    }


    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }



    @Override
    public String toString() {

        return "Wishlist [wishlistId="
                + wishlistId
                + ", userId="
                + userId
                + ", menuItemId="
                + menuItemId
                + ", createdAt="
                + createdAt
                + "]";

    }

}