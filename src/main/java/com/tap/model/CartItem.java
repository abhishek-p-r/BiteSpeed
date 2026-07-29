package com.tap.model;


public class CartItem {


    private int cartItemId;

    private int cartId;

    private int menuId;

    private int restaurantId;

    private String name;

    private String imagePath;

    private int quantity;

    private double price;



    public CartItem() {

    }




    public CartItem(
            int menuId,
            int restaurantId,
            String name,
            double price,
            int quantity,
            String imagePath
    ) {

        this.menuId = menuId;
        this.restaurantId = restaurantId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.imagePath = imagePath;

    }






    public int getCartItemId() {
        return cartItemId;
    }


    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }






    public int getCartId() {
        return cartId;
    }


    public void setCartId(int cartId) {
        this.cartId = cartId;
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






    public String getName() {
        return name;
    }


    public void setName(String name) {
        this.name = name;
    }






    public String getImagePath() {
        return imagePath;
    }


    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }






    public int getQuantity() {
        return quantity;
    }


    public void setQuantity(int quantity) {


        if(quantity < 1){

            this.quantity = 1;

        }
        else{

            this.quantity = quantity;

        }

    }






    public double getPrice() {
        return price;
    }


    public void setPrice(double price) {


        if(price < 0){

            this.price = 0;

        }
        else{

            this.price = price;

        }

    }






    public double getSubTotal() {

        return price * quantity;

    }






    @Override
    public String toString() {

        return "CartItem{" +

                "cartItemId=" + cartItemId +

                ", cartId=" + cartId +

                ", menuId=" + menuId +

                ", restaurantId=" + restaurantId +

                ", name='" + name + '\'' +

                ", imagePath='" + imagePath + '\'' +

                ", quantity=" + quantity +

                ", price=" + price +

                '}';

    }


}