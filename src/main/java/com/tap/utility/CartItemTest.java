package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.CartItemDAOImpl;
import com.tap.model.CartItem;



public class CartItemTest {


    public static void main(String[] args) {


        CartItemDAOImpl dao = new CartItemDAOImpl();



        // ==========================
        // ADD CART ITEM
        // ==========================

        CartItem item = new CartItem();


        item.setCartId(1);
        item.setMenuId(1);
        item.setQuantity(2);
        item.setPrice(250.00);


        dao.addCartItem(item);





        // ==========================
        // GET CART ITEM
        // ==========================

        CartItem cartItem = dao.getCartItem(1);


        System.out.println("Single Cart Item:");
        System.out.println(cartItem);






        // ==========================
        // GET ALL CART ITEMS
        // ==========================

        System.out.println("\nAll Cart Items:");

        List<CartItem> items = dao.getAllCartItems();


        for(CartItem i : items){

            System.out.println(i);

        }






        // ==========================
        // GET CART ITEMS BY CART
        // ==========================

        System.out.println("\nCart Items By Cart ID:");

        List<CartItem> cartItems =
                dao.getCartItemsByCart(1);


        for(CartItem i : cartItems){

            System.out.println(i);

        }







        // ==========================
        // UPDATE CART ITEM
        // ==========================

        CartItem update = dao.getCartItem(1);


        if(update != null){


            update.setQuantity(5);
            update.setPrice(500.00);


            dao.updateCartItem(update);


            System.out.println("Cart Item Updated");

        }







        // ==========================
        // CHECK EXISTS
        // ==========================

        boolean exists = dao.cartItemExists(1);


        System.out.println("\nCart Item Exists : " + exists);







        // ==========================
        // DELETE CART ITEM
        // ==========================

        // dao.deleteCartItem(1);


    }

}