package com.tap.utility;

import java.util.List;

import com.tap.daoimplementation.RestaurantImageDAOImpl;
import com.tap.model.RestaurantImage;

public class RestaurantImageTest {

    public static void main(String[] args) {

        RestaurantImageDAOImpl dao = new RestaurantImageDAOImpl();


        // ==========================
        // ADD IMAGE
        // ==========================

        RestaurantImage image = new RestaurantImage();

        image.setRestaurantId(1);
        image.setImageUrl("images/empire.jpg");
        image.setImageType("Restaurant");
        image.setDisplayOrder(1);

        dao.addImage(image);



        // ==========================
        // GET IMAGE
        // ==========================

        RestaurantImage result = dao.getImage(1);

        System.out.println(result);



        // ==========================
        // GET ALL IMAGES BY RESTAURANT
        // ==========================

        List<RestaurantImage> images =
                dao.getImagesByRestaurant(1);


        for(RestaurantImage img : images) {

            System.out.println(img);

        }



        // ==========================
        // UPDATE IMAGE
        // ==========================

        RestaurantImage update = dao.getImage(1);

        if(update != null) {

            update.setImageUrl("images/new.jpg");

            dao.updateImage(update);

        }



        // ==========================
        // DELETE IMAGE
        // ==========================

        // dao.deleteImage(1);

    }

}