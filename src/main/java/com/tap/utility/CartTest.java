package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.CartDAOImpl;
import com.tap.model.Cart;


public class CartTest {


    public static void main(String[] args) {


        CartDAOImpl dao = new CartDAOImpl();



        // ==========================
        // ADD CART
        // ==========================

        Cart cart = new Cart();

        cart.setUserId(1);


        dao.addCart(cart);




        // ==========================
        // GET CART
        // ==========================

        Cart result = dao.getCart(1);


        System.out.println(result);




        // ==========================
        // GET CART BY USER
        // ==========================

        Cart userCart = dao.getCartByUser(1);


        System.out.println(userCart);





        // ==========================
        // GET ALL CARTS
        // ==========================

        List<Cart> carts = dao.getAllCarts();


        for(Cart c : carts) {

            System.out.println(c);

        }





        // ==========================
        // UPDATE CART
        // ==========================

        Cart update = dao.getCart(1);


        if(update != null) {


            update.setUserId(2);


            dao.updateCart(update);

        }





        // ==========================
        // CHECK CART EXISTS
        // ==========================

        boolean exists = dao.cartExists(1);


        System.out.println("Cart Exists : " + exists);





        // ==========================
        // DELETE CART
        // ==========================

        // dao.deleteCart(1);

    }

}