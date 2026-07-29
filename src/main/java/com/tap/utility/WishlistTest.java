package com.tap.utility;


import java.util.List;

import com.tap.daoimplementation.WishlistDAOImpl;
import com.tap.model.Wishlist;


public class WishlistTest {


    public static void main(String[] args) {


        WishlistDAOImpl dao =
                new WishlistDAOImpl();




        // ADD


        Wishlist wishlist =
                new Wishlist();


        wishlist.setUserId(1);

        wishlist.setMenuItemId(1);



        dao.addWishlist(wishlist);






        // GET


        System.out.println(
                dao.getWishlist(1)
        );







        // GET USER WISHLIST


        List<Wishlist> list =
                dao.getWishlistByUser(1);



        for(Wishlist w : list){

            System.out.println(w);

        }






        // CHECK EXISTS


        System.out.println(
                dao.exists(1,1)
        );






        // DELETE

        // dao.deleteWishlist(1);


    }

}